<%@ page language="java" import="java.util.*" %>
<% 
String theme = (String)session.getAttribute("theme");
String login = (String)session.getAttribute("login");
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/themes/"+theme,locale);


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-- saved from url=(0032)http://digitlib.sourceforge.net/ -->
<HTML><HEAD><TITLE></TITLE>
    <META http-equiv=Content-Type content="text/html; charset=windows-1252"><!-- tinyMCE -->
    <SCRIPT language=javascript src="themes/milo/style/tiny_mce.js" 
            type="text/javascript"></SCRIPT>
    
    <SCRIPT language=javascript type="text/javascript" >
            tinyMCE.init({
            mode : "textareas",
            theme : "default",
            language : "english",
            editor_css : "themes/Milo/style/editor.css",
            force_p_newlines: "false",
            force_br_newlines: "true"
            });

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
                form.submit();
               
            }
            </SCRIPT>
    <!-- /tinyMCE -->
    <LINK title=RSS href="backend.php" type="application/rss+xml" rel=alternate>
    <LINK href="themes/milo/style/style.css" type="text/css" rel=StyleSheet>
    <LINK href="themes/milo/style/content.css" type="text/css" rel=StyleSheet>     
                        <META content="MSHTML 6.00.6000.16525" name=GENERATOR>
</HEAD>
<BODY text=#000000 vLink=#363636 aLink=#d5ae83 link=#363636 
      bgColor=#ffffff><BR><BR>
<TABLE cellSpacing=0 cellPadding=0 width=800 align=center bgColor=#ffffff 
       border=0>
    <TBODY>
        <TR>
            <TD width=306 bgColor=#ffffff><A 
                    href="http://digitlib.sourceforge.net/index.php"><IMG 
                        alt="Welcome to Digitlib" src="themes/milo/images/logo.gif" align=left 
    border=0></A></TD></TR></TBODY></TABLE><BR>
<TABLE cellSpacing=0 cellPadding=0 width=800 align=center bgColor=#ffffff 
       border=0>
    <TBODY>
        <TR>
    <TD bgColor=#808080><IMG src="themes/milo/images/tophighlight.gif" WIDTH="800"></TD></TR></TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=800 align=center bgColor=#ffffff 
       border=0>
    <TBODY>
        <TR valign=center>
            <TD align=left width=400 bgColor=#c0c0c0>&nbsp;&nbsp;<a href='index.jsp'>Home</a></TD>
            <TD align=right bgColor=#c0c0c0 >
                <!--FORM name='navBarFormSearch' action="search" method=post onSubmit="return verifQueryFormNavbar(window.document.forms['navBarFormSearch'])">
                    <FONT class=content color=#000000><B>Search </B>
                        <INPUT size=14 name=NPQuery>
                        <input type='submit' name='NPSearch' value='Go' /> 
                        <br><span id="swpLink"><a href='search.jsp'>With Preferences</a></span>
                    </FONT>
                </FORM-->
            </TD>
        </TR>
    </TBODY>
</TABLE>
<TABLE cellSpacing="0" cellPadding="0" width="800" align="center" bgColor="#fefefe" border="0">
    <TBODY>
        <TR>
            <TD bgColor=#000000 colSpan=4><IMG height=1 alt="" hspace=0 
                                           src="themes/milo/images/pixel.gif" width=1 border=0></TD>
        </TR>
        <TR vAlign=center bgColor=#808080>
            <TD noWrap width="15%"><!--FONT class=content color=#363636>&nbsp;&nbsp;<FONT 
                        color=#363636><A 
                        href="http://digitlib.sourceforge.net/modules.php?name=Your_Account">Create</A></FONT> 
            an account </FONT--></TD>
            <TD align=middle width="60%" height=20><FONT class=content>&nbsp; 
            </FONT></TD>
            <TD align=right width="25%"><FONT class=content>
                    <SCRIPT type="text/javascript">
                            
                            <!--   // Array ofmonth Names
