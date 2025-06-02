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
        <c:if test="${not empty submittedServiceIdsForDebug}">
            <div class="alert alert-info booking-alert" role="alert">
                DEBUG: Submitted Service IDs: <c:out value="${submittedServiceIdsForDebug}"/>
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

                <div id="nailArtSelectionBlock" class="form-group mt-3" style="display: none;">
                    <label for="globalNailArtSelect" class="form-label-custom">Chọn thêm mẫu Nail Art (tùy chọn):</label>
                    <select id="globalNailArtSelect" name="selectedGlobalNailArtId" class="custom-select custom-form-control">
                        <option value="0" data-price="0">-- Không chọn mẫu nail --</option>
                        <c:forEach var="nailArt" items="${nailArtList}">
                            <option value="${nailArt.nailArtId}" data-price="${nailArt.priceAddon}">
                                <c:out value="${nailArt.nailArtName}"/> (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>)
                            </option>
                        </c:forEach>
                    </select>
                </div>


                <div class="booking-summary-text mt-3">
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
<script>
    $(document).ready(function() {
        let selectedServices = [];
        let totalDuration = 0;
        let totalPrice = 0;
        let globalNailArtPrice = 0;

        const serviceSelect = $('#serviceSelect');
        const selectedServicesContainer = $('#selectedServicesContainer');
        const noServiceSelectedText = $('#noServiceSelectedText');
        const totalDurationSpan = $('#totalDuration');
        const totalPriceSpan = $('#totalPrice');
        const selectedDateInput = $('#selectedDate');
        const staffIdSelect = $('#staffId');
        const availableSlotsContainer = $('#availableSlotsContainer');
        const selectedTimeInput = $('#selectedTime');

        const nailArtSelectionBlock = $('#nailArtSelectionBlock');
        const globalNailArtSelect = $('#globalNailArtSelect');


        const preSelectedServiceId = parseInt('${preSelectedServiceId}');
        if (preSelectedServiceId && !isNaN(preSelectedServiceId)) {
            const optionToSelect = serviceSelect.find('option[value="' + preSelectedServiceId + '"]');
            if(optionToSelect.length){
                optionToSelect.prop('selected', true);
                $('#addServiceButton').click();
            }
        }

        $('#addServiceButton').on('click', function() {
            console.log("Add service button clicked.");
            const selectedOption = serviceSelect.find('option:selected');
            const serviceIdString = selectedOption.val();
            console.log("Selected option value (serviceIdString):", serviceIdString, typeof serviceIdString);

            if (!serviceIdString) {
                console.log("serviceIdString is empty, returning.");
                return;
            }

            const serviceId = parseInt(serviceIdString);
            console.log("Parsed serviceId:", serviceId, typeof serviceId);

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
            console.log("Parsed service details: Name:", serviceName, "Price:", servicePrice, "Duration:", serviceDuration);

            if (serviceId && !isNaN(serviceId) && serviceName && serviceName.length > 0 && !isNaN(servicePrice) && !isNaN(serviceDuration)) {
                if (!selectedServices.find(s => s.id === serviceId)) {
                    const serviceToAdd = {
                        id: serviceId,
                        name: serviceName,
                        price: servicePrice,
                        duration: serviceDuration
                    };
                    console.log("Service to add:", JSON.parse(JSON.stringify(serviceToAdd)));
                    selectedServices.push(serviceToAdd);
                    console.log("selectedServices AFTER push:", JSON.parse(JSON.stringify(selectedServices)));
                    updateSelectedServicesUI();
                    updateSummaryAndFetchSlots();
                } else {
                    alert("Dịch vụ này đã được thêm vào danh sách.");
                    console.log("Service ID", serviceId, "already in selectedServices.");
                }
            } else {
                console.error("Failed to add service due to invalid data. Parsed values:", {serviceId, serviceName, servicePrice, serviceDuration});
                alert("Không thể thêm dịch vụ. Dữ liệu không hợp lệ từ lựa chọn. Vui lòng thử lại hoặc chọn dịch vụ khác.");
            }
            serviceSelect.val('');
        });

        selectedServicesContainer.on('click', '.remove-service-btn', function() {
            console.log("Remove button clicked. Element:", this);
            const rawServiceId = $(this).data('serviceId');
            console.log("Raw data-service-id from button:", rawServiceId, typeof rawServiceId);

            const serviceIdToRemove = parseInt(rawServiceId);
            console.log("Parsed serviceIdToRemove:", serviceIdToRemove, typeof serviceIdToRemove);

            console.log("selectedServices BEFORE filter:", JSON.parse(JSON.stringify(selectedServices)));

            selectedServices = selectedServices.filter(s => {
                let match = s.id === serviceIdToRemove;
                // Sửa dòng này - dùng đối tượng để log
                console.log({
                    message: "Filtering decision",
                    service_id: s.id,
                    service_id_type: typeof s.id,
                    serviceIdToRemove: serviceIdToRemove,
                    serviceIdToRemove_type: typeof serviceIdToRemove,
                    keep: !match
                });
                return !match;
            });

            console.log("selectedServices AFTER filter:", JSON.parse(JSON.stringify(selectedServices)));

            updateSelectedServicesUI();
            updateSummaryAndFetchSlots();
        });

        globalNailArtSelect.on('change', function() {
            globalNailArtPrice = parseFloat($(this).find('option:selected').data('price')) || 0;
            console.log("Global Nail Art price changed to:", globalNailArtPrice);
            updateSummaryAndFetchSlots();
        });


        function updateSelectedServicesUI() {
            console.log("updateSelectedServicesUI called. Current selectedServices:", JSON.parse(JSON.stringify(selectedServices)));
            selectedServicesContainer.find('.service-item').remove();
            console.log("Number of .service-item elements after .remove():", selectedServicesContainer.find('.service-item').length);

            const noServiceTextElement = selectedServicesContainer.find('#noServiceSelectedText');
            if (selectedServices.length === 0) {
                if (noServiceTextElement.length === 0) {
                    selectedServicesContainer.append('<small class="text-muted d-block no-service-text" id="noServiceSelectedText">Chưa chọn dịch vụ nào.</small>');
                } else {
                    noServiceTextElement.show();
                }
                nailArtSelectionBlock.hide();
            } else {
                if (noServiceTextElement.length > 0) {
                    noServiceTextElement.hide();
                }
                nailArtSelectionBlock.show();
            }

            selectedServices.forEach(service => {
                // Kiểm tra kỹ service.id
                if (typeof service.id === 'undefined' || service.id === null || isNaN(service.id)) {
                    console.error("ERROR in updateSelectedServicesUI: Service object has invalid id:", JSON.parse(JSON.stringify(service)));
                    return;
                }
                const serviceNameText = service.name ? service.name : 'Lỗi tên dịch vụ';
                const currentServiceId = service.id;
                console.log("Processing service for UI: ID =", currentServiceId, "Name =", serviceNameText);

                const serviceItemDiv = $('<div></div>')
                    .addClass('service-item')
                    .attr('data-service-id', currentServiceId);

                const hiddenInput = $('<input>')
                    .attr('type', 'hidden')
                    .attr('name', 'selectedServiceIds')
                    .val(currentServiceId); // Sử dụng val()

                const nameSpan = $('<span></span>')
                    .addClass('service-name-display')
                    .text(serviceNameText);

                const removeButton = $('<button></button>')
                    .attr('type', 'button')
                    .addClass('btn btn-outline-danger btn-sm remove-service-btn')
                    .attr('data-service-id', currentServiceId) // Sử dụng attr()
                    .attr('title', 'Xóa dịch vụ')
                    .html('×'); // Ký tự 'x'

                serviceItemDiv.append(hiddenInput).append(nameSpan).append(removeButton);
                selectedServicesContainer.append(serviceItemDiv);
            });

            console.log("Number of .service-item elements after re-adding:", selectedServicesContainer.find('.service-item').length);
            console.log("Final HTML of selectedServicesContainer:", selectedServicesContainer.html().replace(/\s+/g, ' ').trim()); // Log HTML gọn hơn
        }

        function updateSummary() {
            totalDuration = 0;
            totalPrice = 0;
            selectedServices.forEach(service => {
                totalDuration += service.duration;
                totalPrice += service.price;
            });

            totalPrice += globalNailArtPrice;
            totalDurationSpan.text(totalDuration);
            totalPriceSpan.text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(totalPrice));
            console.log("Summary updated. Total Duration:", totalDuration, "Total Price:", totalPrice);
        }

        function updateSummaryAndFetchSlots(){
            updateSummary();
            fetchAvailableSlots();
        }

        selectedDateInput.on('change', fetchAvailableSlots);
        staffIdSelect.on('change', fetchAvailableSlots);

        function fetchAvailableSlots() {
            console.log("fetchAvailableSlots called.");
            const date = selectedDateInput.val();
            const staffId = staffIdSelect.val();
            const duration = totalDuration;
            console.log("Params for fetchAvailableSlots: Date:", date, "Staff ID:", staffId, "Duration:", duration);


            if (!date || duration === 0 && selectedServices.length === 0) {
                availableSlotsContainer.html('<small class="text-muted w-100 p-2 no-slots-text">Vui lòng chọn ngày và ít nhất một dịch vụ để xem giờ trống.</small>');
                selectedTimeInput.val('');
                $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                console.log("fetchAvailableSlots: No date or no services (duration 0), resetting slots UI.");
                return;
            }
            if (!date && selectedServices.length > 0) {
                availableSlotsContainer.html('<small class="text-muted w-100 p-2 no-slots-text">Vui lòng chọn ngày để xem giờ trống.</small>');
                selectedTimeInput.val('');
                $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                console.log("fetchAvailableSlots: Services selected but no date, resetting slots UI.");
                return;
            }


            availableSlotsContainer.html('<small class="text-muted w-100 p-2 slots-loading-text">Đang tìm giờ trống, vui lòng đợi...</small>');
            selectedTimeInput.val('');
            $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
            console.log("fetchAvailableSlots: Fetching slots via AJAX...");

            $.ajax({
                url: '${pageContext.request.contextPath}/customer/book-appointment/get-available-slots',
                type: 'GET',
                data: { date: date, staffId: staffId, duration: duration },
                success: function(response) {
                    console.log("fetchAvailableSlots AJAX success. Response:", response);
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
                                console.log("Slot selected:", slot);
                            });
                            availableSlotsContainer.append(slotButton);
                        });
                    } else {
                        availableSlotsContainer.html('<small class="text-muted w-100 p-2 slots-message no-slots-text">Rất tiếc, không có giờ trống phù hợp cho lựa chọn của bạn.</small>');
                        $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("fetchAvailableSlots AJAX error. Status:", textStatus, "Error:", errorThrown, "Response:", jqXHR.responseText);
                    availableSlotsContainer.html('<div class="alert alert-danger w-100 slots-message">Lỗi khi tải giờ trống. Vui lòng thử lại hoặc liên hệ với chúng tôi.</div>');
                    $('#bookingForm').find('button[type="submit"]').prop('disabled', true);
                }
            });
        }

        $('#bookingForm').on('submit', function(e){
            console.log("Booking form submitted. Validating...");
            if(selectedServices.length === 0){
                e.preventDefault();
                alert("Vui lòng chọn ít nhất một dịch vụ.");
                $('html, body').animate({
                    scrollTop: $("#serviceSelect").offset().top - 100
                }, 500);
                console.log("Form submission prevented: No services selected.");
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
                console.log("Form submission prevented: No time selected.");
                return false;
            }
            console.log("Form validation passed. Proceeding with submission.");
        });
    });
</script>
</body>
</html>