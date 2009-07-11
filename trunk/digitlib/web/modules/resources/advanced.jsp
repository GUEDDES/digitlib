<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%!
///resourc es search services variables
    LBA persQuery = new LBA();//
    static int nB = 0;
    static List<List<String>> QB = new ArrayList();
    static String queryQ = "";
    static List<AttribQuery> prefQuery = new ArrayList();
//name and type of the vocabulary used by the community
    String bCMethod = null;//Method used for handling cycles in preference relation: two possible values: automatic or dialogue
    String vocType = null;
    String vocName = null;
//Rdf data base variables
    QuerySolution rb;
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        try{
        conn.DBConnect();
        }catch(Exception e){
            System.out.println(e.getMessage());
            e.printStackTrace();
            System.exit(-1);
        }
    }
    
%>

<%
    vocType = (String) session.getAttribute("voctype");
    vocName = (String) session.getAttribute("vocname");
    bCMethod = (String) session.getAttribute("bcmethod");
    
    if(session.getAttribute("MODULE_FILE")==null){
        out.print("You can't access this file directly...");
        return;
    }     
%>

<%@ include file="/header.jsp" %>
<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script type="text/javascript">     

// Node cleaner
function go(c){
    if(!c.data.replace(/\s/g,''))
        c.parentNode.removeChild(c);
}

function clean(d){
    var bal=d.getElementsByTagName('*');
    
    for(i=0;i<bal.length;i++){
        a=bal[i].previousSibling;
        if(a && a.nodeType==3)
            go(a);
        b=bal[i].nextSibling;
        if(b && b.nodeType==3)
            go(b);
    }
    return d;
} 


function isInTab(elt,tab){
    var j=0;
    while((j<tab.length)&&(elt!=tab[j])){
        j++;
    }
    if(j==tab.length){
        return -1;
    }else   
    return j;
}


function init() {
    //insertVocBrowser('<%="1".equals(vocType) ? "" : vocName + "-" + vocName%>','<%=vocName%>','<%=vocType%>','formSearch','1', 'contentTerms', 'vocbrowserbloc');
    defaultAttrib = "content";
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addAttrib.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send("attrib="+defaultAttrib);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById('queries');
            di.innerHTML = xhr.responseText;
            addAttrTermPref(defaultAttrib);
        }
    }
}    

window.onload = init;   
/**
* This method is used to add a attribue query
*/
function addAttrib(){
    
    attribute = document.getElementById('attribute').value;  
    di = document.getElementById('queries');        
    
    if(di.contains(document.getElementById(attribute+'Query')))            
        return;
    
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addAttrib.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send("attrib="+attribute);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById('queries');
            di.insertAdjacentHTML("BeforeEnd",xhr.responseText); 
            addAttrTermPref(attribute);
            addFramePrefba();
        }
    }    
} 

function remAttrib(){
    attribute = document.getElementById('attribute').value;  
    di = document.getElementById('queries');        
    pba = document.getElementById('prefbattrib'); 
    //i = isInTab(attribute,attribList);
    if(di.contains(document.getElementById(attribute+'Query'))){
        di.removeChild(document.getElementById(attribute+'Query'));
        querieslg = di.childNodes.length; 
        if((querieslg<=1)&&(pba.hasChildNodes()))
            pba.removeChild(pba.firstChild);                 
    }
} 
//
function addAttrTermPref(attrib){
    
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addFramePref.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send("attrib="+attrib);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(attrib+"Query");
            di.insertAdjacentHTML("BeforeEnd",xhr.responseText);            
            //addFramePrefba();
        }
    }    
} 

function changest(){
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/changest.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send(null);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById('chgst');
            di.innerHTML = xhr.responseText;  
            
            ri = document.getElementById('result');
            ri.innerHTML = "";            
            //Delete the result div
             
            //init();
            qi = document.getElementById('queries'); 
            //alert(qi.childNodes.length);
            if(qi.hasChildNodes())
                if(qi.firstChild.childNodes.length==2){
                    for(i=0;i<qi.childNodes.length;i++){
                        qic = qi.childNodes[i];
                        qic.removeChild(qic.lastChild);
                    }
                    pba = document.getElementById('prefbattrib'); 
                    if(pba.hasChildNodes())
                        pba.removeChild(pba.firstChild);  
                }else{
                for(i=0;i<qi.childNodes.length;i++){
                    qic = qi.childNodes[i];   
                    ch = qic.getAttribute("id");
                    addAttrTermPref(ch.substr(0,ch.length-5));//alert(qic.getAttribute("id"));
                }
                addFramePrefba();
            }
        }
    }    
} 

