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
	String indexparam="";
	String query="ALTER TABLE "+database+"."+tblname+" CHANGE "+request.getParameter("t")+" "+request.getParameter("field")+" "+request.getParameter("type")+" "+request.getParameter("extra")+" ";
	if (!request.getParameter("default").equals("")) {query=query+"DEFAULT '"+request.getParameter("default")+"' ";}
	if (request.getParameter("nullcb")!=null) {query=query+"NOT NULL ";}
	if (request.getParameter("autoinccb")!=null) {query=query+"AUTO_INCREMENT ";}
	if (request.getParameter("keycb")!=null) {indexparam="ALTER TABLE "+database+"."+tblname+" ADD PRIMARY KEY ("+request.getParameter("t")+")";}
	Statement changer = con.createStatement();
	changer.executeUpdate(query);
	if(!indexparam.equals(""))
	{
	Statement changer2 = con.createStatement();
	changer2.executeUpdate(indexparam);	
	}

	response.sendRedirect("tblstruct.jsp?db="+database+"&t="+tblname+"&qry="+query+"<br>"+indexparam);
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>


