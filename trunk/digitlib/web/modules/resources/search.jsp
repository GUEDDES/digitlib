<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%
        if (session.getAttribute("MODULE_FILE") == null) {
            out.print("You can't access this file directly...");
            return;
        }
        String vocType = (String) session.getAttribute("voctype");
        String vocName = (String) session.getAttribute("vocname");
%>
<%@ include file="/config.jsp" %>

<%@ include file="/header.jsp" %>
<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script type="text/javascript">         

    function ajaxSearch(){
        var xhr = getXhr();
        // Ici on va voir comment faire du post
        xhr.open("POST","modules/resources/ajax/search.jsp",true);
        // ne pas oublier ça pour le post
        xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        // ne pas oublier de poster les arguments
        // ici, l'id de l'auteur
        xhr.send("query="+document.getElementById('queryc').value);

        // On défini ce qu'on va faire quand on aura la réponse
        xhr.onreadystatechange = function(){
            //alert(xhr.readyState);
            // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
            if(xhr.readyState == 4 && xhr.status == 200){
                di = document.getElementById('result');
                di.innerHTML = xhr.responseText;
            }
        }
        return false;
    }


</script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>

<div class="box1">
    <h1 align="center">Resources search</h1>
</div>
<div class="box1" align="center">

    <FORM  name='simpleFormSearch' action="#" method=post onsubmit="return ajaxSearch();">
        <INPUT size=50 name="query" id="queryc" >&nbsp;
        <span id="vocbrowser">

            <a href="#" onclick="insertVocBrowser('<%="1".equals(vocType) ? "" : vocName + "-" + vocName%>','<%=vocName%>','<%=vocType%>','simpleFormSearch','1', 'query', 'result','1');">
                <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17" align="middle">
            </a>
        </span>&nbsp;&nbsp;<a href="modules.jsp?name=resources&op=advanced">Advanced Search</a>
        <br>
        <input type='submit' name='NPSearch' value='Search' /> &nbsp;&nbsp;<input type='reset'  value='Cancel' /> 

    </FORM>

</div>

<div id="result">
    <%
        if (request.getParameter("query") != null) {
    %>
    <jsp:include page="ajax/search.jsp"></jsp:include>
    <%}%>
</div>  

<%@ include file="/footer.jsp" %>