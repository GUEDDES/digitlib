
<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import=" org.w3c.rdfvalidator.*" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
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
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
%>

<%!  
static RdfDBAccess conn = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>

<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="modules/resources/admin/jscripts.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script language="JavaScript1.2" type="text/javascript">  

function init() {   
    addVocTerms('<%=vocName+"-"+vocType%>','add_parent','parentname','Parent\'s name :','');
    addtermlist('<%=vocName+"-"+vocType%>','deltermlist','del_termForm');        
    update_addtermlist('<%=vocName+"-"+vocType%>','updateVocTerms','update_termForm');        
}    

window.onload = init; 

function addVocTerms(term, id, selectname, msg, selectedTerm){ 
    tab = term.split("-");
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&op=addVocTerms&selectname="+selectname+"&msg="+msg+"&selectedTerm="+selectedTerm);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(id);
            if(tab[1]!="2"){
                di.innerHTML = "";                
            }else {         
                di.innerHTML = xhr.responseText;
            }
            changevocbrowser(tab[0], tab[1], "newvocbrowser"); 
        }
    }    
} 

function addparent(term){ 
    //di = document.getElementById("updateparent");    
    tab = document.updatetermform.vocname.value.split("-");    
    if(tab[1]!="2"){
        document.getElementById("updateparent").innerHTML = "";
        return;
    }
    if(term==""){
        document.getElementById("parenttitle").innerHTML = ""; 
        document.getElementById("updateparent").innerHTML = "";      
        document.getElementById("newparent").innerHTML = ""; 
        return;
    }
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("name="+term+"&vocname="+tab[0]+"&op=addParent");
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            var xmlDoc=xhr.responseXML.documentElement;
            rep = ""
            if(xmlDoc.getElementsByTagName("parent")[0].hasChildNodes())
                rep = xmlDoc.getElementsByTagName("parent")[0].childNodes[0].nodeValue;

            document.getElementById("parenttitle").innerHTML = "Its parent  ";
            ch = "<input type = \"hidden\" name=\"parentname\" value=\""+rep+"\">";
            if(rep=="")
                document.getElementById("updateparent").innerHTML = ch+": It's a root ";
            else
                document.getElementById("updateparent").innerHTML = ch+": "+rep;
            
            document.updatetermform.newname.value = term;
            
            addVocTerms(document.updatetermform.vocname.value, "newparent", "newparentname", "by",rep);
            //document.getElementById("newparent").innerHTML = xmlDoc.getElementsByTagName("parentform")[0].childNodes[0].nodeValue;
        }
    }    
}  


function addtermlist(voc,divname,op){ 
    tab = voc.split("-");    
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&op="+op);//termForm
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(divname);            
            di.innerHTML = xhr.responseText;
            changevocbrowser(tab[0], tab[1], "deletevocbrowser");
        }
    }    
} 

function changevocbrowser(voc, type, id){ 
    var xhr = getXhr(); 
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/vocbrowser/vocbrowserlink.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+voc+"&voctype="+type);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(id);
            di.innerHTML = xhr.responseText;
        }
    }    
} 

function update_addtermlist(voc,divname,op){ 
    tab = voc.split("-");    
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&op="+op);//termForm
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(divname);            
            di.innerHTML = xhr.responseText;
            
            if(tab[1]!="2"){
                document.getElementById("parenttitle").innerHTML = ""; 
                document.getElementById("updateparent").innerHTML = "";      
                document.getElementById("newparent").innerHTML = "";                
            }  
            changevocbrowser(tab[0], tab[1], "updatevocbrowser");            
        }
    }    
} 


function addTerm(){ 
    tab = document.termForm.vocname.value.toString().split("-");
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur  
    if(tab[1]=="2")
        parentname = document.termForm.parentname.value.toString();
    else
        parentname = "";
    name = document.termForm.name.value.toString();         
    //name = document.getElementById("name");    
    xhr.send("op=addTerm&vocname="+tab[0]+"&parentname="+parentname+"&name="+name);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            di = document.getElementById("addtermresult");
            di.innerHTML = xhr.responseText;
        }
    }  
    return false;
} 

function importData(url){
    tab = document.importForm.vocname.value.toString().split("-");
    var xhr = getXhr();

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur

    xhr.send("op=importData&vocname="+tab[0]+"&url="+url+"&voctype="+tab[1]);

    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById("importfile");
            di.innerHTML = xhr.responseText;
        }
    }
    return false;
}


