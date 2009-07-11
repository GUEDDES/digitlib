<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('../index.jsp');</script>");
}
else {
%>
<%@ include file="../includes/config.inc.jsp" %>
<%@ include file="../includes/header.inc.jsp" %>
<%@ page import="java.sql.*" %>
<%
try{

Class.forName(JdbcDriver).newInstance();
Connection con =DriverManager.getConnection(Url ,DbUser,DbPass);

if(request.getParameter("t")!=null)
{	
	String query = request.getParameter("owntblscript");
	String database = request.getParameter("dbspc");
	Statement createtblstat = con.createStatement();
	createtblstat.execute(query);	
	response.sendRedirect("dbstruct.jsp?t="+database+"&qry="+query);	
}

con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>
