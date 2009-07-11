<%@ page language="java"  import="org.digitlib.resource.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" %>
<%@ include file="/config.jsp" %>

<%!
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>
<%
            if (session.getAttribute("ADMIN_FILE") == null) {
                out.print("You can't access this file directly...");
                return;
            }
            String status = (String) session.getAttribute("status");
            if ((!status.equals("admin")) && (!status.equals("source"))) {
                response.sendRedirect("index.jsp");
                return;
            }
            String login = (String) session.getAttribute("login");
            String vocType = (String) session.getAttribute("voctype");
            String vocName = (String) session.getAttribute("vocname");
%>

<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="modules/resources/admin/jscripts.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>
<script language="JavaScript1.2" type="text/javascript">  


function changevocbrowser(){ 
    tab = document.updateForm.vocname.value.toString().split("-");
    /*//alert(tab[0]+" "+tab[1]);
    return;*/
    var xhr = getXhr(); 
    di = document.getElementById("vocbrowser");
    // Ici on va voir comment faire du post
    xhr.open("POST","modules/vocabularies/vocbrowser/vocbrowserlink.jsp",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur    
    xhr.send("vocname="+tab[0]+"&voctype="+tab[1]+"&form=updateForm");
    
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
            String descr = "";
            Map<String, String> resAttr = new HashMap();
            resAttr.put("url", request.getParameter("url"));

            if ((request.getParameter("submit") == null) && (resAttr.get("url") != null)) {
                try {
                    ResQueries rQuery = new ResQueries();
                    ResultSet result = conn.execSelectQuery(rQuery.getRsrceByUrl(resAttr.get("url")), rQuery.getModel());
                    while (result.hasNext()) {
                        QuerySolution rb = result.nextSolution();
                        String tab[] = rb.get("p").toString().split("/|#");
                        String p = tab[tab.length - 1];
                        String o = rb.get("o").toString();

                         if("content".equals(p)){
                             //out.print(o);
                            String content = new Config().listToString(new Vocabulary(vocName, conn).idsToLabels(new Resource(conn).contentToString(o)));
                            resAttr.put(p, content);
                        }
                        else
                            resAttr.put(p, o);
                    }

                } catch (Exception e) {
                    out.print("Exception : " + e);
                }
            } else {
                resAttr.put("content", request.getParameter("content"));
                resAttr.put("submitter", (request.getParameter("submitter") == null) ? login : request.getParameter("submitter"));
                resAttr.put("language", request.getParameter("language"));
                resAttr.put("author", request.getParameter("author"));
                resAttr.put("format", request.getParameter("format"));
                resAttr.put("state", ((request.getParameter("state") == null) || "0".equals(request.getParameter("state"))) ? "0" : "1"); //if the resource is active or inactive
                resAttr.put("type", request.getParameter("type"));   //resource type
                resAttr.put("vocname", request.getParameter("vocname").split("-")[0]);
            }

%>
<br>
<h1 align="center">Resource updating</h1>    
<div class="box1"> 
    <div>
        Vocabulary type : <%
            if (resAttr.get("vocname") == null) {
                resAttr.put("vocname", vocName);
                resAttr.put("voctype", vocType);
            } else {
                resAttr.put("voctype", new Vocabulary(resAttr.get("vocname"), conn).getType());
            }

            if ("0".equals(resAttr.get("voctype"))) {
                out.print("None controlled vocabulary");
            } else if ("1".equals(resAttr.get("voctype"))) {
                out.print("controlled vocabulary without taxonomy");
            } else {
                out.print("controlled vocabulary within taxonomy");
            }
        %><br />
        Vocabulary name : <%=resAttr.get("vocname")%>   
    </div>
</div>
<div class="box1">
                <div id="vocbrowserbloc"></div>
    <FORM  name='updateForm'  ACTION='admin.jsp?op=update&cp=resources' METHOD='POST'  
           onSubmit="return register_verifRegistForm(window.document.forms['registForm'])"> 
        <table>
            <tr><td>Url  </td><td>:
                    <INPUT TYPE="text" NAME='url' value="<%=(resAttr.get("url") == null) ? "" : resAttr.get("url")%>" SIZE="40" maxlength="100">
                    <INPUT TYPE="hidden" NAME='firstUrl' value="<%=(resAttr.get("url") == null) ? "" : resAttr.get("url")%>" SIZE="40" maxlength="100">                    
                    
            </td></tr>  
            <%if ("admin".equals(status)) {%>            
            <tr><td>Submitter</td><td> :
                    <INPUT TYPE="text" NAME='submitter' value="<%=resAttr.get("submitter")%>">            
            </td></tr>
            <%} else {%>
            <INPUT TYPE="hidden" NAME='submitter'  value="<%=resAttr.get("submitter")%>" >
            <%}%>
            
            <%if ("0".equals((String) session.getAttribute("restype")) || ("admin".equals(status))) {%>            
            <tr><td>Type</td><td> :
                    <select name="type">
                        <%
    for (int i = 0; i < conf.getResType().size(); i++) {
        out.print("<option value=\"" + i + "\" " + (Integer.toString(i).equals(resAttr.get("type")) ? "selected" : "") + " >" + conf.getResType().get(Integer.toString(i)) + "</option>");
    }                                   
                        %>
            </select></td></tr>
            <%} else {%>
            <INPUT TYPE="hidden" NAME='type' value="<%=(String) session.getAttribute("restype")%>" >
            <%}%>            
            <tr><td>Format </td><td>:
                    <INPUT TYPE="text" NAME='format' value="<%=(resAttr.get("format") == null) ? "" : resAttr.get("format")%>" SIZE="15" maxlength="100">
            </td></tr>   
            <tr><td>Language </td><td>:
                    <INPUT TYPE="text" NAME='language' value="<%=(resAttr.get("language") == null) ? "" : resAttr.get("language")%>" SIZE="15" maxlength="100">
            </td></tr>
            
            <tr><td>Author </td><td>:
                    <INPUT TYPE="text" NAME='author' value="<%=(resAttr.get("author") == null) ? "" : resAttr.get("author")%>"  SIZE="15" maxlength="100">
            </td></tr>  
            <%if ("1".equals((String) session.getAttribute("multivoc")) || ("admin".equals(status))) {
            %>             
            <tr><td>Vocabulary </td><td>:
                    <select id="vocname" name="vocname" onchange="changevocbrowser();">            
                        <%
    try {
        VocQueries vQuery = new VocQueries();
        result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String vt = rb.get("vt").toString();
            String vn = rb.get("vn").toString();
            out.print("<option value=\"" + vn + "-"+vt+"\" " + (resAttr.get("vocname").equals(vn) ? "selected" : "") + " >" + vn + "</option>");
        }
    } catch (Exception e) {
        out.print("Exception : " + e);
    }
                        %>
            </select></td></tr>
            <%} else {%>
            <INPUT TYPE="hidden" NAME='vocname' value="<%=resAttr.get("vocname")%>" >
            <%}%>
            <tr><td>Content </td><td >:
                    <INPUT TYPE="text" NAME="content" value="<%=(resAttr.get("content") == null) ? "" : resAttr.get("content")%>" SIZE="40" maxlength="100" >
                     <span id="vocbrowser">
            <a href="#" onclick="insertVocBrowser('<%="1".equals(vocType) ? "" : vocName + "-" + vocName%>','<%=vocName%>','<%=vocType%>','updateForm','1', 'content', 'vocbrowserbloc');">
                <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17" align="middle">
            </a>
               <!-- <a href="#" onclick="browser(document.registForm,'1','1');">
                    <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17">
                </a>-->

                    </span>
            </td></tr>
            
            <tr><td>State </td><td>:
                <input type="checkbox" name="state"  <%="0".equals(resAttr.get("state")) ? "" : "checked"%>/>
                   </td></tr>             
            
            <tr><td colspan="2">
                    <INPUT TYPE=RESET  NAME="cancel" VALUE='Cancel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE=SUBMIT NAME='submit' VALUE='Record'></td></tr>
        </table>
    </FORM>
</DIV>
<%
    if ((request.getParameter("submit") != null) && (!"".equals(resAttr.get("url")))) {
        Resource res = new Resource(resAttr, conn);
        res.updateResource(request.getParameter("firstUrl"));
        String title = "";
        String msg = "The source "+resAttr.get("url")+" is updated!";   
        String url = "<a href=\"admin.jsp?op=listing&cp=resources\">Back</a>";
%>
<%@ include file="/includes/message.jsp" %>
<%
    }    
%>
</div> 
