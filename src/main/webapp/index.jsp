<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="serviceDAOForHome" class="com.tiemnail.app.dao.ServiceDAO" scope="application"/>
<jsp:useBean id="nailArtDAOForHome" class="com.tiemnail.app.dao.NailArtDAO" scope="application"/>
<c:set var="featuredServices" value="${serviceDAOForHome.getAllServices(true)}" />
<c:set var="latestNailArts" value="${nailArtDAOForHome.getAllNailArts(true)}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiệm Nail XYZ - Nơi Nghệ Thuật Thăng Hoa Trên Từng Ngón Tay</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/custom-style.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/WEB-INF/jsp/customer/_header_customer.jsp" />

<section class="hero-section">
    <div class="hero-overlay"></div>
    <div class="container hero-content">
        <h1 class="hero-title">Tiệm Nail XYZ</h1>
        <p class="hero-subtitle">Nơi mỗi thiết kế móng là một tác phẩm nghệ thuật, mang đến vẻ đẹp tinh tế và phong cách độc đáo cho bạn.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary-custom-filled">Đặt Lịch Ngay</a>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-custom-light ml-lg-3 mt-3 mt-lg-0">Khám Phá Dịch Vụ</a>
        </div>
    </div>
</section>

<section id="about-us" class="section-padding">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-5 mb-lg-0">
                <div class="about-image-wrapper">
                    <img src="${pageContext.request.contextPath}/images/about-us-image.jpg" alt="Không gian sang trọng tại Tiệm Nail XYZ" class="img-fluid rounded shadow-lg">
                </div>
            </div>
            <div class="col-lg-6">
                <p class="eyebrow-text">Chào Mừng Bạn Đến Với</p>
                <h2 class="section-title-alt">Tiệm Nail XYZ</h2>
                <p class="section-intro-text">Tại Tiệm Nail XYZ, chúng tôi không chỉ làm móng, chúng tôi kiến tạo vẻ đẹp và sự tự tin. Với niềm đam mê nghệ thuật và sự tận tâm trong từng chi tiết, đội ngũ chuyên viên tài năng của chúng tôi luôn sẵn sàng mang đến những trải nghiệm làm đẹp đẳng cấp.</p>
                <p>Chúng tôi tự hào sử dụng những sản phẩm cao cấp nhất, đảm bảo an toàn tuyệt đối, trong một không gian được thiết kế thanh lịch và thư giãn, giúp bạn tận hưởng trọn vẹn khoảnh khắc chăm sóc bản thân.</p>
                <a href="#services-showcase" class="btn btn-secondary-custom mt-4">Xem Dịch Vụ Của Chúng Tôi</a>
            </div>
        </div>
    </div>
</section>

<section id="services-showcase" class="section-padding bg-pastel-gradient">
    <div class="container">
        <p class="eyebrow-text text-center light">Dịch Vụ Chuyên Nghiệp</p>
        <h2 class="section-title text-center light">Chăm Sóc Hoàn Hảo</h2>
        <p class="section-subtitle text-center light">Từ những liệu pháp spa thư giãn đến các kỹ thuật làm móng phức tạp, chúng tôi đáp ứng mọi nhu cầu làm đẹp của bạn.</p>
        <div class="row">
            <c:forEach var="service" items="${featuredServices}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="custom-card service-card h-100">
                        <a href="${pageContext.request.contextPath}/services/detail?id=${service.serviceId}" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty service.imageUrl}"><img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>"></c:when>
                                <c:otherwise><img class="card-img-top" src="https://via.placeholder.com/400x280?text=${fn:replace(service.serviceName, ' ', '+')}" alt="Dịch vụ"></c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title flex-grow-1"><a href="${pageContext.request.contextPath}/services/detail?id=${service.serviceId}"><c:out value="${service.serviceName}"/></a></h5>
                            <p class="card-text price"><fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND" currencySymbol="₫" groupingUsed="true" minFractionDigits="0" maxFractionDigits="0"/> </p>
                            <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}" class="btn btn-outline-primary-custom btn-sm mt-auto">Đặt Lịch Dịch Vụ Này</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/services" class="btn btn-cta-outline-light">Xem Tất Cả Dịch Vụ</a>
        </div>
    </div>
