<%@ page language="java" import="java.util.*" %>
<%
String multitheme = (String)session.getAttribute("multitheme");
String multilingual = (String)session.getAttribute("multilingual");
String theme = (String)session.getAttribute("theme");
String status = (String)session.getAttribute("status");
String login = (String)session.getAttribute("login");
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/lang",locale);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- DW6 -->
<head>
    <!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title><%=lang.getString("docTitle")%></title>
    <link rel="stylesheet" href="themes/classic/style.css" type="text/css" />
    <link rel="stylesheet" href="themes/classic/content.css" type="text/css" />
    <SCRIPT language=javascript type="text</javascript">

            function fieldEmpty(form, field){
                var reg=new RegExp("[ ,;!*:]+", "g");
                var tab=form[field].value.split(reg);
                if((tab.length==1)&&(tab[0]==""))
                   tab.length=0;
                if (tab.length==0){
                    return true;
                }
                return false;
            }
            function verifQueryFormNavbar(form){
                if(fieldEmpty(form, 'query')){
                    form['query'].value='';
                }
                form.action = "modules.jsp?name=search&res="+form['res'].value;
                form.submit;
            }
            </SCRIPT>
</head>
<body>
<div id="masthead">
    <div id="siteName">
      <div class="site"  ><img src="themes/classic/images/logo-<%=locale.getLanguage()%>.jpg" width="100%" height="150"  /></div>
    </div>
    <div id="globalNav"> <a href="index.jsp"><%=lang.getString("home")%></a> | <a href="#"><%=lang.getString("download")%></a> | <a href="docs/javadoc/index.html"><%=lang.getString("javadoc")%></a> | <a href="#"><%=lang.getString("help")%></a> |</div>
    <h2 id="pageName">&nbsp;</h2>
</div>
<div id="bloc">
<div id="navBar">
    <div id="search">

            <FORM  name='navBarFormSearch' action="modules.jsp?name=resources&op=search" method=post onSubmit="return verifQueryFormNavbar(window.document.forms['navBarFormSearch'])">
                <INPUT size=14 name=query MAXLENGTH="50">
                <input type='submit' name='NPSearch' value='<%=lang.getString("search")%>' />
            </FORM>
        </div>

    <div id="sectionLinks">
        <% if (status.equals("admin")){%>
        <h3>Main menu</h3>
        <ul>
            <li><a href="admin.jsp">Administration</a></li>
            <li><a href="admin.jsp?op=listing&cp=resources">Manage resources</a></li>
            <li><a href="admin.jsp?op=listing&cp=vocabularies">Manage vocabularies</a></li>
            <li><a href="admin.jsp?op=listing&cp=users">Manage users</a></li>
            <li><a href="admin.jsp?op=listing&cp=subscriptions">Manage subscriptions</a></li>
            <li><a href="admin.jsp?op=update&cp=users&login=<%=login%>">My profile</a></li>
            <li><a href="modules.jsp?name=users&op=logout">Logout</a></li>
        </ul>

        <%}
        if (status.equals("source")){%>


        <h3>Main menu</h3>
        <ul>
            <li><a href="admin.jsp?cp">Administration</a></li>
            <li><a href="admin.jsp?op=listing&cp=resources">Manage resources</a></li>
            <li><a href="admin.jsp?op=listing&cp=subscriptions">Manage subscriptions</a></li>
            <li><a href="admin.jsp?op=update&cp=users&login=<%=login%>">My profile</a></li>
            <li><a href="modules.jsp?name=users&op=logout">Logout</a></li>
        </ul>


        <%}
        if (status.equals("user")){%>


        <h3>Main menu</h3>
        <ul>
            <li><a href="admin.jsp">Homepage</a></li>
            <li><a href="admin.jsp?op=listing&cp=subscriptions">Manage subscriptions</a></li>
            <li><a href="admin.jsp?op=update&cp=users&login=<%=login%>">My profile</a></li>
            <li><a href="modules.jsp?name=users&op=logout">Logout</a></li>
        </ul>
        <%}
    if(multilingual.equals("1")){
                                %>
        <h3><%=lang.getString("language")%></h3>
        <form name='langForm' method='post' action='' onsubmit="this.submit.disabled='true'">
            <select name="lang" onchange="window.document.forms['langForm'].submit()">
                <option value="en_US"  <%=(locale.toString().equals("en_US")?"selected":"")%> >English</option>
                <option value="fr_FR" <%=(locale.toString().equals("fr_FR")?"selected":"")%> >French</option>
                <option value="wo_SN" <%=(locale.toString().equals("wo_SN")?"selected":"")%> >Wolof</option>
            </select>
        </form>
    <%}
    if(multitheme.equals("1")){
        List themesList = (List)session.getAttribute("themesList");
                                    %>
        <h3><%=lang.getString("template")%></h3>
        <form name='themesForm' method='post' action='' onsubmit="this.submit.disabled='true'">
            <select name="theme" onchange="window.document.forms['themesForm'].submit()">
                <%
                for (int i = 0; i < themesList.size(); ++i)
                    out.print("<option value=\""+themesList.get(i)+"\"  "+(theme.equals(themesList.get(i))?"selected":"")+">"+themesList.get(i)+"</option>");
                %>
            </select>
        </form>
    <%}%>
    </div>
    <!--<div class="relatedLinks">
        <h3>Related Link Category</h3>
        <ul>
            <li><a href="#">Related Link</a></li>
            <li><a href="#">Related Link</a></li>
            <li><a href="#">Related Link</a></li>
        </ul>
    </div>-->
</div>
<!--end navBar div -->
<div id="headlines">
    <% if(status.equals("anonymous")){%>
    <h3><%=lang.getString("connexion")%></h3>
    <form name='login' method='post' action='modules.jsp?name=users&op=login'>
        <%=lang.getString("login")%><br />
        <input name='login' type='text' size='10' maxlength="40" value="admin">
        <br /><%=lang.getString("password")%><br />
        <input name='pwd' type='password' size='10' value='admin' maxlength="40">
        <input name='loginOk' type='submit' value="<%=lang.getString("loginButton")%>">
        <div id="msg" ></div>
    </form>
    <%}else{%>
    <h3><%=lang.getString("disconnexion")%></h3>
    [<a href="javascript:location.replace('modules.jsp?name=users&op=logout')">Log out</a>]
    <%}%>

    <div id="advert">
        <h3>Algorithms testing</h3>
        <ul>
            <li><a href="modules.jsp?name=resources&op=advanced">LBA</a>
            <li><a href="modules.jsp?name=resources&op=advanced">TBA</a>
            <li><a href="modules.jsp?name=resources&op=adecyg">BCA</a>
        </ul>

        <h3>Integrated tools</h3>
        <ul>
            <li><a href="modules.jsp?name=rdf&op=w3crdfvalidator">W3C Rdf Validator</a>
        </ul>
    </div>


</div>

<div id="contents">

</div>
</div>

<!--end content -->
<div id="siteInfo"> <img src="themes/classic/images/lri.png" width="44" height="22" />
            <a href="http://www.lri.fr/bd">About Us</a> | <a href="#">Site Map</a> |
            <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> | &copy;2005
        Laboratoire de Recherche en Informatique </div>

</body>
</html>