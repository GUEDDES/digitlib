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

if(request.getParameter("db")!=null&&request.getParameter("tbl")!=null&&request.getParameter("t")!=null)
{	
	String database = request.getParameter("db");
	String tblname = request.getParameter("tbl");
	String fieldname = request.getParameter("t"); String query="";String redirect="";
	Statement checkcolstat = con.createStatement();
	ResultSet checkcolres = checkcolstat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metacheck = checkcolres.getMetaData();
	int colcount = metacheck.getColumnCount();
	if (colcount==1) {query="DROP TABLE "+database+"."+tblname; redirect="../table_functions/dbstruct.jsp?t="+database+"&qry="+query;}
	else {query="ALTER TABLE "+database+"."+tblname+" DROP "+fieldname; redirect="tblstruct.jsp?db="+database+"&t="+tblname+"&qry="+query;}
	Statement deleter = con.createStatement();
	deleter.executeUpdate(query);	
	response.sendRedirect(redirect);	
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>
