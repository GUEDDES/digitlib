<%@ include file="/admin/functions.jsp" %>
<%
String status = (String)session.getAttribute("status");
if("admin".equals(status)||"source".equals(status))
    out.print(adminLink("admin.jsp?cp=resources&op=new","Resources"));

%>
