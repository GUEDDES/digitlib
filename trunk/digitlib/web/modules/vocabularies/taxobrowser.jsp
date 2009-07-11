<%@ page language="java" import="org.digitlib.db.*"  %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<% 
if(session.getAttribute("MODULE_FILE")==null){
out.print("You can't access this file directly...");
    return;
}

String login = (String)session.getAttribute("login");
%>

<%!  
static RdfDBAccess rdfDB = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    rdfDB.DBConnect() ;
}
%>
<%
    String begin = request.getParameter("begin");
    String term = request.getParameter("term");
    String taxo = request.getParameter("taxo");
    String field = request.getParameter("field");
    String form = (request.getParameter("form")==null)?"":request.getParameter("form");
%>

<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script language="JavaScript1.2" type="text/javascript">  
function init() {
    gettaxoterms("<%=term%>","<%=taxo%>","<%=form%>","<%=begin%>","<%=field%>");
}    

window.onload = init; 

function gettaxoterms(term, taxo, form, begin, field){
    var xhr = getXhr(); 
    di = document.getElementById("taxoterms");
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/vocbrowser/gettaxoterms.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("term="+term+"&taxo="+taxo+"&form="+form+"&begin="+begin+"&field="+field);
    
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


    <link rel="stylesheet" href="themes/style.css" type="text/css" />          
    <div class="box1">
        <h1 align="center">DigitLib taxonomy browser</h1>    
    </div>
    <div class="box1">
        <h2 >Taxonomy name : <%=taxo%></h2>
    </div>
    <div class="box1" id="taxoterms"></div>
        
    <div class="box1">
        <h2 align="center" ><a href="javascript:self.close();"><font size='2'>Close this window</font></a></h2>
    </div>