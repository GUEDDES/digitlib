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
	int colcount = new Integer(request.getParameter("count")).intValue(); String query=" SET ";String end="";String extra="";
	Statement editstat = con.createStatement();
	ResultSet editres = editstat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares = editres.getMetaData();	
	while(editres.next()){
	if ((""+editres.getRow()).equals(request.getParameter("r"))) 
	{
	for(int i=1;i<=colcount;i++) { if(i==colcount){end="";} else{end=",";} if(request.getParameter("newfunction"+i).equals("")){extra="'"+request.getParameter("newvalue"+i)+"'";} else{extra=request.getParameter("newfunction"+i)+"('"+request.getParameter("newvalue"+i)+"')";}
	query=query+metares.getColumnName(i)+"="+extra+end;
	}
	}
	}	
	Statement editstat2 = con.createStatement();
	ResultSet editres2 = editstat2.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares2 = editres2.getMetaData(); String querylast=" WHERE ";String end2="";
	while(editres2.next()){
	if ((""+editres2.getRow()).equals(request.getParameter("r"))) 
	{
	for(int i=1;i<=colcount;i++) {if(i==colcount){end2="";} else{end2=" AND ";}
	querylast=querylast+metares2.getColumnName(i)+"='"+editres2.getString(i)+"' "+end2;
	}
	}
	}		
	query="UPDATE "+database+"."+tblname+query+querylast;
	Statement editor = con.createStatement();
	editor.executeUpdate(query);	
	response.sendRedirect("../functions/show.jsp?db="+database+"&t="+tblname);
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>


