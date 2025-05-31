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
        <p class="lead hero-subtitle animated-fadeInUpSlight" style="animation-delay: 0.3s;">
            Nơi mỗi thiết kế móng là một tác phẩm nghệ thuật, mang đến vẻ đẹp tinh tế và phong cách độc đáo cho bạn.
        </p>
        <div class="hero-buttons animated-fadeInUpSlight" style="animation-delay: 0.6s;">
            <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary-custom-filled btn-lg">Đặt Lịch Ngay</a>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-custom-light btn-lg ml-md-3 mt-3 mt-md-0">Khám Phá Dịch Vụ</a>
        </div>
    </div>
</section>

<section class="brand-promise-section section-padding reveal-on-scroll fade-in-up" style="background-color: var(--white-pure);">
    <div class="container text-center">
        <p class="eyebrow-text">Cam Kết Từ KimiBeauty</p>
        <h2 class="section-title">Đẳng Cấp Đến Từ Chi Tiết</h2>
        <p class="section-intro-text" style="max-width: 800px; margin-left:auto; margin-right:auto; font-size: 1.1rem; color: var(--text-dark-gray);">
            Tại KimiBeauty, chúng tôi tin rằng vẻ đẹp đích thực nằm ở sự tinh tế và chăm chút đến từng chi tiết nhỏ nhất. Với đội ngũ nghệ nhân tài hoa, không gian thư giãn sang trọng và quy trình vệ sinh chuẩn mực, chúng tôi không chỉ mang đến những bộ móng hoàn hảo mà còn là những phút giây nuông chiều bản thân, giúp bạn tái tạo năng lượng và khẳng định phong cách độc đáo.
        </p>
    </div>
</section>

<section id="why-choose-us" class="section-padding feature-icon-section reveal-on-scroll fade-in">
    <div class="container">
        <p class="eyebrow-text text-center">Tại Sao Chọn Chúng Tôi?</p>
        <h2 class="section-title text-center">Trải Nghiệm Sự Khác Biệt</h2>
        <div class="row mt-5">
            <div class="col-md-4 feature-item reveal-on-scroll fade-in-up" data-reveal-delay="100">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-gem" viewBox="0 0 16 16"><path d="M3.1.7a.5.5 0 0 1 .4-.2h9a.5.5 0 0 1 .4.2l2.976 3.974c.149.199.224.45.224.706v1.852a.5.5 0 0 1-.336.483l-5.707 2.283a.5.5 0 0 1-.316 0l-5.707-2.283A.5.5 0 0 1 .124 7.23V5.378a1.5 1.5 0 0 1 .224-.706zm11.386 3.785-1.806-2.407L10.796 6H14.5M1.126 6h3.704L3.024 2.079l-1.806 2.407L1.126 6zM10.796 7l-2.422 4.843L5.954 7h4.842zm-5.19-1L8 11.156 10.394 6H5.606zM4.954 7H1.5L5.954 7zM14.999 5.378V7.23l-3.207-2.566 1.407-1.876a.5.5 0 0 0-.117-.706L12.443.5H3.557L3.1 1.087a.5.5 0 0 0-.117.706l1.407 1.876-3.207 2.566V5.378a.5.5 0 0 0 .136-.354l2.976-3.974A1.5 1.5 0 0 1 4.051 0h7.898a1.5 1.5 0 0 1 1.337 1.05l2.976 3.974a.5.5 0 0 0 .136.354M1.136 7.66l5.523 2.209L12.183 7.66h3.193l-3.293 2.635a1.5 1.5 0 0 1-.953.448h-4.86a1.5 1.5 0 0 1-.953-.448L1.136 7.66z"/></svg>
                </div>
                <h5>Chất Lượng Cao Cấp</h5>
                <p>Sử dụng sản phẩm chính hãng, an toàn từ các thương hiệu uy tín nhất.</p>
            </div>
            <div class="col-md-4 feature-item reveal-on-scroll fade-in-up" data-reveal-delay="300">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-people-fill" viewBox="0 0 16 16"><path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5.784 6A2.24 2.24 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.3 6.3 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1zM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5"/></svg>
                </div>
                <h5>Kỹ Thuật Viên Lành Nghề</h5>
                <p>Đội ngũ chuyên gia được đào tạo bài bản, tận tâm và giàu kinh nghiệm.</p>
            </div>
            <div class="col-md-4 feature-item reveal-on-scroll fade-in-up" data-reveal-delay="500">
                <div class="icon-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-palette-fill" viewBox="0 0 16 16"><path d="M12.433 10.07C14.133 10.585 16 11.15 16 8a8 8 0 1 0-8 8c1.996 0 1.826-1.504 1.649-3.08-.124-1.101-.252-2.237.351-2.92.465-.547 1.175-.882 1.77-.882.21 0 .415.036.623.105zm-6.71-3.244c-.21-.21-.434-.403-.627-.551L12.727 7.28l-.511.894c-.23.403-.364.793-.364 1.175 0 .728.608 1.336 1.336 1.336.414 0 .793-.186 1.06-.454l.252.443A4.9 4.9 0 0 1 8 15a4.9 4.9 0 0 1-3.44-1.405l-.707-.707a4.9 4.9 0 0 1-.833-1.033L3.44 10.595l.002-.001.001-.001c.004-.005.009-.01.013-.015l.001-.001c.003-.003.006-.006.009-.009l.001-.001.001-.001.001-.001c.21-.21.434-.403.627-.551l4.002-2.828z"/><path d="M8 5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3m4-3a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3M4.5 3.5A1.5 1.5 0 1 0 3 2a1.5 1.5 0 0 0 1.5 1.5M1.5 6.5A1.5 1.5 0 1 0 0 5a1.5 1.5 0 0 0 1.5 1.5"/></svg>
                </div>
                <h5>Sáng Tạo Không Giới Hạn</h5>
                <p>Luôn cập nhật xu hướng mới nhất và sẵn sàng tạo nên những mẫu nail độc đáo cho riêng bạn.</p>
            </div>
        </div>
    </div>
