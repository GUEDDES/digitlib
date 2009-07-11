<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%!
//Rdf data base variables
    QuerySolution rb;
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>

<%
     String vocType = (String) session.getAttribute("voctype");
     String vocName = (String) session.getAttribute("vocname");
     String bCMethod = (String) session.getAttribute("bcmethod");
     ResQueries rQuery = new ResQueries();
     String attrib = request.getParameter("attrib");
     if (attrib != null) {%>
         <div id="<%=attrib%>Query">
            <table border="0" id="ddd">
                <tr>
                    <td width="133"><div id="pre2"><%=attrib.substring(0, 1).toUpperCase()+attrib.substring(1) %></div></td>
                    <td>:&nbsp;
                        
                    </td>
                </tr>                
                
                <tr>
                    <td width="133"><div id="pre">Query</div></td>
                    <td>:&nbsp;
                        <input type="text" name="<%=attrib%>Terms" id="<%=attrib%>" size="40" value="" />
                        <%    if ("content".equals(attrib)) {%>
        <span id="vocbrowser">

            <a href="#" onclick="insertVocBrowser('<%="1".equals(vocType) ? "" : vocName + "-" + vocName%>','<%=vocName%>','<%=vocType%>','formSearch','1', '<%=attrib%>Terms', 'vocbrowserbloc');">
                <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17" align="middle">
            </a>
        </span>
                <%}%>
                    </td>
                </tr>
            </table>         
        
    </div>
<%
     }
%> 
