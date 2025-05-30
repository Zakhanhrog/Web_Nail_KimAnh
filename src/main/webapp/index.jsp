<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="serviceDAOForHome" class="com.tiemnail.app.dao.ServiceDAO" scope="application"/>
<jsp:useBean id="nailArtDAOForHome" class="com.tiemnail.app.dao.NailArtDAO" scope="application"/>
<c:set var="featuredServices" value="${serviceDAOForHome.getAllServices(true)}" /> <%-- Lấy tất cả dịch vụ active --%>
<c:set var="latestNailArts" value="${nailArtDAOForHome.getAllNailArts(true)}" /> <%-- Lấy tất cả mẫu nail active --%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiệm Nail XYZ - Chăm sóc móng chuyên nghiệp</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/custom-style.css" rel="stylesheet">
    <style>
        .hero-section {
            background: url('${pageContext.request.contextPath}/images/hero-background.jpg') no-repeat center center; /* Thay bằng ảnh banner của bạn */
            background-size: cover;
            color: white;
            padding: 100px 0;
            text-align: center;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.7);
        }
        .hero-section h1 { font-size: 3.5rem; font-weight: bold; margin-bottom: 20px; }
        .hero-section p { font-size: 1.25rem; margin-bottom: 30px; }
        .section-title { text-align: center; margin-bottom: 50px; font-weight: bold; color: #333; }
        .service-card-home img, .nail-art-card-home img {
            height: 200px;
            object-fit: cover;
        }
        .service-card-home, .nail-art-card-home {
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: transform .2s; /* Animation on hover */
        }
        .service-card-home:hover, .nail-art-card-home:hover {
            transform: scale(1.05); /* Zoom in on hover */
        }
        .testimonial-section { background-color: #f8f9fa; padding: 60px 0; }
        .testimonial-item { text-align: center; }
        .testimonial-item img { width: 100px; height: 100px; border-radius: 50%; margin-bottom: 20px; }
        .cta-section { padding: 60px 0; background-color: #343a40; color: white; text-align: center; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/customer/_header_customer.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <h1>Tiệm Nail XYZ</h1>
        <p>Nơi vẻ đẹp của bạn được thăng hoa - Dịch vụ nail và mỹ phẩm hàng đầu.</p>
        <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary btn-lg">Đặt Lịch Ngay</a>
        <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-light btn-lg ml-2">Xem Dịch Vụ</a>
    </div>
</section>

<!-- Featured Services Section -->
<section id="services" class="py-5">
    <div class="container">
        <h2 class="section-title">Dịch Vụ Nổi Bật</h2>
        <div class="row">
            <c:forEach var="service" items="${featuredServices}" varStatus="loop" begin="0" end="2"> <%-- Hiển thị 3 dịch vụ đầu --%>
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card-home h-100">
                        <c:choose>
                            <c:when test="${not empty service.imageUrl}">
                                <img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>">
                            </c:when>
                            <c:otherwise>
                                <img class="card-img-top" src="https://via.placeholder.com/700x400?text=Service" alt="Service Image">
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h5 class="card-title"><c:out value="${service.serviceName}"/></h5>
                            <p class="card-text"><small><c:out value="${service.description}"/></small></p>
                        </div>
                        <div class="card-footer text-center">
                            <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}" class="btn btn-outline-primary btn-sm">Đặt Lịch</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary">Xem Tất Cả Dịch Vụ</a>
        </div>
    </div>
</section>

<!-- Latest Nail Art Section -->
<section id="nail-art" class="py-5 bg-light">
    <div class="container">
        <h2 class="section-title">Mẫu Nail Mới Nhất</h2>
        <div class="row">
            <c:forEach var="nailArt" items="${latestNailArts}" varStatus="loop" begin="0" end="2"> <%-- Hiển thị 3 mẫu nail đầu --%>
                <div class="col-lg-4 col-md-6">
                    <div class="card nail-art-card-home h-100">
                        <c:choose>
                            <c:when test="${not empty nailArt.imageUrl}">
                                <img class="card-img-top" src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>">
                            </c:when>
                            <c:otherwise>
                                <img class="card-img-top" src="https://via.placeholder.com/700x400?text=Nail+Art" alt="Nail Art Image">
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h5 class="card-title"><c:out value="${nailArt.nailArtName}"/></h5>
                            <p class="card-text"><small>Giá thêm: <fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫"/></small></p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/nail-arts" class="btn btn-secondary">Xem Thêm Mẫu Nail</a>
        </div>
    </div>
</section>

<!-- Testimonials Section (Ví dụ) -->
<section class="testimonial-section">
    <div class="container">
        <h2 class="section-title">Khách Hàng Nói Gì Về Chúng Tôi</h2>
        <div class="row">
            <div class="col-md-4 testimonial-item">
                <img src="${pageContext.request.contextPath}/images/customer-1.jpg" alt="Customer 1"> <%-- Ảnh khách hàng mẫu --%>
                <p>"Dịch vụ tuyệt vời, nhân viên thân thiện. Móng tay của tôi chưa bao giờ đẹp hơn thế!"</p>
                <h5>- Chị An -</h5>
            </div>
            <div class="col-md-4 testimonial-item">
                <img src="${pageContext.request.contextPath}/images/customer-2.jpg" alt="Customer 2">
                <p>"Không gian tiệm rất thư giãn và sạch sẽ. Tôi chắc chắn sẽ quay lại."</p>
                <h5>- Chị Bình -</h5>
            </div>
            <div class="col-md-4 testimonial-item">
                <img src="${pageContext.request.contextPath}/images/customer-3.jpg" alt="Customer 3">
                <p>"Các mẫu nail art ở đây rất độc đáo và cập nhật xu hướng. Rất hài lòng!"</p>
                <h5>- Chị Chi -</h5>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action Section -->
<section class="cta-section">
    <div class="container">
        <h3>Sẵn Sàng Để Có Bộ Móng Ưng Ý?</h3>
        <p>Đội ngũ chuyên gia của chúng tôi luôn sẵn lòng phục vụ bạn.</p>
        <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-warning btn-lg">Đặt Lịch Ngay Hôm Nay</a>
    </div>
</section>

<jsp:include page="/WEB-INF/jsp/customer/_footer_customer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>