</section>

<section id="our-story" class="section-padding bg-soft-cream reveal-on-scroll fade-in-left">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6 order-md-2 animated-fadeInUpSlight">
                <p class="eyebrow-text">Câu Chuyện Của Chúng Tôi</p>
                <h2 class="section-title-alt">Hành Trình Kiến Tạo Vẻ Đẹp</h2>
                <p class="section-intro-text">Khởi đầu từ niềm đam mê với nghệ thuật làm móng và mong muốn mang đến một không gian thư giãn đích thực, KimiBeauty được thành lập. Trải qua nhiều năm phát triển, chúng tôi tự hào đã trở thành điểm đến tin cậy của hàng ngàn khách hàng.</p>
                <p class="section-intro-text">Chúng tôi không ngừng nỗ lực học hỏi, cải tiến kỹ thuật và đầu tư vào những sản phẩm tốt nhất. Mỗi khách hàng đến với KimiBeauty không chỉ nhận được một bộ móng đẹp mà còn là những khoảnh khắc thư thái, được chăm sóc và nâng niu.</p>
                <ul class="list-unstyled mt-3" style="color: var(--text-dark-gray);">
                    <li class="mb-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Cam kết chất lượng dịch vụ hàng đầu.</li>
                    <li class="mb-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Không gian thư giãn, vệ sinh tuyệt đối.</li>
                    <li><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="var(--accent-pink)" class="bi bi-check-circle-fill mr-2" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg> Luôn lắng nghe và đáp ứng mọi yêu cầu của bạn.</li>
                </ul>
            </div>
            <div class="col-md-6 order-md-1 animated-fadeInUpSlight" style="animation-delay: 0.2s;">
                <div class="about-image-wrapper">
                    <img src="${pageContext.request.contextPath}/images/our-story-image.jpg" alt="Đội ngũ KimiBeauty" class="img-fluid">
                </div>
            </div>
        </div>
    </div>
</section>

