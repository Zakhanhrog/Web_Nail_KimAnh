<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="serviceDAOForHome" class="com.tiemnail.app.dao.ServiceDAO" scope="application"/>
<jsp:useBean id="nailArtDAOForHome" class="com.tiemnail.app.dao.NailArtDAO" scope="application"/>
<c:set var="featuredServices" value="${serviceDAOForHome.getAllServices(true)}" />
<c:set var="latestNailArts" value="${nailArtDAOForHome.getAllNailArts(true)}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KimiBeauty - Nơi Vẻ Đẹp Thăng Hoa</title>
    <jsp:include page="/WEB-INF/jsp/customer/_header_customer.jsp">
        <jsp:param name="pageTitle" value="Trang Chủ - KimiBeauty"/>
    </jsp:include>
</head>
<body>
<section class="hero-section">
    <div class="hero-overlay"></div>
    <div class="container hero-content">
        <h1 class="hero-title animated-fadeInUpSlight">KimiBeauty</h1>
        <p class="lead hero-subtitle animated-fadeInUpSlight" style="animation-delay: 0.3s;">Nơi mỗi thiết kế móng là một tác phẩm nghệ thuật, mang đến vẻ đẹp tinh tế và phong cách độc đáo cho bạn.</p>
        <div class="hero-buttons animated-fadeInUpSlight" style="animation-delay: 0.6s;">
            <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary-custom btn-lg">Đặt Lịch Ngay</a>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-custom-light btn-lg ml-md-3 mt-3 mt-md-0">Khám Phá Dịch Vụ</a>
        </div>
    </div>
</section>

<section id="why-choose-us" class="section-padding feature-icon-section">
    <div class="container">
        <p class="eyebrow-text text-center">Tại Sao Chọn Chúng Tôi?</p>
        <h2 class="section-title">Trải Nghiệm Sự Khác Biệt</h2>
        <div class="row mt-5">
            <div class="col-md-4 feature-item animated-fadeInUpSlight" style="animation-delay: 0.1s;">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-gem" viewBox="0 0 16 16"><path d="M3.1.7a.5.5 0 0 1 .4-.2h9a.5.5 0 0 1 .4.2l2.976 3.974c.149.199.224.45.224.706v1.852a.5.5 0 0 1-.336.483l-5.707 2.283a.5.5 0 0 1-.316 0l-5.707-2.283A.5.5 0 0 1 .124 7.23V5.378a1.5 1.5 0 0 1 .224-.706zm11.386 3.785-1.806-2.407L10.796 6H14.5M1.126 6h3.704L3.024 2.079l-1.806 2.407L1.126 6zM10.796 7l-2.422 4.843L5.954 7h4.842zm-5.19-1L8 11.156 10.394 6H5.606zM4.954 7H1.5L5.954 7zM14.999 5.378V7.23l-3.207-2.566 1.407-1.876a.5.5 0 0 0-.117-.706L12.443.5H3.557L3.1 1.087a.5.5 0 0 0-.117.706l1.407 1.876-3.207 2.566V5.378a.5.5 0 0 0 .136-.354l2.976-3.974A1.5 1.5 0 0 1 4.051 0h7.898a1.5 1.5 0 0 1 1.337 1.05l2.976 3.974a.5.5 0 0 0 .136.354M1.136 7.66l5.523 2.209L12.183 7.66h3.193l-3.293 2.635a1.5 1.5 0 0 1-.953.448h-4.86a1.5 1.5 0 0 1-.953-.448L1.136 7.66z"/></svg>
                </div>
                <h5>Chất Lượng Cao Cấp</h5>
                <p>Sử dụng sản phẩm chính hãng, an toàn từ các thương hiệu uy tín nhất.</p>
            </div>
            <div class="col-md-4 feature-item animated-fadeInUpSlight" style="animation-delay: 0.3s;">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-people-fill" viewBox="0 0 16 16"><path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5.784 6A2.24 2.24 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.3 6.3 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1zM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5"/></svg>
                </div>
                <h5>Kỹ Thuật Viên Lành Nghề</h5>
                <p>Đội ngũ chuyên gia được đào tạo bài bản, tận tâm và giàu kinh nghiệm.</p>
            </div>
            <div class="col-md-4 feature-item animated-fadeInUpSlight" style="animation-delay: 0.5s;">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-palette-fill" viewBox="0 0 16 16"><path d="M12.433 10.07C14.133 10.585 16 11.15 16 8a8 8 0 1 0-8 8c1.996 0 1.826-1.504 1.649-3.08-.124-1.101-.252-2.237.351-2.92.465-.547 1.175-.882 1.77-.882.21 0 .415.036.623.105zm-6.71-3.244c-.21-.21-.434-.403-.627-.551L12.727 7.28l-.511.894c-.23.403-.364.793-.364 1.175 0 .728.608 1.336 1.336 1.336.414 0 .793-.186 1.06-.454l.252.443A4.9 4.9 0 0 1 8 15a4.9 4.9 0 0 1-3.44-1.405l-.707-.707a4.9 4.9 0 0 1-.833-1.033L3.44 10.595l.002-.001.001-.001c.004-.005.009-.01.013-.015l.001-.001c.003-.003.006-.006.009-.009l.001-.001.001-.001.001-.001c.21-.21.434-.403.627-.551l4.002-2.828z"/><path d="M8 5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3m4-3a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3M4.5 3.5A1.5 1.5 0 1 0 3 2a1.5 1.5 0 0 0 1.5 1.5M1.5 6.5A1.5 1.5 0 1 0 0 5a1.5 1.5 0 0 0 1.5 1.5"/></svg>
                </div>
                <h5>Sáng Tạo Không Giới Hạn</h5>
                <p>Luôn cập nhật xu hướng mới nhất và sẵn sàng tạo nên những mẫu nail độc đáo cho riêng bạn.</p>
            </div>
        </div>
    </div>
