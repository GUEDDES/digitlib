<%@ include file="/admin/functions.jsp" %>
<%
if("admin".equals(session.getAttribute("status")))
    out.print(adminLink("admin.jsp?op=settings&cp=system","Preferences"));

%>