<section id="hygiene-standards" class="section-padding reveal-on-scroll fade-in-right">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6 order-md-2">
                <p class="eyebrow-text">An Toàn Là Ưu Tiên</p>
                <h2 class="section-title-alt">Tiêu Chuẩn Vệ Sinh Vượt Trội</h2>
                <p class="section-intro-text">Sức khỏe và sự an tâm của bạn là ưu tiên hàng đầu tại KimiBeauty. Chúng tôi tự hào áp dụng quy trình vệ sinh nghiêm ngặt theo tiêu chuẩn quốc tế:</p>
                <ul class="list-unstyled mt-3" style="color: var(--text-dark-gray);">
                    <li class="mb-2 d-flex align-items-start">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="var(--accent-pink)" class="bi bi-shield-check-fill mr-2 flex-shrink-0" viewBox="0 0 16 16" style="margin-top: 4px; margin-right: 8px;">
                            <path d="M5.443 1.991a60.17 60.17 0 0 0-2.725.802.454.454 0 0 0-.315.366C1.87 7.056 3.1 9.9 4.567 11.773c.736.94 1.533 1.636 2.197 2.093.333.228.626.394.857.5.116.053.21.089.282.11A.73.73 0 0 0 8 14.5a.73.73 0 0 0 .282-.085c.072-.022.166-.058.282-.111.23-.106.524-.272.857-.5.664-.457 1.46-1.153 2.197-2.093C12.9 9.9 14.13 7.056 13.597 3.159a.454.454 0 0 0-.315-.366c-.626-.2-1.682-.526-2.725-.802C9.491 1.711 8.51 1.5 8 1.5c-.51 0-1.49.21-2.557.491zm-.256-.922A1.724 1.724 0 0 1 3.17 1.018a.481.481 0 0 1 .316.078c.209.126.398.255.57.393.104.083.213.164.326.245.118.085.24.167.368.247.123.075.243.14.356.19.13.057.254.1.368.13l.002.001.002.001a62.38 62.38 0 0 1 2.725-.802C7.598.373 8.004 0 8.004 0s.406.373.989.434c1.049.276 2.11.624 2.725.802l.002-.001.002-.001c.114-.03.238-.073.368-.13.113-.05.233-.115.356-.19.128-.08.25-.162.368-.247.113-.08.222-.162.326-.245.172-.138.361-.267.57-.393a.481.481 0 0 1 .316-.078 1.724 1.724 0 0 1 .227.052c.16.05.308.119.442.205.137.087.262.188.372.3.112.112.208.234.284.362.077.127.136.264.176.407.043.15.067.307.072.468.006.162.002.326-.015.493a51.4 51.4 0 0 1-.004 2.701c-.01.772-.035 1.47-.098 2.072-.052.503-.125.97-.228 1.388a10.01 10.01 0 0 1-.57 1.535 1.47 1.47 0 0 1-.024.042l-.004.007-.002.003c-.367.61-.798 1.155-1.278 1.626-.48.47-1.003.883-1.552 1.223-.55.34-1.126.59-1.708.743-.58.154-1.17.21-1.736.162H8c-.565.048-1.156-.008-1.736-.162-.582-.153-1.158-.402-1.708-.743-.55-.34-1.072-.752-1.552-1.223-.48-.472-.91-.991-1.278-1.626l-.002-.003-.004-.007a1.47 1.47 0 0 1-.024-.042 10.01 10.01 0 0 1-.57-1.535c-.103-.418-.176-.885-.228-1.388-.063-.602-.088-1.3-.098-2.072a51.4 51.4 0 0 1-.004-2.701c-.017-.167-.021-.331-.015-.493.005-.16.029-.317.072-.468.04-.143.099-.28.176-.407.076-.128.172-.25.284-.362.11-.112.235-.213.372-.3.134-.086.282-.155.442-.205.074-.022.15-.04.227-.052zm4.464 4.284-1.88 1.88a.5.5 0 1 1-.708-.708l1.525-1.525-1.043-1.043a.5.5 0 0 1 .708-.708l1.383 1.384 2.81-2.81a.5.5 0 0 1 .708.708L9.25 7.543z"/>
                        </svg>
                        <span>Dụng cụ được khử trùng 100% sau mỗi lần sử dụng bằng máy hấp autoclave chuyên dụng.</span>
                    </li>
                    <li class="mb-2 d-flex align-items-start">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="var(--accent-pink)" class="bi bi-droplet-fill mr-2 flex-shrink-0" viewBox="0 0 16 16" style="margin-top: 4px; margin-right: 8px;">
                            <path fill-rule="evenodd" d="M8 16a6 6 0 006-6c0-1.655-1.122-2.904-2.432-4.362C10.254 4.176 8.75 2.503 8 0c0 0-6 5.686-6 10a6 6 0 006 6ZM6.646 4.646c-.376.377-1.272 1.489-2.093 3.13l.894.448c.78-1.559 1.616-2.58 1.907-2.87l-.708-.708z"/>
                        </svg>
                        <span>Sử dụng sản phẩm chăm sóc móng không chứa hóa chất độc hại, an toàn cho cả mẹ bầu.</span>
                    </li>
                    <li class="d-flex align-items-start">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="var(--accent-pink)" class="bi bi-person-check-fill mr-2 flex-shrink-0" viewBox="0 0 16 16" style="margin-top: 4px; margin-right: 8px;">
                            <path fill-rule="evenodd" d="M15.854 5.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 0 1 .708-.708L12.5 7.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
                            <path d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                        </svg>
                        <span>Kỹ thuật viên được đào tạo về quy chuẩn vệ sinh và luôn đeo khẩu trang, găng tay khi phục vụ.</span>
                    </li>
                </ul>
            </div>
            <div class="col-md-6 order-md-1">
                <img src="${pageContext.request.contextPath}/images/hygiene-focus.jpg" alt="Không gian sạch sẽ tại KimiBeauty" class="img-fluid rounded shadow-lg">
            </div>
        </div>
    </div>
