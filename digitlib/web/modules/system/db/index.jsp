<%@ page language="java" import="org.digitlib.db.*"%>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}%>
<%@ include file="includes/config.inc.jsp" %>
<%
Cookie[] cookies = request.getCookies();
String usercook=""; String passcook="";
for(int i=0;i<cookies.length;i++) {
    if(cookies[i].getName().equals("jspsqluser")) {usercook = cookies[i].getValue();}
}
String themessage = "Please fill out the form below to enter";
String messcolor = "black";
if("admin".equals(session.getValue("status"))) {
    String loginmessage = "";
    try{
        Class.forName(JdbcDriver).newInstance();
        java.sql.Connection con = java.sql.DriverManager.getConnection(Url ,DbUser,DbPass);       
    } catch(java.sql.SQLException sqle){loginmessage=sqle.getMessage();}
    if(loginmessage=="") {
        Cookie jspsqluser = new Cookie("jspsqluser",DbUser);
        jspsqluser.setMaxAge(60*60*24);
        response.addCookie(jspsqluser);
        session.setMaxInactiveInterval(2*60*60);
        //session.putValue("mylog","logged");
        session.putValue("language",defaultlang);
        response.sendRedirect("modules/system/db/main.jsp");
    } else themessage=loginmessage; messcolor="red";
}
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
                    
                    <div align='center'>
                        <h2><font color='blue'>Welcome to JspSqlMyAdmin 1.0 </font></h2><br><a href="../login">Accueil</a>
                        <h3><font color='<%= messcolor %>'><b><%= themessage %></b></font></h3><br><br>
                        <form name='loginform' action='index.jsp' method='post'>
                            USERNAME : 
                            <input type='text' name='myname' value='<%= usercook %>'><br><br>
                            PASSWORD : 
                            <input type='password' name='mypass' value=''><br><br>
                            <input type='hidden' name='process' value='true'>
                            <input type='submit' value='Enter the DB'>
                        </form>
                    </div>
            </td></tr>
            <tr><td align="bottom">
                    <hr size="1" color="blue">
                    <div align="center"><font color="blue"><i><b> Powered by Serge M.Tsafak from DragonSoft Inc</b></i></font></div>
            </td></tr>
            <tr><td align='center'><img src='modules/system/db/images/SergioLogo.png' alt='the power of java' border='0' width='300' height='100'></td></tr>
        </table>
    </body>
</html>

