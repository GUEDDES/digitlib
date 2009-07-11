<%
if("admin".equals(session.getValue("status"))){
    String NOFRAMES="";
    if ("english".equals(session.getValue("language"))) {
        NOFRAMES = "Your browser does not support html frames!Please use another one.";} else if ("french".equals(session.getValue("language"))) {
        NOFRAMES = "Votre navigateur ne supporte pas les frames html!Veuillez utiliser un autre.";} else if ("german".equals(session.getValue("language"))) {
        NOFRAMES = "Ihr Browser unterstützt keine HTML-Frames!Verwenden Sie bitte einen anderen.";} else {NOFRAMES = "Your browser does not support html frames!Please use another one.";}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
    <head><title>JspSqlMyAdmin - by Serge M. Tsafak</title>
        <meta http-equiv=\"Expires\" CONTENT=\"-1\">              
        <meta http-equiv=\"Pragma\" CONTENT=\"no-cache\">                
        <meta http-equiv=\"Cache-Control\" CONTENT=\"no-cache\">
    </head>
    <frameset cols='20%,80%' frameborder="0" framespacing="1">
        <frame src='nav.jsp' name='nav'>
        <frame src='panel.jsp' name='panel'>
        <noframes><%=NOFRAMES%></noframes>
    </frameset>
</html>
<%}
else{
out.println("<script language='javascript'>parent.location.replace('index.jsp');</script>");
}%>
