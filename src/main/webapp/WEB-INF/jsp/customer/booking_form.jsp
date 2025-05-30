<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt Lịch Hẹn - Tiệm Nail</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .selected-services-container .service-item { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; border-bottom: 1px solid #eee; }
        .service-item span { flex-grow: 1; }
        .remove-service-btn { margin-left: 10px; }
        #availableSlotsContainer .time-slot { margin: 5px; }
    </style>
</head>
<body>
<jsp:include page="_header_customer.jsp" />

<div class="container mt-4 mb-5">
    <h2 class="text-center mb-4">Đặt Lịch Hẹn</h2>

    <c:if test="${not empty bookingErrorMessage}">
        <div class="alert alert-danger"><c:out value="${bookingErrorMessage}"/></div>
    </c:if>
    <c:if test="${not empty requestScope.bookingSuccessMessage}">
        <div class="alert alert-success"><c:out value="${requestScope.bookingSuccessMessage}"/></div>
    </c:if>


    <form id="bookingForm" action="${pageContext.request.contextPath}/customer/book-appointment/submit" method="post">
        <h4>1. Chọn Dịch Vụ</h4>
        <div class="form-group">
            <label for="serviceSelect">Thêm dịch vụ:</label>
            <div class="input-group">
                <select id="serviceSelect" class="form-control">
                    <option value="">-- Chọn dịch vụ --</option>
                    <c:forEach var="service" items="${serviceList}">
                        <option value="${service.serviceId}" data-price="${service.price}" data-duration="${service.durationMinutes}">
                            <c:out value="${service.serviceName}"/> (<fmt:formatNumber value="${service.price}" type="currency"/> - ${service.durationMinutes} phút)
                        </option>
                    </c:forEach>
                </select>
                <div class="input-group-append">
                    <button type="button" id="addServiceButton" class="btn btn-info">Thêm</button>
                </div>
            </div>
        </div>

        <div id="selectedServicesContainer" class="mb-3">
            <p><strong>Dịch vụ đã chọn:</strong></p>
            <%-- Các dịch vụ đã chọn sẽ được thêm vào đây bằng JavaScript --%>
            <c:if test="${empty preSelectedServiceId}">
                <small class="text-muted">Chưa chọn dịch vụ nào.</small>
            </c:if>
        </div>

        <p><strong>Tổng thời gian dự kiến:</strong> <span id="totalDuration">0</span> phút</p>
        <p><strong>Tổng tiền dịch vụ (tạm tính):</strong> <span id="totalPrice">0</span> ₫</p>
        <hr>

        <h4>2. Chọn Ngày & Giờ</h4>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="selectedDate">Chọn Ngày (*):</label>
                <input type="date" class="form-control" id="selectedDate" name="selectedDate" required
                       min="<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd"/>">
            </div>
            <div class="form-group col-md-6">
                <label for="staffId">Chọn Nhân Viên (tùy chọn):</label>
                <select class="form-control" id="staffId" name="staffId">
                    <option value="0">Bất kỳ nhân viên nào</option>
                    <c:forEach var="staff" items="${staffList}">
                        <option value="${staff.userId}"><c:out value="${staff.fullName}"/></option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label>Chọn Giờ Hẹn (*):</label>
            <div id="availableSlotsContainer" class="d-flex flex-wrap">
                <small class="text-muted w-100">Vui lòng chọn ngày (và nhân viên nếu muốn) để xem giờ trống.</small>
            </div>
            <input type="hidden" id="selectedTime" name="selectedTime" required>
        </div>
        <hr>

        <h4>3. Thông Tin Thêm</h4>
        <div class="form-group">
            <label for="customerNotes">Ghi Chú Cho Tiệm:</label>
            <textarea class="form-control" id="customerNotes" name="customerNotes" rows="3"></textarea>
        </div>

        <button type="submit" class="btn btn-primary btn-lg btn-block">Xác Nhận Đặt Lịch</button>
    </form>
</div>

<jsp:include page="_footer_customer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        let selectedServices = [];
        let totalDuration = 0;
        let totalPrice = 0;
        const serviceSelect = $('#serviceSelect');
        const selectedServicesContainer = $('#selectedServicesContainer');
        const totalDurationSpan = $('#totalDuration');
        const totalPriceSpan = $('#totalPrice');
        const selectedDateInput = $('#selectedDate');
        const staffIdSelect = $('#staffId');
        const availableSlotsContainer = $('#availableSlotsContainer');
        const selectedTimeInput = $('#selectedTime');

        // Pre-select service if serviceId is passed
        const preSelectedServiceId = parseInt('${preSelectedServiceId}');
        if (preSelectedServiceId && !isNaN(preSelectedServiceId)) {
            serviceSelect.val(preSelectedServiceId);
            $('#addServiceButton').click();
        }


        $('#addServiceButton').on('click', function() {
            const selectedOption = serviceSelect.find('option:selected');
            const serviceId = selectedOption.val();
            const serviceName = selectedOption.text().split('(')[0].trim();
            const servicePrice = parseFloat(selectedOption.data('price'));
            const serviceDuration = parseInt(selectedOption.data('duration'));

            if (serviceId && !selectedServices.find(s => s.id === serviceId)) {
                selectedServices.push({ id: serviceId, name: serviceName, price: servicePrice, duration: serviceDuration, nailArtId: null, nailArtPrice: 0 });
                updateSelectedServicesUI();
                updateSummary();
                fetchAvailableSlots();
            }
            serviceSelect.val('');
        });

        selectedServicesContainer.on('click', '.remove-service-btn', function() {
            const serviceIdToRemove = $(this).data('serviceId');
            selectedServices = selectedServices.filter(s => s.id !== serviceIdToRemove);
            updateSelectedServicesUI();
            updateSummary();
            fetchAvailableSlots();
        });

        selectedServicesContainer.on('change', '.nailart-for-service', function(){
            const serviceId = $(this).data('serviceId');
            const nailArtId = $(this).val() === "0" ? null : parseInt($(this).val());
            const nailArtPrice = nailArtId ? parseFloat($(this).find('option:selected').data('price')) : 0;

            const serviceIndex = selectedServices.findIndex(s => s.id === serviceId);
            if(serviceIndex > -1){
                selectedServices[serviceIndex].nailArtId = nailArtId;
                selectedServices[serviceIndex].nailArtPrice = nailArtPrice;
            }
            updateSummary();
        });

        function updateSelectedServicesUI() {
            selectedServicesContainer.find('.service-item, .text-muted').remove();
            if (selectedServices.length === 0) {
                selectedServicesContainer.append('<small class="text-muted">Chưa chọn dịch vụ nào.</small>');
            } else {
                selectedServices.forEach(service => {
                    let nailArtOptions = '<option value="0" data-price="0">-- Không chọn mẫu nail --</option>';
                    <c:forEach var="nailArt" items="${nailArtList}">
                    <c:set var="nailArtIdForJs" value="${nailArt.nailArtId}"/>
                    <c:set var="nailArtPriceForJs" value="${nailArt.priceAddon}"/>
                    <c:set var="nailArtNameForJs">
                    <c:out value="${nailArt.nailArtName}" escapeXml="false"/> <%-- Tạm thời không escape để xử lý trong JS, nhưng cần cẩn thận XSS --%>
                    </c:set>
                    <c:set var="isSelectedCondition" value="${service.nailArtId == nailArt.nailArtId}"/> <%-- Tính toán điều kiện trước --%>

                    nailArtOptions += '<option value="' + '${nailArtIdForJs}' + '" data-price="' + '${nailArtPriceForJs}' + '"';
                    <c:if test="${isSelectedCondition}">
                    nailArtOptions += ' selected';
                    </c:if>
                    nailArtOptions += '>' + '${nailArtNameForJs}'.replace(/'/g, "\\'") +
                        ' (+<fmt:formatNumber value="${nailArtPriceForJs}" type="currency"/>)' +
                        '</option>';
                    </c:forEach>

                    const itemHtml = `
                            <div class="service-item" data-service-id="${service.id}">
                                <input type="hidden" name="selectedServiceIds" value="${service.id}">
                                <span>${service.name}</span>
                                <div class="form-group mb-0 ml-2" style="min-width: 200px;">
                                   <select name="nailArtForService_${service.id}" class="form-control form-control-sm nailart-for-service" data-service-id="${service.id}">
                                       ${nailArtOptions}
                                   </select>
                                </div>
                                <button type="button" class="btn btn-danger btn-sm remove-service-btn" data-service-id="${service.id}">×</button>
                            </div>`;
                    selectedServicesContainer.append(itemHtml);
                });
            }
        }

        function updateSummary() {
            totalDuration = 0;
            totalPrice = 0;
            selectedServices.forEach(service => {
                totalDuration += service.duration;
                totalPrice += service.price;
                if(service.nailArtId && service.nailArtPrice){
                    totalPrice += service.nailArtPrice;
                }
            });
            totalDurationSpan.text(totalDuration);
            totalPriceSpan.text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(totalPrice));
        }

        selectedDateInput.on('change', fetchAvailableSlots);
        staffIdSelect.on('change', fetchAvailableSlots);

        function fetchAvailableSlots() {
            const date = selectedDateInput.val();
            const staffId = staffIdSelect.val();
            const duration = totalDuration;

            if (!date || duration === 0) {
                availableSlotsContainer.html('<small class="text-muted w-100">Vui lòng chọn ngày và ít nhất một dịch vụ.</small>');
                selectedTimeInput.val('');
                return;
            }

            availableSlotsContainer.html('<small class="text-muted w-100">Đang tải giờ trống...</small>');
            selectedTimeInput.val('');


            $.ajax({
                url: '${pageContext.request.contextPath}/customer/book-appointment/get-available-slots',
                type: 'GET',
                data: {
                    date: date,
                    staffId: staffId,
                    duration: duration
                },
                success: function(response) {
                    availableSlotsContainer.empty();
                    if (response.error) {
                        availableSlotsContainer.html(`<small class="text-danger w-100">${response.error}</small>`);
                    } else if (response.slots && response.slots.length > 0) {
                        response.slots.forEach(function(slot) {
                            const slotButton = $('<button type="button" class="btn btn-outline-primary time-slot"></button>').text(slot);
                            slotButton.on('click', function() {
                                $('.time-slot').removeClass('btn-primary').addClass('btn-outline-primary');
                                $(this).removeClass('btn-outline-primary').addClass('btn-primary');
                                selectedTimeInput.val(slot);
                            });
                            availableSlotsContainer.append(slotButton);
                        });
                    } else {
                        availableSlotsContainer.html('<small class="text-muted w-100">Không có giờ trống cho ngày này hoặc nhân viên này.</small>');
                    }
                },
                error: function() {
                    availableSlotsContainer.html('<small class="text-danger w-100">Lỗi khi tải giờ trống. Vui lòng thử lại.</small>');
                }
            });
        }
    });
</script>
</body>
</html>