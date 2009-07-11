<%@ page language="java" import="java.util.*" %>
<%@ include file="/config.jsp" %>
<%@ include file="/header.jsp" %>
<%
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lg = ResourceBundle.getBundle("org/digitlib/lang",locale);

if(request.getParameter("msg")!=null){
    String url = (request.getParameter("url")==null)?"":request.getParameter("url");
    if(request.getParameter("title")!=null){
        %> 

        <div class="box1">
            <h1 align="center"><%=request.getParameter("title")%></h1>
        </div>
        <%
    }
    %>
    <div class="box1" align="center"><%=request.getParameter("msg")%> <br><br>
        <%=url%>
    </div>

    <%
}else
    out.print(lg.getString("welcome.message"));
%>


<%@ include file="/footer.jsp" %>