</section>

<section id="services-showcase" class="section-padding reveal-on-scroll zoom-in">
    <div class="container">
        <p class="eyebrow-text text-center">Dịch Vụ</p>
        <h2 class="section-title text-center">Chăm Sóc Hoàn Hảo</h2>
        <p class="section-subtitle text-center">Từ những liệu pháp cơ bản đến các gói chăm sóc chuyên sâu, chúng tôi đáp ứng mọi nhu cầu làm đẹp của bạn.</p>
        <div class="row">
            <c:forEach var="service" items="${featuredServices}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 reveal-on-scroll fade-in-up" data-reveal-delay="${loop.index * 200}">
                    <div class="card custom-card service-card">
                        <a href="${pageContext.request.contextPath}/services" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty service.imageUrl}">
                                    <img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>">
                                </c:when>
                                <c:otherwise>
                                    <img class="card-img-top" src="https://via.placeholder.com/400x260?text=${service.serviceName}" alt="Dịch vụ">
                                </c:otherwise>
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

<section id="nailart-gallery" class="section-padding bg-soft-cream reveal-on-scroll zoom-in" data-reveal-delay="200">
    <div class="container">
        <p class="eyebrow-text text-center">Bộ Sưu Tập</p>
        <h2 class="section-title text-center">Nghệ Thuật Móng Tay</h2>
        <p class="section-subtitle text-center">Khám phá những thiết kế móng tay thời thượng, được sáng tạo bởi những nghệ nhân tài hoa, thể hiện cá tính riêng của bạn.</p>
        <div class="row">
            <c:forEach var="nailArt" items="${latestNailArts}" varStatus="loop" begin="0" end="2">
                <div class="col-lg-4 col-md-6 reveal-on-scroll fade-in-up" data-reveal-delay="${loop.index * 200}">
                    <div class="card custom-card nailart-card">
                        <a href="${pageContext.request.contextPath}/nail-arts" class="card-image-link">
                            <c:choose>
                                <c:when test="${not empty nailArt.imageUrl}">
                                    <img class="card-img-top" src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>">
                                </c:when>
                                <c:otherwise>
                                    <img class="card-img-top" src="https://via.placeholder.com/400x320?text=${nailArt.nailArtName}" alt="Mẫu Nail">
                                </c:otherwise>
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

