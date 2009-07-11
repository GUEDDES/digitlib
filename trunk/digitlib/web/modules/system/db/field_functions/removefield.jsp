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

if(request.getParameter("db")!=null&&request.getParameter("tbl")!=null&&request.getParameter("r")!=null)
{	
	String database = request.getParameter("db");
	String tblname = request.getParameter("tbl");
	Statement removestat = con.createStatement();
	ResultSet removeres = removestat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares = removeres.getMetaData();
	int colcount = metares.getColumnCount();
	String query="DELETE FROM "+database+"."+tblname+" WHERE ";	String end="";
	while(removeres.next()){
	if ((""+removeres.getRow()).equals(request.getParameter("r"))) {for(int i=1;i<=colcount;i++){if(i==colcount){end="";}else{end=" AND ";} query=query+metares.getColumnName(i)+"='"+removeres.getString(i)+"'"+end;}}
	}		
	Statement remover = con.createStatement();	 
	remover.executeUpdate(query);     
	Statement removestat2 = con.createStatement();
	ResultSet removeres2 = removestat2.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares2 = removeres2.getMetaData();
	if(removeres2.next()==false) {response.sendRedirect("../table_functions/dbstruct.jsp?t="+database);} 
	else{response.sendRedirect("../functions/show.jsp?db="+database+"&t="+tblname);}	
	
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>