var monthNames = new Array( "January","February","March","April","May","June","July","August","September","October","November","December");
var now = new Date();
thisYear = now.getYear();
if(thisYear < 1900) {thisYear += 1900}; // corrections if Y2K display problem
document.write(monthNames[now.getMonth()] + " " + now.getDate() + ", " + thisYear);
// -->
                            
                            </SCRIPT>
            </FONT>
            </TD>
        <TD>&nbsp;</TD>
        </TR>
        <TR>
            <TD bgColor=#000000 colSpan=4><IMG height=1 alt="" hspace=0 
                                       src="themes/milo/images/pixel.gif" width=1 border=0></TD></TR></TBODY>
</TABLE><!-- FIN DEL TITULO -->
<TABLE cellSpacing=0 cellPadding=0 width=800 align=center bgColor=#ffffff 
       border=0>
    <TBODY>
        <TR vAlign=top>
            <TD bgColor=#c0c0c0><IMG height=3 alt="" src="themes/milo/images/pixel.gif" 
                                 width=1 border=0></TD></TR>
        <TR vAlign=top>
            <TD bgColor=#ffffff><IMG height=5 alt="" src="themes/milo/images/pixel.gif" 
                             width=1 border=0></TD></TR></TBODY>
</TABLE><BR>
<TABLE cellSpacing="0" cellPadding="0" width="800" align="center" bgColor="#ffffff" border="0">
<TBODY>
<TR vAlign=top>
<TD vAlign=top width=170 bgColor=#eeeeee>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
                                <TD align=left><FONT class=content 
                                                         color=#363636><B>Search</B></FONT> 
        </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR>
                <TD VALIGN="MIDDLE">
                    <DIV  id="navFormSearch" >
                        <FORM  name='navBarFormSearch' action="modules.jsp?name=resources&op=search" method=post onSubmit="verifQueryFormNavbar(window.document.forms['navBarFormSearch'])">
                            <INPUT size=18 name=query>     
                            <input type='submit' name='NPSearch' value='Go' /> <br>
                        </FORM>                                                                                                   
                    </DIV>
                </TD>
            </TR>
        </TBODY>
    </TABLE><BR>
    <% if ("admin".equals(session.getAttribute("status"))){%>

    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
        <TD align=left><FONT class=content color=#363636><B>Main menu</B></FONT> </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR valign=top>
                <TD>
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp">Administration</a><BR>                
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=listing&cp=resources">Manage resources</a><BR> 
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=listing&cp=vocabularies">Manage vocabularies</a><BR>              
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=listing&cp=users">Manage users</a><BR>   
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=listing&cp=subscriptions">Manage subscriptions</a><BR>             
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=register&cp=users&login=<%=login%>">My profile</a><BR>  
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="modules.jsp?name=users&op=logout">Logout</a><BR>                      
                                                        
                </TD>
            </TR>
        </TBODY>
    </TABLE>    <BR>

    <%}%>
    
    <% if ("source".equals(session.getAttribute("status"))){%>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
        <TD align=left><FONT class=content color=#363636><B>Main menu</B></FONT> </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR vAlign=top>
                <TD>
                
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?cp">Administration</a><br>              
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=listing&cp=resources">Manage resources</a><br>
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="#">Manage subscriptions</a><br>   
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=register&cp=users&login=<%=login%>">My profile</a><br>
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="modules.jsp?name=users&op=logout">Logout</a><br>                    
                </TD>
            </TR>
        </TBODY>
    </TABLE>    <BR>
  
    <%}%>
    
    <% if ("user".equals(session.getAttribute("status"))){%>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
        <TD align=left><FONT class=content color=#363636><B>Main menu</B></FONT> </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR vAlign=top>
                <TD>                
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp">Homepage</a><br>              
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="admin.jsp?op=register&cp=users&login=<%=login%>">My profile</a><br>               
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="#">My subscriptions</a><br>  
            <STRONG><BIG>·</BIG></STRONG>&nbsp;<a href="modules.jsp?name=users&op=logout">Logout</a><br>                       
                </TD>
            </TR>
        </TBODY>
    </TABLE>    <BR>
 
    <%}%> 
    
    <% if("anonymous".equals(session.getAttribute("status"))){%>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
                                <TD align=left><FONT class=content 
                                                         color=#363636><B>Connexion</B></FONT> 
        </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR>
                <TD>
                    <DIV id="form">
                        <form name='login' method='post' action='modules.jsp?name=users&op=login'"> 
                            <span id="lgText">Login</span>
                            <input name='login' type='text' size='15' maxlength="40">
                            <br /><span id="lgText">Pwd</span>
                            <input name='pwd' type='password' size='15' value='' maxlength="40">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input name='loginOk' type='submit' value="Log in">                        
                        </form>
                        
        </DIV></TD></TR></TBODY>
    </TABLE><BR> 
    <%} else {%>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
                                <TD align=left><FONT class=content 
                                                         color=#363636><B>Disconnexion</B></FONT> 
        </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR vAlign=top>
                <TD>
                    <STRONG><BIG>·</BIG></STRONG>&nbsp;[<a href="modules.jsp?name=users&op=logout">Log out</a>]<BR>
                    
                </TD>
            </TR>
        </TBODY>
    </TABLE><BR>     
    <%}
    if("1".equals(session.getAttribute("multilingual"))){ 

                                %>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
                                <TD align=left><FONT class=content 
                                                         color=#363636><B>Languages</B></FONT> 
        </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>
    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR vAlign=top>
                <TD>
                    <DIV align=center>
                        <form  name='langForm' method='post' action='' onsubmit="this.submit.disabled='true'">
                            <select name="lang" onchange="window.document.forms['langForm'].submit()">
                                <option value="en_US"  <%=(locale.toString().equals("en_US")?"selected":"")%> >English</option>"+
                                <option value="fr_FR" <%=(locale.toString().equals("fr_FR")?"selected":"")%> >French</option>"+
                                <option value="wo_SN" <%=(locale.toString().equals("wo_SN")?"selected":"")%> >Wolof</option>"+
                            </select>
                        </form>
                        
        </DIV></TD></TR></TBODY>
    </TABLE><BR>
    <%}
    if("1".equals(session.getAttribute("multitheme"))){
        List themesList = (List)session.getAttribute("themesList");                                    
                                    %>
    <TABLE cellSpacing=0 cellPadding=1 width=150 bgColor=#000000 border=0>
        <TBODY>
            <TR>
                <TD>
                    <TABLE cellSpacing=0 cellPadding=3 width="100%" bgColor=#c0c0c0 
                           border=0>
                        <TBODY>
                            <TR>
                                <TD align=left><FONT class=content 
                                                         color=#363636><B>Themes</B></FONT> 
        </TD></TR></TBODY></TABLE></TD></TR></TBODY>
    </TABLE>

    <TABLE cellSpacing=0 cellPadding=3 width=150 border=0>
        <TBODY>
            <TR >
                <TD   VALIGN="MIDDLE">
                    <DIV align=center>
                        <form  name='themesForm' method='post' action='' onsubmit="this.submit.disabled='true'">
                            <select name="theme" onchange="window.document.forms['themesForm'].submit()">
                                <% 
                                for (int i = 0; i < themesList.size(); ++i)
                                    out.print("<option value=\""+themesList.get(i)+"\"  "+(((String)session.getAttribute("theme")).equals(themesList.get(i))?"selected":"")+">"+themesList.get(i)+"</option>");
                                %>                
                            </select>
                        </form>
                        
        </DIV></TD></TR></TBODY>
    </TABLE><BR>  
    <%}%>
</TD>
<TD><IMG height=1 alt="" src="themes/milo/images/pixel.gif" width=15 
         border=0></TD>
<TD width="100%" HEIGHT="100%">
<TABLE cellSpacing=1 cellPadding=0 width="100%" bgColor=#808080 
       border=0 height="100%" WIDTH="100%"><TBODY>
<TR>
<TD>
<TABLE  cellSpacing=1 cellPadding=8 width="100%" bgColor=#efefef 
        border=0  height="100%" WIDTH="100%">
<TBODY>
<TR>
<TD VALIGN="TOP" WIDTH="100%">