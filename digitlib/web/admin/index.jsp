<%@ page language="java" import="org.digitlib.modules.db.*" import="org.digitlib.modules.search.resource.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
%>
