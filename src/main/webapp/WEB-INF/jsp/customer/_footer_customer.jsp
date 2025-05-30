<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    File này sẽ được include ở cuối các trang khách hàng.
    Đã áp dụng class site-footer từ custom-style.css nếu bạn muốn style riêng.
--%>
<footer class="py-4 site-footer mt-auto"> <%-- Thêm class site-footer nếu có style riêng trong custom-style.css --%>
  <div class="container text-center">
    <small>Copyright © KimiBeauty ${java.time.Year.now()}</small> <%-- Lấy năm hiện tại động --%>
  </div>
</footer>

<%-- Các script JS chung cho trang khách hàng có thể đặt ở đây --%>
<%-- jQuery, Popper.js, Bootstrap.js thường được đặt ở cuối body để tối ưu tải trang --%>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js" integrity="sha384-q9EdA/T4KCk2z3sNfGxlq7JSt3fHhB5pUN2L7R3DDZf8i0QZ3bNn7R8M0mJYmP/" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
<%--
<script src="${pageContext.request.contextPath}/js/customer-main-scripts.js"></script>
--%>
<%-- Script cho hiệu ứng navbar và section reveal --%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const nav = document.querySelector('.navbar-custom');
    if (nav) {
      const onScroll = () => {
        if (window.scrollY > 50) {
          nav.classList.add('scrolled');
        } else {
          nav.classList.remove('scrolled');
        }
      };
      window.addEventListener('scroll', onScroll);
      onScroll(); // Check initial state
    }

    const sectionsToReveal = document.querySelectorAll('.section-reveal');
    if (sectionsToReveal.length > 0) {
      const revealOptions = {
        root: null,
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px"
      };
      const revealObserver = new IntersectionObserver(function(entries, observer) {
        entries.forEach(entry => {
          if (!entry.isIntersecting) {
            return;
          }
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        });
      }, revealOptions);
      sectionsToReveal.forEach(section => {
        revealObserver.observe(section);
      });
    }
  });
</script>