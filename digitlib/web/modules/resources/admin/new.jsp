<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*"  import="com.hp.hpl.jena.rdf.model.Model" import="com.hp.hpl.jena.rdf.model.StmtIterator.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" %>
<%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
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
if((!status.equals("admin"))&&(!status.equals("source"))){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
%>

<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="modules/resources/admin/jscripts.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script language="JavaScript1.2" type="text/javascript">  


function changevocbrowser(){ 
    tab = document.registForm.vocname.value.toString().split("-");

    var xhr = getXhr(); 
    di = document.getElementById("vocbrowser");
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/vocbrowser/vocbrowserlink.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&voctype="+tab[1]+"&form=registForm");
    
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
ConfigQueries sQuery = new ConfigQueries();
ResQueries rQuery = new ResQueries();
ResultSet result;
//out.print(vocType+" "+vocName);
Map<String,String> resAttr = new HashMap();
resAttr.put("url",(request.getParameter("url")==null)?"":request.getParameter("url")); 
resAttr.put("content",request.getParameter("content"));
resAttr.put("submitter",request.getParameter("submitter"));
resAttr.put("language",request.getParameter("language"));
resAttr.put("author",request.getParameter("author"));
resAttr.put("format",request.getParameter("format"));
resAttr.put("state",(request.getParameter("state")==null)?"0":"1"); //if the resource is active or inactive
resAttr.put("type",request.getParameter("type"));   //resource type

if(request.getParameter("vocname")==null){
    resAttr.put("vocname",vocName);
    resAttr.put("voctype",vocType);            
}else{
    if("1".equals((String)session.getAttribute("multivoc"))||("admin".equals(status))){
        resAttr.put("vocname",request.getParameter("vocname").split("-")[0]);    
        resAttr.put("voctype",request.getParameter("vocname").split("-")[1]);
    }else{
        resAttr.put("vocname",vocName);
        resAttr.put("voctype",vocType); 
    }
}
%>
<br>
    <h1 align="center">Add a new resource</h1>    
<div class="box1">

    <div>
        Vocabulary type : <%
        if("0".equals(vocType))
            out.print("None controlled vocabulary");
        else
            if("1".equals(vocType))
                out.print("controlled vocabulary without taxonomy");
            else
                out.print("controlled vocabulary within taxonomy");
        %><br />
        Vocabulary name : <%=vocName%>   
    </div>
</div>
    <div class="box1" style="height:300px">
            <div id="vocbrowserbloc"></div>
    <FORM  name='registForm'  ACTION='admin.jsp?op=new&cp=resources' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['registForm'])"> 
        <table>
            <tr><td>Url  </td><td>:
                    <INPUT TYPE="text" NAME='url' value="" SIZE="40" maxlength="100">
            </td></tr>             
            <INPUT TYPE="hidden" NAME='submitter' value="<%=login%>">
            
            <%if("0".equals((String)session.getAttribute("restype"))||("admin".equals(status))){%>
            <tr><td>Type</td><td> :
            <select name="type">
            <%
            for(int i=0;i<conf.getResType().size();i++)
            out.print("<option value=\""+i+"\" " + (session.getAttribute("restype").equals(Integer.toString(i)) ? "selected" : "") + " >"+conf.getResType().get(Integer.toString(i))+"</option>");
            %>
            </select></td></tr>
            <%}else{%>
                    <INPUT TYPE="hidden" NAME='type' value="<%=(String)session.getAttribute("restype")%>" >
            <%}%>
            <tr><td>Format </td><td>:
                    <INPUT TYPE="text" NAME='format' value="" SIZE="15" maxlength="100">
            </td></tr>   
            <tr><td>Language </td><td>:
                    <INPUT TYPE="text" NAME='language' value="" SIZE="15" maxlength="100">
            </td></tr>
           
            <tr><td>Author </td><td>:
                    <INPUT TYPE="text" NAME='author' value=""  SIZE="15" maxlength="100">
            </td></tr>  
            <%if("1".equals((String)session.getAttribute("multivoc"))||("admin".equals(status))){
            VocQueries vQuery = new VocQueries();
            %>            
            <tr><td>Vocabulary </td><td>:
            <select name="vocname" onchange="changevocbrowser();">            
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString(); 
                out.print("<option value=\"" + vn + "-"+vt+"\" " + (resAttr.get("vocname").equals(vn) ? "selected" : "") + " >"+vn+"</option>");                                                   
            }        
            %>
            </select></td></tr>
            <%}else{%>
                    <INPUT TYPE="hidden" NAME='vocname' value="<%=vocName%>" >
            <%}%>
            <tr><td>Content </td><td>:
                    <INPUT TYPE="text" NAME="content" value="" SIZE="40" maxlength="100" >
                    <span id="vocbrowser">
            <a href="#" onclick="insertVocBrowser('<%="1".equals(vocType) ? "" : vocName + "-" + vocName%>','<%=vocName%>','<%=vocType%>','registForm','1', 'content', 'vocbrowserbloc');">
                <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17" align="middle">
            </a>
               <!-- <a href="#" onclick="browser(document.registForm,'1','1');">
                    <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17">
                </a>-->

                    </span>
           </td></tr>
   
            <tr><td>State </td><td>:
                    <input type="checkbox" name="state" value="0"  />
            </td></tr>             

            <tr><td colspan="2">
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>
</DIV>
<%

if((request.getParameter("submit")!=null)&&(!"".equals(resAttr.get("url")))){
    Resource res = new Resource(resAttr,conn,conf.getAppWebDir());
    String title = "";
    String msg = "<b>Registration is impossible</b><br /><br />This document is already registed!";
    //out.print(res.getContent());
    if(res.addResource())
        msg = "<b>Registration</b><br /><br />Your document <br />"+resAttr.get("url")+"<br />is added in the catalogue! ";
                
    String url = "<a href=\"admin.jsp?cp=resources&op=new\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%     
}    
%>
</div> 