function importFile(){
    //tab = document.termForm.vocname.value.toString().split("-");
    var xhr = getXhr();

    // Ici on va voir comment faire du post
    xhr.open("POST","ARPServlet",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    URI = document.importForm.URI.value;
    //alert(URI);return;
    xhr.send("URI="+URI+"&TRIPLES_AND_GRAPH=PRINT_TRIPLES&FORMAT=PNG_EMBED");
//alert("ddd");
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById("importfile");
           /* if((xhr.responseText.toString())=="success")
               importData(URI);
           else*/
               di.innerHTML =  xhr.responseText;
        }
    }
    return false;
}




function dellTerm(){ 
    tab = document.deltermform.vocname.value.toString().split("-");
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur  
    name = document.deltermform.name.value.toString();      
    //name = document.getElementById("name");    

    xhr.send("op=dellTerm&vocname="+tab[0]+"&voctype="+tab[1]+"&name="+name);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            di = document.getElementById("deltermresult");
            di.innerHTML = xhr.responseText;
        }
    }  
    return false;
} 

function updateTerm(form){ 
    tab = form.vocname.value.toString().split("-");
    name = form.name.value;
    newName = form.newname.value;    
    parentName = "";
    newParentName = "";
    if(typeof(form.parentname)!='undefined')
        parentName = form.parentname.value;
    if(typeof(form.newparentname)!='undefined')
        newParentName = form.newparentname.value;
    
    var xhr = getXhr(); 

    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/admin/functions.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur  


    xhr.send("op=updateTerm&vocname="+tab[0]+"&voctype="+tab[1]+"&name="+name+"&newname="+newName+"&parentname="+parentName+"&newparentname="+newParentName);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            document.getElementById("updatetermresult").innerHTML = xhr.responseText;
        }
    }  
    return false;
} 


    </script>
<% 
VocQueries vQuery = new VocQueries();
Map<String,String> vocAttr = new HashMap();
vocAttr.put("name",null);
vocAttr.put("language",null);
vocAttr.put("state",null); //if the resource is state or inactive
vocAttr.put("type",null);   //resource type
vocAttr.put("url",request.getParameter("url"));



if(vocAttr.get("url")!=null)
if(request.getParameter("submit")==null){
    result = conn.execSelectQuery(vQuery.getVoc(vocAttr.get("url")), vQuery.getModel());    
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
    vocAttr.put("state",((request.getParameter("state")==null)||"0".equals(request.getParameter("state")))?"0":"1"); //if the resource is active or inactive
    vocAttr.put("type",request.getParameter("type"));   //resource type  
}


%>

<div class="box1">    
<h1 align="center">Add a new vocabulary</h1> 
    <FORM  name='vocForm'  ACTION='admin.jsp?op=new&cp=vocabularies' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['vocForm'])"> 
        <table border="0" cellspacing="6">
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
                    <input type="checkbox" name="state" value="<%="1".equals(vocAttr.get("state"))?"1":"0"%>"  <%="0".equals(vocAttr.get("state"))?"":"checked"%>/>
            </td></tr>             

            <tr><td>Url  </td><td>:
                    <INPUT TYPE="text" NAME='url' value="<%=(vocAttr.get("url")==null)?"":vocAttr.get("url")%>" SIZE="40" maxlength="100">
            </td></tr>  
            
            <tr><td colspan="2">
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>

<%
if((request.getParameter("submit")!=null)&&(!"".equals(vocAttr.get("url")))){
    Vocabulary voc = new Vocabulary(vocAttr,conn);
    String title = "";
    String msg = "<b>Registration is impossible</b><br /><br />A vocabulary with the same name or adress exist.";
    if(voc.add())
        msg = "Your vocabulary named "+vocAttr.get("name")+"is added in the catalogue! ";
    String url = "<a href=\"admin.jsp?op=new&cp=vocabularies\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%     
}    
%>
</div>

<div class="box1">    
<h1 align="center">Import terms from file</h1> 
    <FORM  name='importForm'  ACTION='' METHOD='POST'
           onSubmit="return importFile();">
        <table border="0">
            <tr><td>Rdf(s) File&nbsp;  </td><td>:&nbsp;&nbsp;
            <select name="URI">
            <%
        String dir = conf.getAppWebDir()+"includes/data";
        String [] array = new File(dir).list();
        List themesList = new ArrayList();
        for (int i = 0; i < array.length; ++i){
            String ch = dir+File.separator+array[i];
            if(new File(ch).isFile()&& (ch.endsWith("rdf")||ch.endsWith("rdfs")))
                out.print("<option value=\"http://localhost:8084/digitlib/includes/data/"+array[i]+"\" >"+array[i]+"</option>");
        }
            %>
            </select>
            </td>
            </tr>
            <tr>
            <td>Vocabulary's name &nbsp;</td><td>:&nbsp;&nbsp;
            <select name="vocname" onchange="addVocTerms(this.value,'add_parent','parentname','&nbsp;Parent\'s name :','');">            
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString(); 
                out.print("<option value=\"" + vn + "-"+vt+"\""+(vn.equals(vocName)?"selected":"")+"  >"+vn+"</option>");                                                   
            }        
            %>
            </select>
            <span id="newvocbrowser">                 
                </span>            

            <INPUT TYPE=SUBMIT NAME='importTerms' VALUE='Import'>
                </td></tr>
        </table>
    </FORM>
    <div id="importfile" align="center" ></div>
