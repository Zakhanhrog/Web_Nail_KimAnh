<!--
  No explicit servlet mapping needed in web.xml because we use @WebServlet annotation for NailArtImageServlet.
  If you want to override or use web.xml mapping, add below:

  <servlet>
    <servlet-name>NailArtImageServlet</servlet-name>
    <servlet-class>com.tiemnail.app.controller.NailArtImageServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>NailArtImageServlet</servlet-name>
    <url-pattern>/uploads/nailarts/*</url-pattern>
  </servlet-mapping>
-->
