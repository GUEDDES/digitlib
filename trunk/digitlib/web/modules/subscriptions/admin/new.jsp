<%@ page language="java" import="org.digitlib.user.*" import="org.digitlib.db.*"  import="org.digitlib.subscription.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<% 
if(session.getAttribute("ADMIN_FILE")==null){
    out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(status.equals("anonymous")){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");
%>

<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>

<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="modules/subscriptions/admin/jscripts.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script language="JavaScript1.2" type="text/javascript">

function changevocbrowser(){ 
    tab = document.form.vocname.value.toString().split("-");

    var xhr = getXhr(); 
    di = document.getElementById("vocbrowser");
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/vocbrowser/vocbrowserlink.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&voctype="+tab[1]+"&form=form");
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            di.innerHTML = xhr.responseText;
        }
    }    
}   
</script>

<% 
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
VocQueries vQuery = new VocQueries();
UserQueries uQuery = new UserQueries();
ConfigQueries query = new ConfigQueries();
Map<String,String> subsAttr = new HashMap();

if(request.getParameter("submit")!=null){
    subsAttr.put("vocname",(request.getParameter("vocname")).split("-")[0]);
    subsAttr.put("nature",request.getParameter("nature"));
    //subsAttr.put("content",request.getParameter("content"));
    String resNotifAttrib = "";
     try { 
            result = conn.execSelectQuery(query.getConfigParams("resnotifattrib"), query.getModel());
            QuerySolution rb;
            String attr;
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("attr").toString().split("/|#");
                attr = tab[tab.length-1];
                resNotifAttrib += attr+"-";
                subsAttr.put(attr,request.getParameter(attr));
            }
        } catch(Exception e) {
            out.print("Exception : "+e);
        }
    subsAttr.put("resnotifattrib",resNotifAttrib);
    subsAttr.put("submitter",login);
    subsAttr.put("state",(request.getParameter("state")==null)?"0":"1"); //if the resource is active or inactive
    //subsAttr.put("notifmethod",(request.getParameterValues("notifmethod")==null)?"0":vQuery.arrayToString(request.getParameterValues("notifmethod")));   //resource type
    Date d = new Date();
    //subsAttr.put("url", login);
    //query.getSubscrip()+"#"+this.login+"_"+new Date().getTime();
    subsAttr.put("login",login);
    subsAttr.put("url", query.getSubscrip()+"#"+login+"_"+new Date().getTime());

}

%>
    <h1 align="center">Add a new subscription</h1>    

<div class="box1">    
    <FORM  name="form"  ACTION='admin.jsp?op=new&cp=subscriptions' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['form'])"> 
        <table>
            <INPUT TYPE="hidden" NAME='submitter' value="<%=login%>" SIZE="40" maxlength="100">  
            <%if("1".equals((String)session.getAttribute("multivoc"))){
            %>
            <tr><td>Vocabulary </td><td>:
            <select name="vocname" onchange="changevocbrowser();">
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString();
                out.print("<option value=\"" + vn + "-"+vt+"\" " + (vocName.equals(vn) ? "selected" : "") + " >"+vn+"</option>");
            }
            %>
            </select></td></tr>
            <%}else{%>
                    <INPUT TYPE="hidden" NAME='vocname' value="<%=vocName%>" >
            <%}%>

         <%
     try {
            result = conn.execSelectQuery(query.getConfigParams("resnotifattrib"), query.getModel());
            QuerySolution rb;
            String attr;
            String ch = "";
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("attr").toString().split("/|#");
                attr = tab[tab.length-1];
                ch += "<tr><td>"+attr.substring(0, 1).toUpperCase()+attr.substring(1)+"  </td><td>:"+
                    "&nbsp;<INPUT TYPE=\"text\" NAME=\""+attr+"\" SIZE=\"40\" maxlength=\"100\">";
 
                if("content".equals(attr)){
                    ch+="<INPUT TYPE=\"hidden\" NAME=\""+attr+"id\" SIZE=\"40\" maxlength=\"100\">";
                    ch+="<span id=\"vocbrowser\">";
                    if(!"0".equals(vocType)){
                        ch += "&nbsp;"+
                        "<a href=\"#\" onclick=\"browser1('"+vocName+"','"+vocType+"','form');\">"+
                        "<img src=\"images/info.gif\" alt=\"Browse\" title=\"Browse the vocabulary\" border=\"0\" width=\"17\" height=\"17\"></a>";
                    }
                    ch+="</span>";
                }
                ch+="</td></tr>";

            }                out.print(ch);
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }
                          %>

            
            <tr><td>Nature  </td><td>:
                    <INPUT TYPE="radio" NAME='nature' value="0" CHECKED >Modification&nbsp;
                    <INPUT TYPE="radio" NAME='nature' value="1" CHECKED>Insertion&nbsp;
                    <INPUT TYPE="radio" NAME='nature' value="2" CHECKED>Removing&nbsp;
            </td></tr>     
            
            <tr><td>Active </td><td>:
                    <input type="checkbox" name="state" value="1" CHECKED/>
            </td></tr>              
            
            <tr><td colspan="2">             
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>
</div>
<%
if(request.getParameter("submit")!=null){

    Subscription subs = new Subscription(subsAttr,conn,(Locale)session.getAttribute("locale"));
   // subs.setContentTermsIds(query.stringToList(request.getParameter("contentid")));
    String title = "";
    String msg = "The subscription is already in the catalogue!";

    //out.print(subs.addSubscription());
   // if(subs.addSubscription())
            result = conn.execSelectQuery(query.getConfigParams("resnotifattrib"), query.getModel());
            QuerySolution rb;
            String attr;
            String ch = "";
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("attr").toString().split("/|#");
                attr = tab[tab.length-1];
                out.print("<br>"+attr+" "+subs.getResAttrib().get(attr).size());
                
            }
            out.print((new SubsQueries().addSubscription(subs, "")));
        msg = "The subscription is added in the catalog";
    String url = "<a href=\"admin.jsp?op=new&cp=subscriptions\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%     
}    
%>

