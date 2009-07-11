<%@ page language="java" import="java.util.*" %>

<% 
String theme = (String)session.getAttribute("theme");
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/themes/"+theme,locale);
%>

</div>
</div>

<!--end content -->
<div id="siteInfo"> <img src="themes/classic/images/lri.png" width="44" height="22" /> 
            <a href="http://www.lri.fr/bd">About Us</a> | <a href="#">Site Map</a> | 
            <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> | &copy;2005 
        Laboratoire de Recherche en Informatique </div>

</body>
</html>