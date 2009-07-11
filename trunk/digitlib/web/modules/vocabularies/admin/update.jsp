<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
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
%>

<%!  
static String vocType = null;//Method used for handling cycles in preference relation: two possible values: automatic or dialogue
static String vocName = null;
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>

<script language="JavaScript1.2" src="modules/resources/admin/jscripts.js"></script>
<% 
VocQueries rQuery = new VocQueries();
String descr = "";
Map<String,String> vocAttr = new HashMap();
vocAttr.put("name",null);
vocAttr.put("language",null);
vocAttr.put("state",null); //if the resource is active or inactive
vocAttr.put("type",null);   //resource type
vocAttr.put("url",request.getParameter("url")); 

if(vocAttr.get("url")!=null)
if(request.getParameter("submit")==null){
    result = conn.execSelectQuery(rQuery.getVoc(vocAttr.get("url")), conn.getModel("vocabularies"));    
    while(result.hasNext()){
        QuerySolution rb = result.nextSolution() ;
        String tab[]=rb.get("p").toString().split("/|#");
        String p = tab[tab.length-1];
        String o = rb.get("o").toString();
        vocAttr.put(p,o);                  
    }
}else{
    vocAttr.put("name",request.getParameter("name"));
    vocAttr.put("language",request.getParameter("language"));
    vocAttr.put("state",(request.getParameter("state")==null)?"0":"1"); //if the resource is active or inactive
    vocAttr.put("type",request.getParameter("type"));   //resource type  
}


%>

    <h1 align="center"><%=(vocAttr.get("url")!=null)?"Modify a vocabulary":"Add a new vocabulary"%></h1>    

<div class="box1">    
    <FORM  name='vocForm'  ACTION='admin.jsp?op=update&cp=vocabularies' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['vocForm'])"> 
        <table>
            <tr><td>Name  </td><td>:
                    <INPUT TYPE="text" NAME='name' value="<%=(vocAttr.get("name")==null)?"":vocAttr.get("name")%>" SIZE="20" maxlength="100">
                    
            </td></tr>  
            
            <tr><td>Type</td><td> :
            <select name="type">
            <%
            for(int i=0;i<conf.getVocabType().size();i++)
            out.print("<option value=\""+i+"\" "+(Integer.toString(i).equals(vocAttr.get("type"))?"selected":"")+" >"+conf.getVocabType().get(Integer.toString(i))+"</option>");
            %>
            </select></td></tr>
 
            <tr><td>Language </td><td>:
            <select size="1" name="language">
              <option value="en_US" <%="en_US".equals(vocAttr.get("language"))?"selected=\"selected\"":""%>>English</option>
              <option value="fr_FR" <%="fr_FR".equals(vocAttr.get("language"))?"selected=\"selected\"":""%>>Fran&ccedil;ais</option>
              <option value="wo_SN" <%="wo_SN".equals(vocAttr.get("language"))?"selected=\"selected\"":""%> >Wolof</option>
            </select>            
                    
            </td></tr> 
   
            <tr><td>Active </td><td>:
                    <input type="checkbox" name="state"   <%="0".equals(vocAttr.get("state"))?"":"checked"%>/>
            </td></tr>             

            <tr><td>Url  </td><td>:
                    <INPUT TYPE="text" NAME='url' value="<%=(vocAttr.get("url")==null)?"":vocAttr.get("url")%>" SIZE="40" maxlength="100">
                    <INPUT TYPE="hidden" NAME='firsturl' value="<%=(vocAttr.get("url")==null)?"":vocAttr.get("url")%>" SIZE="20" maxlength="100">                                        
            </td></tr>  
            
            <tr><td colspan="2">
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>
</DIV>
<%
if((request.getParameter("submit")!=null)&&(!"".equals(vocAttr.get("url")))){
    Vocabulary voc = new Vocabulary(vocAttr,conn);
    String title = "";
    voc.update(request.getParameter("firsturl"));
    String msg = "Your vocabulary named "+request.getParameter("firsturl")+" is updated in the catalogue! ";
    String url = "<a href=\"admin.jsp?op=listing&cp=vocabularies\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%     
}    
%>
</div> 
