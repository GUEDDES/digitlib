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

if(request.getParameter("submit")==null){
    try {
        result = conn.execSelectQuery(query.getUserByLogin(query.getUser()+"#"+request.getParameter("login")), query.getModel());
            QuerySolution rb;
            String notifmethod = "";
            String subscription = "";
            while(result.hasNext()){
                rb = result.nextSolution() ;
                String tab[]=(rb.get("p").toString()).split("/|#");
                String p = tab[tab.length-1];
                String o = rb.get("o").toString();
                if ("notifmethod".equals(p)) {
                    notifmethod += o+" ";
                } else if ("subscription".equals(p)) {
                    subscription += o.split("/|#")[1]+" ";
                }else
                    userAttr.put(p,o);
            }
            userAttr.put("notifmethod",notifmethod);
            userAttr.put("subscription",subscription);
   }catch(Exception e){
%>
<jsp:forward page="modules.jsp?name=errors">
    <jsp:param name="msg" value="<%=\"Exception at edit.jsp :\"+e%>"></jsp:param>
</jsp:forward>                
<%
    }
}else{
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
    userAttr.put("subscription",request.getParameter("subscription"));
}

%>

<script language="JavaScript1.2" src="modules/users/admin/jscripts.js"></script>
<h1 align="center">Updating an user</h1>       

<div class="box1">     
    <div class="redText">* field are required.</div>
    <FORM  name='userRegistForm'  ACTION='admin.jsp?op=update&cp=users' METHOD='POST'
           onSubmit="return register_verifUserRegistForm(window.document.forms['userRegistForm'])" > 
        <table>
            <tr><td>Firstname  </td><td>&nbsp;&nbsp;:
                    <INPUT TYPE="text" NAME='firstname' SIZE="30" maxlength="100" VALUE="<%=(userAttr.get("firstname")==null)?"":userAttr.get("firstname")%>">
            </td></tr>
            <tr><td>Lastname </td><td>&nbsp;&nbsp;:
                    <INPUT TYPE="text" NAME='lastname' SIZE="20" maxlength="100" VALUE="<%=(userAttr.get("lastname")==null)?"":userAttr.get("lastname")%>" >
                    <INPUT TYPE="hidden" NAME='firstLogin'  VALUE="<%=(userAttr.get("login")==null)?"":userAttr.get("login")%>"> 
            </td></tr>
          <%if("admin".equals(status)){%>            
            <tr><td>Login </td><td>&nbsp;&nbsp;:                                
                    <INPUT TYPE="text" NAME='login' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("login")==null)?"":userAttr.get("login")%>"> *
            </td></tr>
            <%}else{%>  
            <tr><td>Login </td><td>&nbsp;&nbsp;: <%=userAttr.get("login")%>
                    <INPUT TYPE="hidden" NAME='login' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("login")==null)?"":userAttr.get("login")%>"> 
            </td></tr>            
            <%}%>               
            <tr><td>Password </td><td>&nbsp;&nbsp;: <INPUT TYPE="password" NAME='password' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("password")==null)?"":userAttr.get("password")%>"> *
            </td></tr>  
            <tr><td>Adress </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='adress' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("adress")==null)?"":userAttr.get("adress")%>">
            </td></tr>  
            <tr><td>Phone </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='phone' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("phone")==null)?"":userAttr.get("phone")%>">
            </td></tr>  
            <tr><td>Email </td><td>&nbsp;&nbsp;: <INPUT TYPE="text" NAME='email' SIZE="15" maxlength="100" VALUE="<%=(userAttr.get("email")==null)?"":userAttr.get("email")%>">
            </td></tr>     
            <%if("admin".equals(status)){%>
            <tr><td>Statut </td><td>&nbsp;&nbsp;:&nbsp;<select name="status">
                        <option value="admin" <%="admin".equals(userAttr.get("status"))?"selected":""%>>admin</option>
                        <option value="source" <%="source".equals(userAttr.get("status"))?"selected":""%>>source</option>
                        <option value="user" <%="user".equals(userAttr.get("status"))?"selected":""%>>user</option>
                    </select>
            </td></tr>             
            
            <tr><td>Active </td><td>&nbsp;&nbsp;: <input type="checkbox" name="state" <%="0".equals(userAttr.get("state"))?"":"checked"%> />                                                                                                                                                                      
            </td></tr>  
            <%}else{%>  
            <tr><td> </td><td> <input type="hidden" name="status" value="<%=userAttr.get("status")%>" />                                                                                                                                                                      
            </td></tr>             
            
            <tr><td> </td><td><input type="hidden" name="state" value="<%="0".equals(userAttr.get("state"))?"0":"1"%>" />                                                                                                                                                                      
            </td></tr>            
            <%}%>
            <tr><td>Notification method  </td><td>:
                    <INPUT TYPE="checkbox" NAME='notifmethod' value="0" <%=(userAttr.get("notifmethod").indexOf("0")!=-1)?"checked":""%>><%=conf.getNotifArray().get("0")%>&nbsp;
                    <INPUT TYPE="checkbox" NAME='notifmethod' value="1" <%=(userAttr.get("notifmethod").indexOf("1")!=-1)?"checked":""%>><%=conf.getNotifArray().get("1")%>&nbsp;
            </td></tr>
            <tr><td> </td><td><input type="hidden" name="subscription" value="<%=userAttr.get("subscription")%>" />
            </td></tr>
            <tr><td></td><td>&nbsp;&nbsp;<INPUT TYPE=RESET  VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>  
</DIV>
<% 
if(request.getParameter("submit")!=null){
    User us = new User(userAttr,conn);
    us.update(request.getParameter("firstLogin"));
    String title = "";
    String msg = "The user is  added in the community";
    String url = "<a href=\"admin.jsp?op=listing&cp=users\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%    
}    
%>
</div> 