</section>

<section id="our-story" class="section-padding bg-soft-cream">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6 order-md-2 animated-fadeInUpSlight">
                <p class="eyebrow-text">Câu Chuyện Của Chúng Tôi</p>
                <h2 class="section-title-alt">Hành Trình Kiến Tạo Vẻ Đẹp</h2>
                <p class="section-intro-text">Khởi đầu từ niềm đam mê với nghệ thuật làm móng và mong muốn mang đến một không gian thư giãn đích thực, KimiBeauty được thành lập vào năm 20XX. Trải qua nhiều năm phát triển, chúng tôi tự hào đã trở thành điểm đến tin cậy của hàng ngàn khách hàng.</p>
                <p>Chúng tôi không ngừng nỗ lực học hỏi, cải tiến kỹ thuật và đầu tư vào những sản phẩm tốt nhất. Mỗi khách hàng đến với XYZ không chỉ nhận được một bộ móng đẹp mà còn là những khoảnh khắc thư thái, được chăm sóc và nâng niu.</p>
                <ul class="list-unstyled mt-3" style="color: var(--text-dark-gray);">
                    <li class="mb-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Cam kết chất lượng dịch vụ hàng đầu.</li>
                    <li class="mb-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Không gian thư giãn, vệ sinh tuyệt đối.</li>
                    <li><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Luôn lắng nghe và đáp ứng mọi yêu cầu của bạn.</li>
                </ul>
            </div>
            <div class="col-md-6 order-md-1 animated-fadeInUpSlight" style="animation-delay: 0.2s;">
                <div class="about-image-wrapper">
                    <img src="${pageContext.request.contextPath}/images/our-story-image.jpg" alt="Đội ngũ KimiBeauty" class="img-fluid">
                    <%-- Thay bằng ảnh phù hợp --%>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="services-showcase" class="section-padding">
    <div class="container">
        <p class="eyebrow-text text-center">Dịch Vụ</p>
        <h2 class="section-title">Chăm Sóc Hoàn Hảo</h2>
        <p class="section-subtitle text-center">Từ những liệu pháp cơ bản đến các gói chăm sóc chuyên sâu, chúng tôi đáp ứng mọi nhu cầu làm đẹp của bạn.</p>
        <div class="row">
            <c:forEach var="service" items="${featuredServices}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 animated-fadeInUpSlight" style="animation-delay: ${loop.index * 0.2}s;">
                    <div class="card custom-card service-card">
                        <a href="${pageContext.request.contextPath}/services" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty service.imageUrl}"><img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>"></c:when>
                                <c:otherwise><img class="card-img-top" src="https://via.placeholder.com/400x260?text=${service.serviceName}" alt="Dịch vụ"></c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body">
                            <div>
                                <h5 class="card-title"><a href="${pageContext.request.contextPath}/services"><c:out value="${service.serviceName}"/></a></h5>
                                <p class="card-text price"><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫"/></p>
                            </div>
                            <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}" class="btn btn-outline-primary-custom btn-sm mt-auto">Đặt Lịch Dịch Vụ Này</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary-custom btn-lg">Xem Tất Cả Dịch Vụ</a>
        </div>
    </div>
