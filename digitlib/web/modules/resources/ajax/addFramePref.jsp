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

        if("1".equals((String) session.getAttribute("st"))){
            %>
            <div id="<%=attrib%>Pref">
                <table border="0">
                <tr>
                    <td width="133"><div id="pre"> Preferences</div></td>
                    <td>: <input  type="button" name="add"  value="+" 
                                      onclick="addPref('<%=attrib%>');">
                        &nbsp;&nbsp;&nbsp;
                        <input type="button" name="remove"  value="-" 
                               onclick="removePref('<%=attrib%>');">
                        <input   type="hidden"   name="<%=attrib%>PrefSize" value="0">
                    </td>
                </tr>
                </table>
                
                    <table border="0" width="530" >
                <tr>
                    <td  align="center">
                        <div id="<%=attrib%>PrefList" class="prefList"></div><!--For containing the contdescription preference-->                        
                    </td>
                </tr>                
                </table>
            </div>
<%}%>
