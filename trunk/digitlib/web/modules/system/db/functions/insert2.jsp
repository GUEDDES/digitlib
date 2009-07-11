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

if(request.getParameter("db")!=null&&request.getParameter("tbl")!=null&&request.getParameter("processori").equals("true"))
{
	String database = request.getParameter("db");
	String tblname = request.getParameter("tbl");
	int colcount = new Integer(request.getParameter("count")).intValue();
	String query="INSERT INTO "+database+"."+tblname; String querymiddle="(";
	Statement insertstat = con.createStatement();
	ResultSet insertres = insertstat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares = insertres.getMetaData();	String end="";	
	for(int i=1;i<=colcount;i++) 
	{ if(i==colcount){end=")";} else{end=",";} 
	querymiddle=querymiddle+metares.getColumnName(i)+end;		
	}	
	Statement insertstat2 = con.createStatement();
	ResultSet insertres2 = insertstat2.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares2 = insertres2.getMetaData(); String querylast=" VALUES(";  String end2=""; String extra="";
	for(int i=1;i<=colcount;i++) 
	{if(i==colcount){end2=")";} else{end2=",";} 
	if(request.getParameter("newfunction"+i).equals("")){extra="'"+request.getParameter("newvalue"+i)+"'";} else{extra=request.getParameter("newfunction"+i)+"('"+request.getParameter("newvalue"+i)+"')";}
	querylast=querylast+extra+end2;
	}
		
	query=query+querymiddle+querylast;
	Statement insertor = con.createStatement();
	insertor.executeUpdate(query);	
	response.sendRedirect("show.jsp?db="+database+"&t="+tblname);
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>