<section class="brand-partners-section bg-soft-cream reveal-on-scroll fade-in" style="padding: 60px 0;" data-reveal-delay="100">
    <div class="container">
        <h5 class="text-center mb-5" style="color: var(--text-medium-gray); font-weight: 500; text-transform: uppercase; letter-spacing: 1px;">
            Đối Tác Thương Hiệu Cao Cấp Của Chúng Tôi
        </h5>
        <div class="d-flex justify-content-around align-items-center flex-wrap">
            <img src="${pageContext.request.contextPath}/images/logo-brand-1.png" alt="Brand 1" style="height: 50px; margin: 15px 20px; filter: grayscale(80%); opacity: 0.7; transition: var(--transition-fast);">
            <img src="${pageContext.request.contextPath}/images/logo-brand-2.png" alt="Brand 2" style="height: 50px; margin: 15px 20px; filter: grayscale(80%); opacity: 0.7; transition: var(--transition-fast);">
            <img src="${pageContext.request.contextPath}/images/logo-brand-3.png" alt="Brand 3" style="height: 50px; margin: 15px 20px; filter: grayscale(80%); opacity: 0.7; transition: var(--transition-fast);">
            <img src="${pageContext.request.contextPath}/images/logo-brand-4.png" alt="Brand 4" style="height: 50px; margin: 15px 20px; filter: grayscale(80%); opacity: 0.7; transition: var(--transition-fast);">
        </div>
    </div>
</section>

<section class="testimonial-section section-padding reveal-on-scroll fade-in">
    <div class="container">
        <p class="eyebrow-text text-center light">Phản Hồi Từ Khách Hàng</p>
        <h2 class="section-title text-center">Những Lời Yêu Thương</h2>
        <p class="section-subtitle text-center">Sự hài lòng của bạn là động lực và niềm tự hào lớn nhất của chúng tôi.</p>
        <div class="row mt-5">
            <div class="col-md-4 reveal-on-scroll fade-in-up" data-reveal-delay="100">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap"><img src="${pageContext.request.contextPath}/images/customer-avatar-1.png" alt="Khách hàng 1" class="testimonial-avatar"></div>
                    <p class="quote">Dịch vụ trên cả tuyệt vời! Móng tay tôi được chăm sóc tỉ mỉ và mẫu vẽ rất tinh xảo. Chắc chắn sẽ giới thiệu cho bạn bè.</p>
                    <h5 class="customer-name">- Lan Anh -</h5>
                    <p class="customer-title">Khách Hàng Thân Thiết</p>
                </div>
            </div>
            <div class="col-md-4 reveal-on-scroll fade-in-up" data-reveal-delay="300">
                <div class="testimonial-item">
                    <div class="testimonial-avatar-wrap"><img src="${pageContext.request.contextPath}/images/customer-avatar-2.png" alt="Khách hàng 2" class="testimonial-avatar"></div>
                    <p class="quote">Không gian tiệm cực kỳ thư giãn và nhân viên rất chuyên nghiệp, thân thiện. Tôi cảm thấy như được nuông chiều bản thân.</p>
                    <h5 class="customer-name">- Minh Thư -</h5>
                    <p class="customer-title">Doanh Nhân</p>
                </div>
            </div>
            <div class="col-md-4 reveal-on-scroll fade-in-up" data-reveal-delay="500">
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

<section class="cta-section section-padding reveal-on-scroll fade-in-up" data-reveal-delay="200">
    <div class="container cta-container">
        <p class="eyebrow-text">Đừng Chần Chừ</p>
        <h3 class="cta-title">Sẵn Sàng Cho Vẻ Đẹp Hoàn Hảo?</h3>
        <p class="cta-subtitle">Hãy để KimiBeauty đồng hành cùng bạn trên hành trình khám phá và tôn vinh nét đẹp riêng. Đặt lịch hẹn ngay hôm nay để trải nghiệm dịch vụ đẳng cấp!</p>
        <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-cta-custom btn-lg">Đặt Lịch Hẹn Ngay</a>
    </div>
</section>

<jsp:include page="/WEB-INF/jsp/customer/_footer_customer.jsp" />

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const revealElements = document.querySelectorAll('.reveal-on-scroll');

        const revealOnScroll = () => {
            const windowHeight = window.innerHeight;

            revealElements.forEach(el => {
                const elementTop = el.getBoundingClientRect().top;
                const elementVisible = 100;

                if (elementTop < windowHeight - elementVisible) {
                    const delay = parseInt(el.dataset.revealDelay) || 0;
                    setTimeout(() => {
                        el.classList.add('is-visible');
                    }, delay);
                } else {
                    // el.classList.remove('is-visible');
                }
            });
        };

        revealOnScroll();
        window.addEventListener('scroll', revealOnScroll);
    });
</script>

</body>
</html>