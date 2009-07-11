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
     if("1".equals((String) session.getAttribute("st"))){
%>
            <div>
                <table border="0">
                <tr>
                    <td width="148"><div id="pre2">Preferences between attributes</div></td>
                    <td>: <input  type="button" name="add"  value="+" 
                                      onclick="addPrefba();">
                        &nbsp;&nbsp;&nbsp;
                        <input type="button" name="remove"  value="-" 
                               onclick="removePrefba();">
                    </td>
                </tr>
                </table>
                
                <table border="0" width="350">
                <tr>
                    <td  align="center">
                        <div id="prefbaList"  class="prefList"></div><!--For containing the contdescription preference-->                        
                    </td>
                </tr>                
                </table>
            </div>
<%
}%>            