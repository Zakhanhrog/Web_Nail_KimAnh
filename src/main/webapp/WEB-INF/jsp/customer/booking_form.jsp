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
</head>
<body>
<div class="customer-page-container">
    <h1 class="customer-page-title">Đặt Lịch Hẹn</h1>
    <p class="customer-page-subtitle">Vui lòng chọn dịch vụ và thời gian phù hợp để chúng tôi phục vụ bạn tốt nhất.</p>

    <div class="booking-form-wrapper">
        <c:if test="${not empty bookingErrorMessage}">
            <div class="alert alert-danger alert-dismissible fade show booking-alert" role="alert">
                <c:out value="${bookingErrorMessage}"/>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            </div>
        </c:if>

        <form id="bookingForm" action="${pageContext.request.contextPath}/customer/book-appointment/submit" method="post">
            <div class="booking-form-section">
                <h4 class="booking-section-title">1. Chọn Dịch Vụ Yêu Thích</h4>
                <div class="form-group">
                    <label for="serviceSelect" class="form-label-custom">Thêm dịch vụ vào lịch hẹn:</label>
                    <div class="input-group add-service-group">
                        <select id="serviceSelect" class="custom-select">
                            <option value="">-- Vui lòng chọn dịch vụ --</option>
                            <c:forEach var="service" items="${serviceList}">
                                <option value="${service.serviceId}" data-price="${service.price}" data-duration="${service.durationMinutes}">
                                    <c:out value="${service.serviceName}"/> (<fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/> - ${service.durationMinutes} phút)
                                </option>
                            </c:forEach>
                        </select>
                        <div class="input-group-append">
                            <button type="button" id="addServiceButton" class="btn btn-secondary-custom btn-add-service">Thêm</button>
                        </div>
                    </div>
                </div>

                <div id="selectedServicesContainer" class="selected-services-area">
                    <p class="selected-services-title">Dịch vụ đã chọn:</p>
                    <c:if test="${empty preSelectedServiceId && empty selectedServicesFromServlet}">
                        <small class="text-muted d-block no-service-text" id="noServiceSelectedText">Chưa chọn dịch vụ nào.</small>
                    </c:if>
                </div>

                <div class="booking-summary-text">
                    <p><strong class="summary-label">Tổng thời gian dự kiến:</strong> <span id="totalDuration" class="summary-value">0</span> phút</p>
                    <p><strong class="summary-label">Tổng tiền dịch vụ (tạm tính):</strong> <span id="totalPrice" class="summary-value total-price-value">0 ₫</span></p>
                </div>
            </div>

            <div class="booking-form-section">
                <h4 class="booking-section-title">2. Chọn Ngày & Giờ Phù Hợp</h4>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="selectedDate" class="form-label-custom">Chọn Ngày (*):</label>
                        <input type="date" class="form-control custom-form-control" id="selectedDate" name="selectedDate" required
                               min="<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd"/>">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="staffId" class="form-label-custom">Chọn Nhân Viên (tùy chọn):</label>
                        <select class="custom-select custom-form-control" id="staffId" name="staffId">
                            <option value="0">Bất kỳ nhân viên nào rảnh</option>
                            <c:forEach var="staff" items="${staffList}">
                                <option value="${staff.userId}"><c:out value="${staff.fullName}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label-custom">Chọn Giờ Hẹn Khả Dụng (*):</label>
                    <div id="availableSlotsContainer" class="available-slots-area">
                        <small class="text-muted w-100 no-slots-text">Vui lòng chọn ngày và ít nhất một dịch vụ để xem giờ trống.</small>
                    </div>
                    <input type="hidden" id="selectedTime" name="selectedTime" required>
                </div>
            </div>

            <div class="booking-form-section">
                <h4 class="booking-section-title">3. Thông Tin Bổ Sung</h4>
                <div class="form-group">
                    <label for="customerNotes" class="form-label-custom">Ghi Chú (nếu có):</label>
                    <textarea class="form-control custom-form-control" id="customerNotes" name="customerNotes" rows="4" placeholder="Ví dụ: Tôi muốn làm mẫu A, da tôi nhạy cảm..."></textarea>
                </div>
            </div>

            <div class="booking-submit-section">
                <button type="submit" class="btn btn-primary-custom-filled btn-lg btn-block btn-submit-booking">Xác Nhận Đặt Lịch</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="_footer_customer.jsp" />
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        window.nailArtDataForJs = [];
        <c:forEach var="nailArt" items="${nailArtList}">
        window.nailArtDataForJs.push({
            nailArtId: parseInt('${nailArt.nailArtId}'),
            nailArtName: String.raw`${nailArt.nailArtName}`.replace(/'/g, "\\'").replace(/"/g, '\\"'),
            priceAddon: parseFloat('${nailArt.priceAddon}')
        });
        </c:forEach>

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
            const optionToSelect = serviceSelect.find('option[value="' + preSelectedServiceId + '"]');
            if(optionToSelect.length){
                optionToSelect.prop('selected', true);
                $('#addServiceButton').click();
            }
        }

        $('#addServiceButton').on('click', function() {
            const selectedOption = serviceSelect.find('option:selected');
            const serviceIdString = selectedOption.val();

            if (!serviceIdString) {
                console.log("Chưa chọn dịch vụ từ dropdown.");
                return;
            }

            const serviceId = parseInt(serviceIdString);

            let fullOptionText = selectedOption.text();
            let serviceName = fullOptionText;

            const indexOfDetails = fullOptionText.indexOf(" (");
            if (indexOfDetails !== -1) {
                serviceName = fullOptionText.substring(0, indexOfDetails).trim();
            } else {
                const indexOfParenthesis = fullOptionText.indexOf("(");
                if (indexOfParenthesis !== -1) {
                    serviceName = fullOptionText.substring(0, indexOfParenthesis).trim();
                } else {
                    serviceName = fullOptionText.trim();
                }
            }

            const servicePrice = parseFloat(selectedOption.data('price'));
            const serviceDuration = parseInt(selectedOption.data('duration'));

            console.log("--- Bắt đầu thêm dịch vụ ---");
            console.log("ID Dịch Vụ:", serviceId);
            console.log("Text Gốc từ Option:", fullOptionText);
            console.log("Tên Dịch Vụ (đã xử lý):", serviceName);
            console.log("Giá:", servicePrice);
            console.log("Thời gian:", serviceDuration);
            console.log("--- Kết thúc thông tin ---");

            if (serviceId && serviceName && serviceName.length > 0 && !isNaN(servicePrice) && !isNaN(serviceDuration)) {
                if (!selectedServices.find(s => s.id === serviceId)) {
                    selectedServices.push({
                        id: serviceId,
                        name: serviceName,
                        price: servicePrice,
                        duration: serviceDuration,
                        nailArtId: null,
                        nailArtPrice: 0
                    });
                    updateSelectedServicesUI();
                    updateSummaryAndFetchSlots();
                } else {
                    alert("Dịch vụ này đã được thêm vào danh sách.");
                }
            } else {
                console.error("Dữ liệu không hợp lệ để thêm dịch vụ:", {serviceId, serviceName, servicePrice, serviceDuration});
                alert("Không thể thêm dịch vụ. Vui lòng thử lại hoặc chọn dịch vụ khác.");
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
            updateSummaryAndFetchSlots();
        });

        function updateSelectedServicesUI() {
            selectedServicesContainer.find('.service-item').remove();

            if (noServiceSelectedText.length > 0) {
                if (selectedServices.length === 0) {
                    noServiceSelectedText.show();
                } else {
                    noServiceSelectedText.hide();
                }
            } else {
                if (selectedServices.length === 0 && selectedServicesContainer.find('#noServiceSelectedText').length === 0) {
                    selectedServicesContainer.append('<small class="text-muted d-block no-service-text" id="noServiceSelectedText">Chưa chọn dịch vụ nào.</small>');
                } else if (selectedServices.length > 0) {
                    $('#noServiceSelectedText').remove();
                }
            }

            selectedServices.forEach(service => {
                console.log("Đang render dịch vụ trong UI (trước khi tạo HTML):", service);

                let nailArtOptionsHtml = '<option value="0" data-price="0">-- Không chọn mẫu nail --</option>';

                if (window.nailArtDataForJs && window.nailArtDataForJs.length > 0) {
                    window.nailArtDataForJs.forEach(nailArt => {
                        const currentId = nailArt.nailArtId;
                        const currentPrice = nailArt.priceAddon;
                        let currentName = nailArt.nailArtName;

                        let optionSingleHtml = `<option value="${currentId}" data-price="${currentPrice}"`;
                        if (service.nailArtId != null && service.nailArtId === currentId) {
                            optionSingleHtml += ' selected';
                        }

                        const formattedPrice = new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND',
                            minimumFractionDigits: 0,
                            maximumFractionDigits: 0
                        }).format(currentPrice);

                        optionSingleHtml += `>${currentName} (+${formattedPrice})</option>`;
                        nailArtOptionsHtml += optionSingleHtml;
                    });
                }

                const serviceNameText = service.name ? service.name : 'Lỗi tên dịch vụ';
                const labelForNailArt = service.name ? service.name : 'dịch vụ';

                const itemHtmlString = `
                    <div class="service-item" data-service-id="${service.id}">
                        <input type="hidden" name="selectedServiceIdsArray[${selectedServices.indexOf(service)}].serviceId" value="${service.id}">
                        <span class="service-name-display"></span>
                        <div class="form-group service-nailart-select-group mb-0">
                           <label for="nailArtForService_${service.id}" class="sr-only">Mẫu nail cho ${labelForNailArt}</label>
                           <select name="selectedServiceIdsArray[${selectedServices.indexOf(service)}].nailArtId" id="nailArtForService_${service.id}" class="custom-select nailart-for-service" data-service-id="${service.id}">
                               ${nailArtOptionsHtml}
                           </select>
                        </div>
                        <button type="button" class="btn btn-outline-danger btn-sm remove-service-btn" data-service-id="${service.id}" title="Xóa dịch vụ">×</button>
                    </div>`;

                const newItem = $(itemHtmlString);
                newItem.find('.service-name-display').text(serviceNameText);
                selectedServicesContainer.append(newItem);
            });
        }

        function updateSummary() {
            totalDuration = 0;
            totalPrice = 0;

            $('#bookingForm input[name^="selectedServiceIdsArray"]').remove();

            selectedServices.forEach((service, index) => {
                totalDuration += service.duration;
                totalPrice += service.price;

                $('#bookingForm').append(`<input type="hidden" name="selectedServiceIdsArray[${index}].serviceId" value="${service.id}">`);

                if(service.nailArtId && service.nailArtPrice > 0){
                    totalPrice += service.nailArtPrice;
                    $('#bookingForm').append(`<input type="hidden" name="selectedServiceIdsArray[${index}].nailArtId" value="${service.nailArtId}">`);
                } else {
                    $('#bookingForm').append(`<input type="hidden" name="selectedServiceIdsArray[${index}].nailArtId" value="">`);
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
                availableSlotsContainer.html('<small class="text-muted w-100 p-2 no-slots-text">Vui lòng chọn ngày và ít nhất một dịch vụ để xem giờ trống.</small>');
                selectedTimeInput.val('');
                $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                return;
            }

            availableSlotsContainer.html('<small class="text-muted w-100 p-2 slots-loading-text">Đang tìm giờ trống, vui lòng đợi...</small>');
            selectedTimeInput.val('');
            $('#bookingForm').find('button[type="submit"]').prop('disabled', true);


            $.ajax({
                url: '${pageContext.request.contextPath}/customer/book-appointment/get-available-slots',
                type: 'GET',
                data: { date: date, staffId: staffId, duration: duration },
                success: function(response) {
                    availableSlotsContainer.empty();
                    if (response.error) {
                        availableSlotsContainer.html(`<div class="alert alert-warning w-100 slots-message">${response.error}</div>`);
                        $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                    } else if (response.slots && response.slots.length > 0) {
                        response.slots.forEach(function(slot) {
                            const slotButton = $('<button type="button" class="btn btn-outline-primary time-slot"></button>').text(slot);
                            slotButton.on('click', function() {
                                $('#availableSlotsContainer .time-slot').removeClass('btn-primary active').addClass('btn-outline-primary');
                                $(this).removeClass('btn-outline-primary').addClass('btn-primary active');
                                selectedTimeInput.val(slot);
                                $('#bookingForm').find('button[type="submit"]').prop('disabled', false);
                            });
                            availableSlotsContainer.append(slotButton);
                        });
                    } else {
                        availableSlotsContainer.html('<small class="text-muted w-100 p-2 slots-message no-slots-text">Rất tiếc, không có giờ trống phù hợp cho lựa chọn của bạn.</small>');
                        $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                    }
                },
                error: function() {
                    availableSlotsContainer.html('<div class="alert alert-danger w-100 slots-message">Lỗi khi tải giờ trống. Vui lòng thử lại hoặc liên hệ với chúng tôi.</div>');
                    $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                }
            });
        }

        $('#bookingForm').on('submit', function(e){
            if(selectedServices.length === 0){
                e.preventDefault();
                alert("Vui lòng chọn ít nhất một dịch vụ.");
                $('html, body').animate({
                    scrollTop: $("#serviceSelect").offset().top - 100
                }, 500);
                return false;
            }
            if(!selectedTimeInput.val()){
                e.preventDefault();
                let messageContainer = availableSlotsContainer.find('.slots-message');
                if(messageContainer.length === 0 && availableSlotsContainer.find('.slots-loading-text').length === 0){
                    availableSlotsContainer.append('<div class="alert alert-danger w-100 mt-2 slots-message">Vui lòng chọn một giờ hẹn.</div>');
                } else {
                    messageContainer.remove();
                    availableSlotsContainer.append('<div class="alert alert-danger w-100 mt-2 slots-message">Vui lòng chọn một giờ hẹn.</div>');
                }
                $('html, body').animate({
                    scrollTop: availableSlotsContainer.offset().top - 100
                }, 500);
                return false;
            }
        });
    });
</script>
</body>
</html>