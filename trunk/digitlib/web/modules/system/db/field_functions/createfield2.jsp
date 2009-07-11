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
	int fieldnb = new Integer(request.getParameter("nbfield")).intValue();
	String tblname = request.getParameter("nametbl");String database = request.getParameter("db");
	String query="";		
	String querypart=""; String increparam; String indexparam;String fieldparam;String redirect="";
	String defparam;String typparam;String extraparam;String nilparam;String comma;
	for(int l=1;l<=fieldnb;l++)
	{	
	if(l==fieldnb){comma="";} else{comma=",\n";}
	fieldparam=request.getParameter("field"+l);
	increparam=request.getParameter("auto"+l)==null?"":"AUTO_INCREMENT";
	indexparam=request.getParameter("cbox"+l)==null?"":"ALTER TABLE "+database+"."+tblname+" ADD PRIMARY KEY ("+fieldparam+")";	
	typparam=request.getParameter("type"+l).toUpperCase();
	extraparam=request.getParameter("extra"+l).toUpperCase();
	defparam=request.getParameter("default"+l).equals("")?"":"DEFAULT '"+request.getParameter("default"+l)+"'";
	nilparam=request.getParameter("nil"+l)==null?"":"NOT NULL";
	querypart="ALTER TABLE "+database+"."+tblname+" ADD "+fieldparam+" "+typparam+" "+extraparam+" "+defparam+" "+nilparam+" "+increparam;
	query=query+"<br>"+querypart+"<br>"+indexparam;	
	Statement createtblstat = con.createStatement();
	createtblstat.executeUpdate(querypart);
	createtblstat.close();
	if(!indexparam.equals(""))
	{
	Statement createtblstat2 = con.createStatement();
	createtblstat2.executeUpdate(indexparam);
	createtblstat2.close();	
	}
	}
	redirect="tblstruct.jsp?db="+database+"&t="+tblname+"&qry="+query;
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
