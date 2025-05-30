<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Hẹn - KimiBeauty</title>
    <jsp:include page="_header_customer.jsp" />
    <style>
        .selected-services-container .service-item { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid var(--border-soft); }
        .selected-services-container .service-item:last-child { border-bottom: none; }
        .service-item span { flex-grow: 1; color: var(--text-dark-gray); }
        .remove-service-btn { margin-left: 15px; padding: 0.2rem 0.5rem; font-size: 0.9rem; }
        #availableSlotsContainer .time-slot { margin: 5px; font-size: 0.9rem; padding: 8px 12px; border-radius: var(--border-radius-small); }
        .summary-text strong { color: var(--accent-pink); }
    </style>
</head>
<body>
<div class="customer-page-container">
    <h1 class="customer-page-title">Đặt Lịch Hẹn</h1>
    <p class="customer-page-subtitle">Vui lòng chọn dịch vụ và thời gian phù hợp để chúng tôi phục vụ bạn tốt nhất.</p>

    <div class="booking-form-container animated-fadeInUpSlight">
        <c:if test="${not empty bookingErrorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <c:out value="${bookingErrorMessage}"/>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            </div>
        </c:if>

        <form id="bookingForm" action="${pageContext.request.contextPath}/customer/book-appointment/submit" method="post">
            <h4>1. Chọn Dịch Vụ Yêu Thích</h4>
            <div class="form-group">
                <label for="serviceSelect" class="font-weight-bold">Thêm dịch vụ vào lịch hẹn:</label>
                <div class="input-group">
                    <select id="serviceSelect" class="custom-select">
                        <option value="">-- Vui lòng chọn dịch vụ --</option>
                        <c:forEach var="service" items="${serviceList}">
                            <option value="${service.serviceId}" data-price="${service.price}" data-duration="${service.durationMinutes}">
                                <c:out value="${service.serviceName}"/> (<fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫"/> - ${service.durationMinutes} phút)
                            </option>
                        </c:forEach>
                    </select>
                    <div class="input-group-append">
                        <button type="button" id="addServiceButton" class="btn btn-secondary-custom">Thêm</button>
                    </div>
                </div>
            </div>

            <div id="selectedServicesContainer" class="mb-3 p-3 bg-light" style="border-radius: var(--border-radius-medium);">
                <p class="font-weight-bold mb-2">Dịch vụ đã chọn:</p>
                <c:if test="${empty preSelectedServiceId}">
                    <small class="text-muted d-block" id="noServiceSelectedText">Chưa chọn dịch vụ nào.</small>
                </c:if>
            </div>

            <div class="summary-text">
                <p class="mb-1"><strong>Tổng thời gian dự kiến:</strong> <span id="totalDuration" class="font-weight-bold">0</span> phút</p>
                <p><strong>Tổng tiền dịch vụ (tạm tính):</strong> <span id="totalPrice" class="font-weight-bold" style="font-size: 1.1rem;">0 ₫</span></p>
            </div>
            <hr class="my-4">

            <h4>2. Chọn Ngày & Giờ Phù Hợp</h4>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="selectedDate" class="font-weight-bold">Chọn Ngày (*):</label>
                    <input type="date" class="form-control" id="selectedDate" name="selectedDate" required
                           min="<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd"/>">
                </div>
                <div class="form-group col-md-6">
                    <label for="staffId" class="font-weight-bold">Chọn Nhân Viên (tùy chọn):</label>
                    <select class="custom-select" id="staffId" name="staffId">
                        <option value="0">Bất kỳ nhân viên nào rảnh</option>
                        <c:forEach var="staff" items="${staffList}">
                            <option value="${staff.userId}"><c:out value="${staff.fullName}"/></option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="font-weight-bold">Chọn Giờ Hẹn Khả Dụng (*):</label>
                <div id="availableSlotsContainer" class="d-flex flex-wrap p-2 bg-light" style="border-radius: var(--border-radius-small);">
                    <small class="text-muted w-100">Vui lòng chọn ngày và dịch vụ để xem giờ trống.</small>
                </div>
                <input type="hidden" id="selectedTime" name="selectedTime" required>
            </div>
            <hr class="my-4">

            <h4>3. Thông Tin Bổ Sung</h4>
            <div class="form-group">
                <label for="customerNotes" class="font-weight-bold">Ghi Chú (nếu có):</label>
                <textarea class="form-control" id="customerNotes" name="customerNotes" rows="3" placeholder="Ví dụ: Tôi muốn làm mẫu A, da tôi nhạy cảm..."></textarea>
            </div>

            <button type="submit" class="btn btn-primary-custom-filled btn-lg btn-block mt-4">Xác Nhận Đặt Lịch</button>
        </form>
    </div>
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
        const noServiceSelectedText = $('#noServiceSelectedText');
        const totalDurationSpan = $('#totalDuration');
        const totalPriceSpan = $('#totalPrice');
        const selectedDateInput = $('#selectedDate');
        const staffIdSelect = $('#staffId');
        const availableSlotsContainer = $('#availableSlotsContainer');
        const selectedTimeInput = $('#selectedTime');

        const preSelectedServiceId = parseInt('${preSelectedServiceId}');
        if (preSelectedServiceId && !isNaN(preSelectedServiceId)) {
            serviceSelect.val(preSelectedServiceId);
            $('#addServiceButton').click();
        }

        $('#addServiceButton').on('click', function() {
            const selectedOption = serviceSelect.find('option:selected');
            const serviceIdString = selectedOption.val();
            if (!serviceIdString) return;
            const serviceId = parseInt(serviceIdString);
            const serviceName = selectedOption.text().split('(')[0].trim();
            const servicePrice = parseFloat(selectedOption.data('price'));
            const serviceDuration = parseInt(selectedOption.data('duration'));

            if (serviceId && !selectedServices.find(s => s.id === serviceId)) {
                selectedServices.push({ id: serviceId, name: serviceName, price: servicePrice, duration: serviceDuration, nailArtId: null, nailArtPrice: 0 });
                updateSelectedServicesUI();
                updateSummaryAndFetchSlots();
            }
            serviceSelect.val('');
        });

        selectedServicesContainer.on('click', '.remove-service-btn', function() {
            const serviceIdToRemove = parseInt($(this).data('serviceId'));
            selectedServices = selectedServices.filter(s => s.id !== serviceIdToRemove);
            updateSelectedServicesUI();
            updateSummaryAndFetchSlots();
        });

        selectedServicesContainer.on('change', '.nailart-for-service', function(){
            const serviceId = parseInt($(this).data('serviceId'));
            const nailArtIdSelected = $(this).val();
            const nailArtId = nailArtIdSelected === "0" || nailArtIdSelected === "" ? null : parseInt(nailArtIdSelected);
            const nailArtPrice = nailArtId ? parseFloat($(this).find('option:selected').data('price')) : 0;

            const serviceIndex = selectedServices.findIndex(s => s.id === serviceId);
            if(serviceIndex > -1){
                selectedServices[serviceIndex].nailArtId = nailArtId;
                selectedServices[serviceIndex].nailArtPrice = nailArtPrice;
            }
            updateSummary();
        });

        function updateSelectedServicesUI() {
            selectedServicesContainer.find('.service-item').remove();
            if (selectedServices.length === 0) {
                if(noServiceSelectedText.length === 0){
                    selectedServicesContainer.append('<small class="text-muted d-block" id="noServiceSelectedText">Chưa chọn dịch vụ nào.</small>');
                }
                noServiceSelectedText.show();
            } else {
                noServiceSelectedText.hide();
                selectedServices.forEach(service => {
                    let nailArtOptions = '<option value="0" data-price="0">-- Không chọn mẫu nail --</option>';
                    <c:forEach var="nailArt" items="${nailArtList}">
                    <c:set var="jsNailArtId" value="${nailArt.nailArtId}"/>
                    <c:set var="jsNailArtPrice" value="${nailArt.priceAddon}"/>
                    <c:set var="jsNailArtName"><c:out value="${nailArt.nailArtName}" escapeXml="true"/></c:set>

                    nailArtOptions += '<option value="' + '${jsNailArtId}' + '" data-price="' + '${jsNailArtPrice}' + '"';
                    if (service.nailArtId == parseInt('${jsNailArtId}')) {
                        nailArtOptions += ' selected';
                    }
                    nailArtOptions += '>' + '${jsNailArtName}'.replace(/'/g, "\\'") +
                        ' (+<fmt:formatNumber value="${jsNailArtPrice}" type="currency" currencySymbol="₫"/>)' +
                        '</option>';
                    </c:forEach>

                    const itemHtml = `
                        <div class="service-item" data-service-id="${service.id}">
                            <input type="hidden" name="selectedServiceIds" value="${service.id}">
                            <span>${service.name}</span>
                            <div class="form-group mb-0 ml-2" style="min-width: 220px;">
                               <label for="nailArtForService_${service.id}" class="sr-only">Mẫu nail cho ${service.name}</label>
                               <select name="nailArtForService_${service.id}" id="nailArtForService_${service.id}" class="custom-select custom-select-sm nailart-for-service" data-service-id="${service.id}">
                                   ${nailArtOptions}
                               </select>
                            </div>
                            <button type="button" class="btn btn-outline-danger btn-sm remove-service-btn" data-service-id="${service.id}" title="Xóa dịch vụ">×</button>
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

        function updateSummaryAndFetchSlots(){
            updateSummary();
            fetchAvailableSlots();
        }

        selectedDateInput.on('change', fetchAvailableSlots);
        staffIdSelect.on('change', fetchAvailableSlots);

        function fetchAvailableSlots() {
            const date = selectedDateInput.val();
            const staffId = staffIdSelect.val();
            const duration = totalDuration;

            if (!date || duration === 0) {
                availableSlotsContainer.html('<small class="text-muted w-100 p-2">Vui lòng chọn ngày và ít nhất một dịch vụ để xem giờ trống.</small>');
                selectedTimeInput.val('');
                return;
            }

            availableSlotsContainer.html('<small class="text-muted w-100 p-2">Đang tìm giờ trống, vui lòng đợi...</small>');
            selectedTimeInput.val('');

            $.ajax({
                url: '${pageContext.request.contextPath}/customer/book-appointment/get-available-slots',
                type: 'GET',
                data: { date: date, staffId: staffId, duration: duration },
                success: function(response) {
                    availableSlotsContainer.empty();
                    if (response.error) {
                        availableSlotsContainer.html(`<div class="alert alert-warning w-100 p-2">${response.error}</div>`);
                    } else if (response.slots && response.slots.length > 0) {
                        response.slots.forEach(function(slot) {
                            const slotButton = $('<button type="button" class="btn btn-outline-primary time-slot"></button>').text(slot);
                            slotButton.on('click', function() {
                                $('#availableSlotsContainer .time-slot').removeClass('btn-primary active').addClass('btn-outline-primary');
                                $(this).removeClass('btn-outline-primary').addClass('btn-primary active');
                                selectedTimeInput.val(slot);
                            });
                            availableSlotsContainer.append(slotButton);
                        });
                    } else {
                        availableSlotsContainer.html('<small class="text-muted w-100 p-2">Rất tiếc, không có giờ trống phù hợp cho lựa chọn của bạn.</small>');
                    }
                },
                error: function() {
                    availableSlotsContainer.html('<small class="text-danger w-100 p-2">Lỗi khi tải giờ trống. Vui lòng thử lại hoặc liên hệ với chúng tôi.</small>');
                }
            });
        }
    });
</script>
</body>
</html>