/**
* Méthode qui sera appelée sur le click du bouton
*/
function addPref(attrib){ 
    di = document.getElementById(attrib+"PrefList");
    
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addPref.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send("attrib="+attrib+"&lg="+di.childNodes.length);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){            
            di.insertAdjacentHTML("BeforeEnd",xhr.responseText);
            //alert(xhr.responseText);
        }
    }    
} 

function removePref(attrib){ 
    di = document.getElementById(attrib+"PrefList");
    lg = di.childNodes.length;
    if(di.hasChildNodes())
        di.removeChild(di.lastChild);
} 

function addPrefba(){ 
    var xhr = getXhr(); 
    di = document.getElementById("prefbaList");
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addPrefba.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("lg="+di.childNodes.length);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){   
            di.insertAdjacentHTML("BeforeEnd",xhr.responseText);
        }
    }    
} 

function removePrefba(){ 
    di = document.getElementById("prefbaList");
    lg = di.childNodes.length;
    if(di.hasChildNodes())
        di.removeChild(di.lastChild);
} 

function addFramePrefba(){ 
    di = document.getElementById("queries");    
    if(di.childNodes.length<2)
        return;
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/addFramePrefba.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send(null);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){ 
            di = document.getElementById("prefbattrib");
            di.innerHTML = xhr.responseText;
            //alert(xhr.responseText);
        }
    }    
} 

function submitForm(){ 
    var xhr = getXhr();

    di = document.getElementById("queries");
    if(di.childNodes.length==0)
        return false;


    if(di.childNodes[0].childNodes.length==1)
        execQuery();
    else
        execPrefQuery();
    
    return false;
} 

//execQuery : function to exec query without preference
function execQuery(){ 
    di = document.getElementById("queries");
    maxResult = document.getElementById("maxResult").value;    
    attrCh = "";
    attrQ = "";
    //alert(di.childNodes.length);

    qic = di.childNodes[0];   
    cht = qic.getAttribute("id");
    attrName = cht.substr(0,cht.length-5);
    attrCh = attrName;      
    attrQ = "&"+attrName+"Terms="+document.getElementById(attrName).value;   
    for(i=1;i<di.childNodes.length;i++){
        qic = di.childNodes[i];   
        cht = qic.getAttribute("id");
        attrName = cht.substr(0,cht.length-5);
        attrCh += " "+ attrName;      
        attrQ += "&"+attrName+"Terms="+document.getElementById(attrName).value;        
    }
    //alert("attrCh="+attrCh+"&maxResult="+maxResult+attrQ);
    //return false;
    
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/execQuery.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    //alert("attrCh="+attrCh+"&maxResult="+maxResult+attrQ);
    //return;
    xhr.send("attrCh="+attrCh+"&maxResult="+maxResult+attrQ);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){ 
            di = document.getElementById("result");
            di.innerHTML = xhr.responseText;
            //alert(xhr.responseText);
        }
    }    
} 

//execPrefQuery : function to exec preference query
function execPrefQuery(){ 
    di = document.getElementById("queries");
    maxResult = document.getElementById("maxResult").value;    

    qic = di.childNodes[0];   
    cht = qic.getAttribute("id");
    attrName = cht.substr(0,cht.length-5);
    attrCh = attrName;          
    attrQ = "&"+attrName+"Terms="+document.getElementById(attrName).value; 
    size = document.getElementById(attrName+"PrefList").childNodes.length;
    prefSize = "&"+attrName+"PrefSize="+size;     
    prefList = "";

    for(k=0;k<size;k++){
        prefList += "&"+attrName+k+"a="+document.getElementById(attrName+k+"a").value;
        prefList += "&"+attrName+k+"b="+document.getElementById(attrName+k+"b").value;
    }

    for(i=1;i<di.childNodes.length;i++){
        qic = di.childNodes[i];   
        cht = qic.getAttribute("id");
        attrName = cht.substr(0,cht.length-5);
        attrCh += " "+ attrName;      
        attrQ += "&"+attrName+"Terms="+document.getElementById(attrName).value;  
        size = document.getElementById(attrName+"PrefList").childNodes.length;        
        prefSize += "&"+attrName+"PrefSize="+size;             
        for(k=0;k<size;k++){
            prefList += "&"+attrName+k+"a="+document.getElementById(attrName+k+"a").value;
            prefList += "&"+attrName+k+"b="+document.getElementById(attrName+k+"b").value;
        }
        
    }        
    //alert("attrCh="+attrCh+"&maxResult="+maxResult+attrQ+prefSize+prefList);return;
       //alert(prefSize);
    //alert(attrQ);
    //return false;
    
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/execPrefQuery.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    var reg=new RegExp("[+]", "g");
    //alert("attrCh="+attrCh+"&maxResult="+maxResult+attrQ+prefSize+prefList.replace(reg,"%2B"));
    //return;
    xhr.send("attrCh="+attrCh+"&maxResult="+maxResult+attrQ+prefSize+prefList.replace(reg,"%2B"));
        

    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById("result");
            di.innerHTML = xhr.responseText;    
            //alert(xhr.responseText);
        }
    }    
} 

