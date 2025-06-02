<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="site-footer">
  <div class="container">
    <div class="row">
      <div class="col-lg-4 col-md-6 footer-column mb-4 mb-lg-0">
        <h5 class="footer-title">KimiBeauty</h5>
        <p class="footer-about-text">
          Nơi vẻ đẹp của bạn được chăm chút tỉ mỉ và thăng hoa. KimiBeauty tự hào mang đến những dịch vụ làm móng chuyên nghiệp, sáng tạo cùng không gian thư giãn đẳng cấp.
        </p>
        <div class="social-icons mt-3">
          <a href="#" target="_blank" title="Facebook" class="social-icon"><i class="fab fa-facebook-f"></i></a>
          <a href="#" target="_blank" title="Instagram" class="social-icon"><i class="fab fa-instagram"></i></a>
          <a href="#" target="_blank" title="Tiktok" class="social-icon"><i class="fab fa-tiktok"></i></a>
        </div>
      </div>

      <div class="col-lg-2 col-md-6 footer-column mb-4 mb-lg-0">
        <h5 class="footer-title">Khám Phá</h5>
        <ul class="footer-links list-unstyled">
          <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/#our-story">Về Chúng Tôi</a></li>
          <li><a href="${pageContext.request.contextPath}/services">Dịch Vụ</a></li>
          <li><a href="${pageContext.request.contextPath}/nail-arts">Bộ Sưu Tập</a></li>
          <li><a href="${pageContext.request.contextPath}/customer/book-appointment">Đặt Lịch Hẹn</a></li>
        </ul>
      </div>

      <div class="col-lg-3 col-md-6 footer-column mb-4 mb-md-0">
        <h5 class="footer-title">Liên Hệ</h5>
        <ul class="footer-contact-info list-unstyled">
          <li>
            <i class="fas fa-map-marker-alt footer-icon"></i>
            <span>Số 3 - Đ.Núi Đôi - Tổ 7 - TT.Sóc Sơn</span>
          </li>
          <li>
            <i class="fas fa-phone-alt footer-icon"></i>
            <span><a href="tel:0372422193">0372 422 193</a></span>
          </li>
          <li>
            <i class="fas fa-envelope footer-icon"></i>
            <span><a href="mailto:anguyenthi947@gmail.com">anguyenthi947@gmail.com</a></span>
          </li>
          <li>
            <i class="fas fa-clock footer-icon"></i>
            <span>Giờ mở cửa: 9:00 - 20:00 (T2 - CN)</span>
          </li>
        </ul>
      </div>

      <div class="col-lg-3 col-md-6 footer-column">
        <h5 class="footer-title">Nhận Tin Mới</h5>
        <p class="footer-newsletter-text">Đăng ký để không bỏ lỡ ưu đãi và xu hướng nail mới nhất từ KimiBeauty!</p>
        <form action="#" method="post" class="newsletter-form">
          <div class="input-group">
            <input type="email" class="form-control" placeholder="Địa chỉ email của bạn" required>
            <button class="btn btn-primary-custom-filled" type="submit">Đăng Ký</button>
          </div>
        </form>
      </div>

    </div>

    <div class="footer-bottom">
      <p>© ${java.time.Year.now()} KimiBeauty. All Rights Reserved. Thiết kế bởi <a href="#" target="_blank" style="color: var(--secondary-pink);">devfromzk</a>.</p>
    </div>
  </div>

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="fas fa-arrow-up"></i></a>

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      const navbar = document.querySelector('.navbar-custom');
      if (navbar) {
        window.addEventListener('scroll', function() {
          if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
          } else {
            navbar.classList.remove('scrolled');
          }
        });
      }

      const backToTopButton = document.querySelector('.back-to-top');
      if (backToTopButton) {
        window.addEventListener('scroll', () => {
          if (window.scrollY > 100) {
            backToTopButton.classList.add('active');
          } else {
            backToTopButton.classList.remove('active');
          }
        });
        backToTopButton.addEventListener('click', (e) => {
          e.preventDefault();
          window.scrollTo({ top: 0, behavior: 'smooth' });
        });
      }
    });
  </script>
  <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</footer>