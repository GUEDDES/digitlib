<% 

if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('index.jsp');</script>");
}
else {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head><title>JspSqlMyAdmin - by Serge M.Tsafak</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<style>
a{text-decoration:none;}
a:active{color:purple;}
a:hover{color:green;}
.db{color:blue;}
.tables{color:black;}
.columns{color:black;}
</style>
</head>
<body bgColor='#6e94b7'>
<table border="0" width="100%">
<tr><td>
	<table align='center' border='0'>
	<tr>	
	<td align='left'></td>
	<td align='right'><img src='images/SergioLogo.png' alt='The Dragon Soft Inc' border='0'></td>
	</tr>
	<tr><td colspan='2'><div align='justify'><font face='Arial,Verdana'><b>
	<blockquote>Welcome again,</blockquote>
	I am proud to know you decided to use JspSqlMyAdmin to manage your sql databases! I wrote this relative simple
	web application in order to make it easier for java servlet/jsp web developers to basically administrate their own mysql based
	databases like php developers with PhpMyAdmin.That is why (may be you noticed) it looks like
	PhpMyAdmin at first sight:yes,I tried so much as possible (but not too much) to give my application a PhpMyAdmin
	look!For php developers and fans like me it becomes then easier to get trusted with its usage .<br>
	I began to write this application because I found it a bit more difficult for servlet/jsp web developers to manage a
	sql database.I first learned php and enjoyed how easy it was with PhpMyAdmin big databases to administrate.
	So,I decided to write for myself such a program while building my first jsp/servlet based homepage.My web space provider
	did not offer any sql client and I knew no such programs at this time (I mean web based ones).I did not want to
	download mysqlfront or any freeware on the net just for this simple task:create a single sql table for my page.
	As it worked fine for me,I decided to make other people benefit from it!Now I guess you are using and enjoying it!<br>
	There are certainly many things to improve and I am afraid I have not enough time to do it .So it will be a great
	pleasure for me to get improvement suggestions from you via email ! <br>
	There is no documentation available for this version but does someone really need one for such a simple application?!
	Below a link to the reference documentation of mysql : <br><br>
	<a href='http://www.mysql.com/documentation' target='_blank'> MySQL : the world's most popular open source database </a><br><br>
	I hope you enjoy the application and have time to email me at <a href='mailto:tsafserge2001@yahoo.fr?subject=About JspSqlMyAdmin'>
	tsafserge2001@yahoo.fr</a> for suggestions ! <br><br><br>	
	Serge M. Tsafak		
	</b></font>
	</div></td></tr>
	</table>

</td></tr>
<tr><td align="bottom">
<hr size="1" color="blue">
<div align="center"><font color="blue"><i><b> Powered by Serge M.Tsafak from DragonSoft Inc</b></i></font></div>
</td></tr>
<tr><td align='center'><img src='images/SergioLogo.png' alt='the power of java' border='0' width='300' height='100'></td></tr>
</table>
</body>
</html>

<%
}
%>
