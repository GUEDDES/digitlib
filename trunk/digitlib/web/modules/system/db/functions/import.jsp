<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('../index.jsp');</script>");
}
else {
%>
<%@ include file="../includes/config.inc.jsp" %>
<%@ include file="../includes/header.inc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%!
private String readFileContent(String file)
{
String filecontent="";
try{
BufferedReader freader=new BufferedReader(new FileReader(file));
while(freader.ready())	{filecontent=filecontent+"\n"+freader.readLine();}
}
catch (Exception ex) {System.out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}
return filecontent;
}
%>
<%
try{
Class.forName(JdbcDriver).newInstance();
Connection con =DriverManager.getConnection(Url ,DbUser,DbPass);

if(!request.getParameter("importfile").equals("")&&request.getParameter("db")!=null)
{	
	String infile = request.getParameter("importfile");
	String database = request.getParameter("db");		
	Statement stat = con.createStatement();
	stat.execute(readFileContent(infile));
	out.println("<script language='javascript'>window.alert('datas import was successfull!');self.location.href='../table_functions/dbstruct.jsp?t="+database+"';</script>");
}
else
{
out.println("<script language='javascript'>");
if(request.getParameter("importfile").equals("")) {out.println("window.alert('You must select a sql script file!');");}
out.println("self.location.href=document.referrer</script>");
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>