</div>

<div class="box1">    
<h1 align="center">Add a new term</h1> 
    <FORM  name='termForm'  ACTION='' METHOD='POST'  
           onSubmit="return addTerm();"> 
        <table border="0">
            <tr><td>Term's name&nbsp;  </td><td>:&nbsp;&nbsp;
                    <INPUT TYPE="text" NAME='name'  SIZE="20" maxlength="100">
            </td>
            <td id="add_parent">&nbsp;</td>
            </tr>
            <tr>
            <td>Vocabulary's name &nbsp;</td><td colspan="2">:&nbsp;&nbsp;
            <select name="vocname" onchange="addVocTerms(this.value,'add_parent','parentname','&nbsp;Parent\'s name :','');">            
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString(); 
                out.print("<option value=\"" + vn + "-"+vt+"\""+(vn.equals(vocName)?"selected":"")+"  >"+vn+"</option>");                                                   
            }        
            %>
            </select>
            <span id="newvocbrowser">                 
                </span>            

            <INPUT TYPE=SUBMIT NAME='submitTerm' VALUE='Add'>
                </td></tr>
        </table>
    </FORM>
    <div id="addtermresult" align="center" ></div>
</div> 

<div class="box1">    
<h1 align="center">Term deletion</h1>
    <FORM  name='deltermform'  ACTION='' METHOD='POST'  
           onSubmit="return dellTerm();"> 
        <table border="0">
            <tr><td>Term's name&nbsp;  :</td><td id="deltermlist">
            </td>


            <td>&nbsp;&nbsp;Vocabulary's name :&nbsp;</td><td colspan="2">
            <select name="vocname" onchange="addtermlist(this.value,'deltermlist','del_termForm');">            
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString(); 
                out.print("<option value=\"" + vn + "-"+vt+"\" "+(vn.equals(vocName)?"selected":"")+" >"+vn+"</option>");                                                   
            }        
            %>
            </select>  
            <span id="deletevocbrowser">                    
                </span>   &nbsp;
            <INPUT TYPE=SUBMIT NAME='submitTerm' VALUE='Delete'>
                </td></tr>
        </table>
    </FORM>
    <div id="deltermresult" align="center" ></div>
</div> 


<div class="box1">    
<h1 align="center">Term updating</h1>
    <FORM  name='updatetermform'  ACTION='' METHOD='POST'  
           onSubmit="return updateTerm(this);"> 
           &nbsp;<b>Replace :</b>
        <table border="0">
            <tr>
                <td>The term &nbsp;  </td>
                <td id="updateVocTerms"></td>
                <td>&nbsp;&nbsp;by&nbsp;&nbsp;<input type="text" name="newname" size="10"></td>
            </tr>
            <tr>
                <td id="parenttitle"></td>                   
                <td id="updateparent"></td>  
                <td id="newparent"></td>                  
            </tr>
            <tr>
                <td>Its vocabulary &nbsp;</td>
                <td>:
            <select name="vocname" onchange="update_addtermlist(this.value,'updateVocTerms','update_termForm');">            
            <%
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
            while(result.hasNext()){
                QuerySolution rb = result.nextSolution() ;
                String vt = rb.get("vt").toString();
                String vn = rb.get("vn").toString(); 
                out.print("<option value=\"" + vn + "-"+vt+"\" "+(vn.equals(vocName)?"selected":"")+" >"+vn+"</option>");                                                   
            }        
            %>
            </select>
            <span id="updatevocbrowser">  
            &nbsp;
                <a href="#" onclick="browser(document.updatetermform,'');">
                    <img src="images/info.gif" alt="Browse" title="Browse" border="0" width="17" height="17">
                </a> &nbsp;                    
                </span>             
            </td>
           <td  align="right">
            <INPUT TYPE=SUBMIT NAME='submitTerm' VALUE='Update'>
                </td></tr>
        </table>
    </FORM>
    <div id="updatetermresult" align="center" ></div>
</div> 
