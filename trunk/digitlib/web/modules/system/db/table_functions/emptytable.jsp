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

if(request.getParameter("t")!=null&&request.getParameter("db")!=null)
{	
	String target = request.getParameter("t"); String database = request.getParameter("db");
	Statement emptstat = con.createStatement();
	ResultSet emptres = emptstat.executeQuery("SELECT * FROM "+database+"."+target);
	if(emptres.next()==false) 
	{out.println("<script language='javascript'> window.alert('This table is empty!');self.location.href=document.referrer;</script>");}
	else{
	String query="TRUNCATE TABLE "+database+"."+target; String redirect="dbstruct.jsp?t="+database+"&qry="+query;	
	Statement tblcleanstat = con.createStatement();
	tblcleanstat.executeUpdate(query);
	tblcleanstat.close();
	response.sendRedirect(redirect);
	}
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>