</section>

<section id="nailart-gallery" class="section-padding bg-soft-cream">
    <div class="container">
        <p class="eyebrow-text text-center">Bộ Sưu Tập</p>
        <h2 class="section-title">Nghệ Thuật Móng Tay</h2>
        <p class="section-subtitle text-center">Khám phá những thiết kế móng tay thời thượng, được sáng tạo bởi những nghệ nhân tài hoa, thể hiện cá tính riêng của bạn.</p>
        <div class="row">
            <c:forEach var="nailArt" items="${latestNailArts}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 animated-fadeInUpSlight" style="animation-delay: ${loop.index * 0.2}s;">
                    <div class="card custom-card nailart-card">
                        <a href="${pageContext.request.contextPath}/nail-arts" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty nailArt.imageUrl}"><img class="card-img-top" src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>"></c:when>
                                <c:otherwise><img class="card-img-top" src="https://via.placeholder.com/400x320?text=${nailArt.nailArtName}" alt="Mẫu Nail"></c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body">
                            <h5 class="card-title"><a href="${pageContext.request.contextPath}/nail-arts"><c:out value="${nailArt.nailArtName}"/></a></h5>
                            <p class="card-text price"><small>Giá thêm:</small> <fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫"/></p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/nail-arts" class="btn btn-secondary-custom btn-lg">Xem Thêm Mẫu Nail</a>
        </div>
    </div>
</section>

<section class="testimonial-section section-padding">
    <div class="container">
        <p class="eyebrow-text text-center light">Phản Hồi Từ Khách Hàng</p>
        <h2 class="section-title light-text">Những Lời Yêu Thương</h2>
        <p class="section-subtitle light-text text-center">Sự hài lòng của bạn là động lực và niềm tự hào lớn nhất của chúng tôi.</p>
        <div class="row mt-5">
            <div class="col-md-4 animated-fadeInUpSlight" style="animation-delay: 0.1s;">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap"><img src="${pageContext.request.contextPath}/images/customer-avatar-1.png" alt="Khách hàng 1" class="testimonial-avatar"></div>
                    <p class="quote">Dịch vụ trên cả tuyệt vời! Móng tay tôi được chăm sóc tỉ mỉ và mẫu vẽ rất tinh xảo. Chắc chắn sẽ giới thiệu cho bạn bè.</p>
                    <h5 class="customer-name">- Lan Anh -</h5>
                    <p class="customer-title">Khách Hàng Thân Thiết</p>
                </div>
            </div>
            <div class="col-md-4 animated-fadeInUpSlight" style="animation-delay: 0.3s;">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap"><img src="${pageContext.request.contextPath}/images/customer-avatar-2.png" alt="Khách hàng 2" class="testimonial-avatar"></div>
                    <p class="quote">Không gian tiệm cực kỳ thư giãn và nhân viên rất chuyên nghiệp, thân thiện. Tôi cảm thấy như được nuông chiều bản thân.</p>
                    <h5 class="customer-name">- Minh Thư -</h5>
                    <p class="customer-title">Doanh Nhân</p>
                </div>
            </div>
            <div class="col-md-4 animated-fadeInUpSlight" style="animation-delay: 0.5s;">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap"><img src="${pageContext.request.contextPath}/images/customer-avatar-3.png" alt="Khách hàng 3" class="testimonial-avatar"></div>
                    <p class="quote">Yêu thích các mẫu nail art ở đây, luôn cập nhật xu hướng mới nhất. Giá cả cũng rất hợp lý cho chất lượng dịch vụ!</p>
                    <h5 class="customer-name">- Ngọc Bích -</h5>
                    <p class="customer-title">Fashionista</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="cta-section section-padding">
    <div class="container cta-container">
        <p class="eyebrow-text" style="color: rgba(255,255,255,0.8);">Đừng Chần Chừ</p>
        <h3 class="cta-title">Sẵn Sàng Cho Vẻ Đẹp Hoàn Hảo?</h3>
        <p class="cta-subtitle">Hãy để KimiBeauty đồng hành cùng bạn trên hành trình khám phá và tôn vinh nét đẹp riêng. Đặt lịch hẹn ngay hôm nay để trải nghiệm dịch vụ đẳng cấp!</p>
        <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-cta-custom btn-lg">Đặt Lịch Hẹn Ngay</a>
    </div>
</section>

<jsp:include page="/WEB-INF/jsp/customer/_footer_customer.jsp" />
<%-- Script JS cho navbar và section reveal đã có trong _footer_customer.jsp --%>
</body>
</html>