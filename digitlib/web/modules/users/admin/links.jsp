<%@ include file="/admin/functions.jsp" %>
<%
if("admin".equals(session.getAttribute("status"))){
    out.print(adminLink("admin.jsp?op=new&cp=users","Users"));  
}


out.print(adminLink("modules.jsp?name=users&op=logout","Logout"));

%>
