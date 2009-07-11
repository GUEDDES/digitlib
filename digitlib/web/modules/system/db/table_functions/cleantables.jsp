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
	int tblcount = new Integer(request.getParameter("tblcount")).intValue();
	String database = request.getParameter("db");
	String cleanact = request.getParameter("tblaction"); 
	String query="";String querypart="";String process=null;String redirect="";	
	for(int i=1;i<=tblcount;i++)
	{
	if(request.getParameter("tblcbox"+i)!=null)
	{
	process="yes";
	if(cleanact.equals("tbldrop"))
	{querypart="DROP TABLE "+database+"."+request.getParameter("nametblcbox"+i);}
	else if(cleanact.equals("tblempty"))
	{querypart="TRUNCATE "+database+"."+request.getParameter("nametblcbox"+i);}
	query=query+"<br>"+querypart;
	Statement partstat = con.createStatement();
	partstat.executeUpdate(querypart);
	}	
	}	
	if(process!=null) 
	{
	redirect="dbstruct.jsp?t="+database+"&qry="+query;
	response.sendRedirect(redirect);	
	}
	else
	{
	out.println("<script language='javascript'>window.alert('You must select at least one table !'); self.location.href=document.referrer</script>");
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
