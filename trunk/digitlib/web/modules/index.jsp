<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%
if(session.getAttribute("MODULES_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
%>
