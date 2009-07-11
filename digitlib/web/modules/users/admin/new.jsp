<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.user.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>

<% 
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
String login = (String)session.getAttribute("login");
if((!status.equals("admin"))&&(!login.equals(request.getParameter("login")))){//Updating and deleting Service forbiden to simples users
%>
    <jsp:forward page="/modules.jsp?name=errors">
        <jsp:param name="msg" value="You can't access this function..."/>
    </jsp:forward>                
<%
    return;
}

Map<String, String> userAttr = new HashMap();
   
UserQueries query = new UserQueries();

userAttr.put("firstname",request.getParameter("firstname"));
userAttr.put("lastname",request.getParameter("lastname"));
userAttr.put("login",request.getParameter("login"));
userAttr.put("password",request.getParameter("password"));
userAttr.put("adress",request.getParameter("adress"));
userAttr.put("phone",request.getParameter("phone"));    
userAttr.put("email",request.getParameter("email"));     
userAttr.put("status",request.getParameter("status"));
userAttr.put("state",((request.getParameter("state")==null)||"0".equals(request.getParameter("state")))?"0":"1");
userAttr.put("notifmethod",(request.getParameterValues("notifmethod")==null)?"0":query.arrayToString(request.getParameterValues("notifmethod")));
%>

<script language="JavaScript1.2" src="modules/users/admin/jscripts.js"></script>
<h1 align="center">Add a new user</h1>       

<div class="box1">     
    <div class="redText">* field are required.</div>
    <FORM  name='userRegistForm'  ACTION='admin.jsp?op=new&cp=users' METHOD='POST'
           onSubmit="return register_verifUserRegistForm(window.document.forms['userRegistForm'])" > 
        <table>
            <tr><td>Firstname  </td><td>&nbsp;&nbsp;:
                    <INPUT TYPE="text" NAME='firstname' SIZE="30" maxlength="100" VALUE="">
            </td></tr>
            <tr><td>Lastname </td><td>&nbsp;&nbsp;:
                    <INPUT TYPE="text" NAME='lastname' SIZE="20" maxlength="100" VALUE="" >
            </td></tr>
          <%if("admin".equals(status)){%>            
            <tr><td>Login </td><td>&nbsp;&nbsp;:
                    <INPUT TYPE="text" NAME='login' SIZE="15" maxlength="100" VALUE=""> *
            </td></tr>
            <%}else{%>  
            <tr><td>Login </td><td>&nbsp;&nbsp;: <%=login%>
                    <INPUT TYPE="hidden" NAME='login' SIZE="15" maxlength="100" VALUE="<%=login%>"> 
            </td></tr>            
            <%}%>               
            <tr><td>Password </td><td>&nbsp;&nbsp;: <INPUT TYPE="password" NAME='password' SIZE="15" maxlength="100" VALUE=""> *
            </td></tr>  
            <tr><td>Adress </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='adress' SIZE="15" maxlength="100" VALUE="">
            </td></tr>  
            <tr><td>Phone </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='phone' SIZE="15" maxlength="100" VALUE="">
            </td></tr>  
            <tr><td>Email </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='email' SIZE="15" maxlength="100" VALUE="">
            </td></tr>     
            <%if("admin".equals(status)){%>
            <tr><td>Statut </td><td>&nbsp;&nbsp;:&nbsp;<select name="status">
                        <option value="admin" >admin</option>
                        <option value="source" >source</option>
                        <option value="user" >user</option>
                    </select>
            </td></tr>             
            
            <tr><td>Active </td><td>&nbsp;&nbsp;: <input type="checkbox" name="state"  />                                                                                                                                                                      
            </td></tr>  
            <%}else{%>  
            <tr><td> </td><td> <input type="hidden" name="status" value="<%=status%>" />                                                                                                                                                                      
            </td></tr>             
            
            <tr><td> </td><td><input type="hidden" name="state" value="0" />                                                                                                                                                                      
            </td></tr>            
            <%}%>
            <tr><td>Notification method  </td><td>:
                    <INPUT TYPE="checkbox" NAME='notifmethod' value="0" CHECKED>Email&nbsp;
                    <INPUT TYPE="checkbox" NAME='notifmethod' value="1" CHECKED>Rss&nbsp;
            </td></tr> 
            <tr><td></td><td>&nbsp;&nbsp;<INPUT TYPE=RESET  VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>  
</DIV>
<% 
if(request.getParameter("submit")!=null){
    User us = new User(userAttr,conn);
    String msg = "<b>The user is already in the catalog!";
    if(us.addUser())
        msg = "The user is added in the community";
    String title = "";
    String url = "<a href=\"admin.jsp?op=listing&cp=users\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%    
}    
%>
</div> 