////execQuery : function to exec query without preference
function changeNB(nB){     
    var xhr = getXhr();        
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/resources/ajax/execPrefQuery.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    
    xhr.send("nB="+nB);
    
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){ 
            di = document.getElementById("result");
            di.innerHTML = xhr.responseText;
            //alert(xhr.responseText);
        }
    }    
} 

</script>


<div class="box1">
    <h1 align="center">Advanced resources search</h1>    
</div>
<div class="box1">      
    <div id="vocbrowserbloc"></div>
    <form id="formSearch" name="formSearch" method="POST" action="" 
          onsubmit="return submitForm();">�
        <table border="0">  
            <tr>
                <td width="150"><div id="pre2">Select attributes</div></td>
                <td  align="left">:
                    <select name="attribute" id="attribute" >                       
                        <%
     try {
         ConfigQueries query = new ConfigQueries();
         result = conn.execSelectQuery(query.getResSrchAttribs(), query.getModel());
         while (result.hasNext()) {
             rb = result.nextSolution();
             String ch = rb.get("attr").toString();
             out.print("<option value=\"" + ch + "\" " + (ch.equals("content") ? "selected" : "") + ">" + ch + "</option>");
         }
     } catch (Exception e) {
         out.print("Exception : " + e);
     }

                        %>
                    </select>      
                    
                    <input type="button" name="addAttr"  value="+" onclick="addAttrib();" > &nbsp;&nbsp;&nbsp;                                 
                    <input type="button" name="delAttr"  value="-" onclick="remAttrib();">  
                    
                </td>
                <td></td>
            </tr>   
            
            <tr>
                <td><div id="pre2">Attributes queries </div></td>
                <td>:&nbsp;</td>
            </tr>              
        </table>
        
        <div id="queries"></div>
        <div id="prefbattrib"></div>   <!--Preferences between attributes-->     
        
        <table>          
            <tr>
                <td width="150" height="30"> <div id="pre2">Max. of results </div></td>
                <td height="30">: 
                    <select name="maxResult" id="maxResult">                       
                        <%
     for (int i = 1; i <= 20; i++) {
         out.print("<option value=\"" + i + "\" ");
         if (i == 10) {
             out.print("selected");
         }
         out.print(">" + i + "</option>");
     }
                        %>
                    </select>                     
                </td>
            </tr>                
            <tr>             
            <tr>
                <td width="150" height="30">&nbsp;</td>
                <td height="30">&nbsp;&nbsp;<input type="reset" name="Cancel" value="Cancel">&nbsp;&nbsp;&nbsp;
                    <input type="hidden" name="sf" value="2">
                    <input type="submit" name="search" value="Search">            
                </td>
            </tr> 
            <tr>
                <td width="150" valign="bottom">&nbsp;</td>
                <td valign="bottom">     
                    &nbsp;&nbsp;<div id="chgst"><a onclick="changest()" href="#"><%=("1".equals((String) session.getAttribute("st")) ? "Without preferences" : "With preferences")%></a></div>
                </td>
            </tr>             
        </table>
        
    </form>

    
</div>
<!--jj-->

<div id="result">
    <div class="box1"><h2>DigitLib help with searching :</h2>
        <div id="dlhelp">
            <ul type="-"><li>Select <b>Query with preference</b> or <b>Query without preference</b> on the query type popup list,
                <li>the <b>attributes</b> by which documents will be searched. So click (besides the attributes popup list) 
                on the + button (to add) or the - button (to remove),
                <li>the <b>maximum number of result</b> to show,<br><br>
                <li>In case of preference query, for each attribute selected, add the possible <b>preference relation</b>. So click 
                on the + button (to add) or the - button (to remove) besides the corresponding attributes preference.
            </ul>
            
        </div>    
    </div>
</div>
<%@ include file="/footer.jsp" %>