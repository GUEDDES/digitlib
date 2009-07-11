<%@ page language="java" import="java.net.*" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" import="org.digitlib.subscription.*" import="org.digitlib.user.*" %>
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
            di = document.getElementById("vocbrowser");
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
ConfigQueries cquery = new ConfigQueries();
Subscription subs;

if(request.getParameter("submit")==null){
    subs = new Subscription(request.getParameter("url"),conn,(Locale)session.getAttribute("locale"));
    subs.setLogin(login);
}else{
    Map<String,String> subsAttr = new HashMap();
    subsAttr.put("url",request.getParameter("url"));
    subsAttr.put("vocname",request.getParameter("vocname").split("-")[0]);
    subsAttr.put("nature",request.getParameter("nature"));
    String resNotifAttrib = "";
    try {
        ResultSet result = conn.execSelectQuery(cquery.getConfigParams("resnotifattrib"), cquery.getModel());
        QuerySolution rb;
        String attr;
        while (result.hasNext()) {
            rb = result.nextSolution();
            attr = rb.get("attr").toString();          
            subsAttr.put(attr,request.getParameter(attr));
            resNotifAttrib += attr+"-";
        }
    } catch (Exception e) {
        System.out.print("Exception : " + e);
    }
    subsAttr.put("resnotifattrib",resNotifAttrib);
    subsAttr.put("login",login);
    subsAttr.put("submitter",request.getParameter("submitter"));    
    subsAttr.put("state",((request.getParameter("state")==null)||"0".equals(request.getParameter("state")))?"0":"1"); //if the resource is active or inactive
    //subsAttr.put("notifmethod",(request.getParameterValues("notifmethod")==null)?"0":vQuery.arrayToString(request.getParameterValues("notifmethod")));   //resource type

    subs = new Subscription(subsAttr,conn,(Locale)session.getAttribute("locale"));

}
%>

    <h1 align="center">Update a subscription</h1>    

<div class="box1">    
    <FORM  name='form'  ACTION='admin.jsp?op=update&cp=subscriptions' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['vocForm'])"> 
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
                out.print("<br><option value=\""+vn+ "-"+vt+"\" "+ (vn.equals(subs.getVoc().getName()) ? "selected" : "") +" >"+vn+"</option>");
            }
            %>
            </select></td></tr>
            <%}else{%>
                    <INPUT TYPE="hidden" NAME='vocname' value="<%=vocName%>" >
            <%}%>
        <%
        String ch = "";
        for (Iterator it = subs.getResAttrib().keySet().iterator(); it.hasNext();) {
            String key = it.next().toString();

            ch += "<tr><td>"+key.substring(0, 1).toUpperCase()+key.substring(1)+"  </td><td>:"+
                "&nbsp;<INPUT TYPE=\"text\" NAME=\""+key+"\" VALUE=\""+subs.descrToString(key)+"\" SIZE=\"40\" maxlength=\"100\">";

            if("content".equals(key)){
                ch+="<span id=\"vocbrowser\">";
                if(!"0".equals(vocType)){
                    ch += "&nbsp;"+
                    "<a href=\"#\" onclick=\"browser1('"+vocName+"','"+vocType+"','form');\">"+
                    "<img src=\"images/info.gif\" alt=\"Browse\" title=\"Browse the vocabulary\" border=\"0\" width=\"17\" height=\"17\"></a>";
                }
                ch+="</span>";
            }
            ch+="</td></tr>";

        }
        out.print(ch);
                          %>
             
            
            <tr><td>Nature  </td><td>:
                    <INPUT TYPE="checkbox" NAME='nature' value="0" <%=(subs.getNature().contains("0"))?"checked":""%>><%=conf.getNatArray().get("0")%>&nbsp;
                    <INPUT TYPE="checkbox" NAME='nature' value="1" <%=(subs.getNature().contains("1"))?"checked":""%>><%=conf.getNatArray().get("1")%>&nbsp;
                    <INPUT TYPE="checkbox" NAME='nature' value="2" <%=(subs.getNature().contains("2"))?"checked":""%>><%=conf.getNatArray().get("2")%>&nbsp;
            </td></tr>     
                        
            <tr><td>Active </td><td>:
                    <input type="checkbox" name="state"   <%="0".equals(subs.getState())?"":"checked"%>/>
            </td></tr>            
            
            <tr><td colspan="2">
                    <INPUT TYPE=hidden  NAME="url" VALUE='<%=(subs.getUrl()==null)?"":subs.getUrl()%>'>
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>
</div>
<%
if((request.getParameter("submit")!=null)&&(!"".equals(subs.getUrl()))){
    String title = "";
    String msg = "The subscription is updated !";
    subs.updateSubscription();
    String url = "<a href=\"admin.jsp?op=listing&cp=subscriptions\">Back</a>";
    //out.print(subs.test());
%>
<%@ include file="/includes/message.jsp" %>
<%     
}    
%>
 
