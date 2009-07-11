
<%@ page language="java"  import="org.digitlib.resource.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" %>
<%@ include file="/config.jsp" %>

<%!    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>
<%

            String status = (String) session.getAttribute("status");
            if ((!status.equals("admin")) && (!status.equals("source"))) {
                response.sendRedirect("index.jsp");
                return;
            }
            String vocType = request.getParameter("voctype");
            String vocName = request.getParameter("vocname");
            String form = (request.getParameter("form")==null)?"":request.getParameter("form");
            if(!"0".equals(vocType)){
%>          &nbsp;
                <a href="#" onclick="browser1('<%=vocName%>','<%=vocType%>','<%=form%>');">
                    <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17">
                </a> 
                &nbsp;
<%
 }
    %> &nbsp; &nbsp;
