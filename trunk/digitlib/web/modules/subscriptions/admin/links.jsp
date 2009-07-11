<%@ include file="/admin/functions.jsp" %>
<%
String status = (String)session.getAttribute("status");
if("admin".equals(status))
out.print(adminLink("admin.jsp?cp=subscriptions&op=new","Subscriptions"));
else
out.print(adminLink("admin.jsp?cp=subscriptions&op=new","My subscriptions"));
%>
