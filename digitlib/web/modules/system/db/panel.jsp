<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('index.jsp');</script>");
}
else {
%>
<%@ include file="includes/config.inc.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head><title>JspSqlMyAdmin - by Serge M.Tsafak</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<style>
a{text-decoration:none;}
a:active{color:purple;}
a:hover{color:green;}
.db{color:blue;}
.tables{color:black;}
.columns{color:black;}
</style>
<base target='_self'>
</head>
<body bgColor='#6e94b7' onLoad="setTimeout('hideStatus()','1000');">
<table border="0" width="100%">
<tr><td>

<% 
out.println("<div align='left'><h2>Welcome to the JspSqlMyAdmin Administration Panel</h2><h4> MySQL running on "+DbHost+" as "+DbUser+"@"+DbHost+"</h4><a href='about.jsp'><b>About JspSqlMyAdmin...</b></a><br><br><br></div>");	
%>
</td></tr>
<tr><td align="bottom">
<hr size="1" color="blue">
<div align="center"><font color="blue"><i><b> Powered by Serge M.Tsafak from DragonSoft Inc</b></i></font></div>
</td></tr>
<tr><td align='center'><img src='images/SergioLogo.png' alt='the power of java' border='0' width='300' height='100'><br><br><a href="<%=request.getContextPath()%>/admin.jsp" TARGET="_top">Admin panel</a></td></tr>
</table>
</body>
</html>
<%
}
%>