</section>

<section id="nailart-gallery" class="section-padding">
    <div class="container">
        <p class="eyebrow-text text-center">Bộ Sưu Tập Độc Đáo</p>
        <h2 class="section-title text-center">Nghệ Thuật Móng Tay</h2>
        <p class="section-subtitle text-center">Khám phá những thiết kế móng tay thời thượng, được sáng tạo bởi những nghệ nhân tài hoa, thể hiện cá tính riêng của bạn.</p>
        <div class="row">
            <c:forEach var="nailArt" items="${latestNailArts}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="custom-card nailart-card h-100">
                        <a href="${pageContext.request.contextPath}/nail-arts/detail?id=${nailArt.nailArtId}" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty nailArt.imageUrl}"><img class="card-img-top" src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>"></c:when>
                                <c:otherwise><img class="card-img-top" src="https://via.placeholder.com/400x400?text=${fn:replace(nailArt.nailArtName, ' ', '+')}" alt="Mẫu Nail"></c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body text-center">
                            <h5 class="card-title"><a href="${pageContext.request.contextPath}/nail-arts/detail?id=${nailArt.nailArtId}"><c:out value="${nailArt.nailArtName}"/></a></h5>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/nail-arts" class="btn btn-secondary-custom">Xem Thêm Mẫu Nail</a>
        </div>
    </div>
</section>

<section class="testimonial-section section-padding bg-soft-cream">
    <div class="container">
        <p class="eyebrow-text text-center">Chia Sẻ Từ Khách Hàng</p>
        <h2 class="section-title text-center">Trải Nghiệm Tuyệt Vời</h2>
        <div class="row justify-content-center mt-5">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap">
                        <img src="${pageContext.request.contextPath}/images/customer-avatar-1.png" alt="Chị Lan Anh" class="testimonial-avatar">
                    </div>
                    <p class="quote">“Dịch vụ trên cả tuyệt vời! Móng tay tôi được chăm sóc tỉ mỉ và mẫu vẽ rất tinh xảo. Chắc chắn sẽ giới thiệu cho bạn bè.”</p>
                    <h5 class="customer-name">- Lan Anh -</h5>
                    <p class="customer-title">Khách hàng thân thiết</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap">
                        <img src="${pageContext.request.contextPath}/images/customer-avatar-2.png" alt="Chị Minh Thư" class="testimonial-avatar">
                    </div>
                    <p class="quote">“Không gian tiệm cực kỳ thư giãn và nhân viên rất chuyên nghiệp, thân thiện. Tôi cảm thấy như được nuông chiều bản thân.”</p>
                    <h5 class="customer-name">- Minh Thư -</h5>
                    <p class="customer-title">Doanh nhân</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap">
                        <img src="${pageContext.request.contextPath}/images/customer-avatar-3.png" alt="Bạn Ngọc Bích" class="testimonial-avatar">
                    </div>
                    <p class="quote">“Yêu thích các mẫu nail art ở đây, luôn cập nhật xu hướng mới nhất. Giá cả cũng rất hợp lý cho chất lượng dịch vụ.”</p>
                    <h5 class="customer-name">- Ngọc Bích -</h5>
                    <p class="customer-title">Fashionista</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="cta-section section-padding">
    <div class="container cta-container">
        <h3 class="cta-title">Sẵn Sàng Cho Vẻ Đẹp Hoàn Hảo?</h3>
        <p class="cta-subtitle">Hãy để Tiệm Nail XYZ đồng hành cùng bạn trên hành trình khám phá và tôn vinh nét đẹp riêng. Đặt lịch hẹn ngay hôm nay để trải nghiệm dịch vụ đẳng cấp!</p>
        <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary-custom-filled btn-lg shadow-lg">Đặt Lịch Hẹn Ngay</a>
    </div>
</section>

<jsp:include page="/WEB-INF/jsp/customer/_footer_customer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>