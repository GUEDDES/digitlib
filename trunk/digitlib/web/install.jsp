<%@ page language="java"  import="org.digitlib.db.*" import="org.digitlib.*" import="org.digitlib.subscription.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>

<%!    static RdfDBAccess conn = new RdfDBAccess();
    ModelRDB model;
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>

<%
        String msg = "Installation is already done";
        model = conn.getModel("config");
        Config conf = new Config();
// Set the absolute path to provides access to rdf files
        conf.setAppWebDir(getServletContext().getRealPath("/"));

        if (model == null) {
            model = conn.createModel("configSchema");
            InputStream in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/config/config.rdfs"));
            model.read(in, null);
            model = conn.createModel("config");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/config/config.rdf"));
            model.read(in, null);

            model = conn.createModel("resourcesSchema");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/resources/resources.rdfs"));
            model.read(in, null);
            model = conn.createModel("resources");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/resources/resources.rdf"));
            model.read(in, null);

            model = conn.createModel("usersSchema");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/users/users.rdfs"));
            model.read(in, null);
            model = conn.createModel("users");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/users/users.rdf"));
            model.read(in, null);

            model = conn.createModel("subscriptionsSchema");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/subscriptions/subscriptions.rdfs"));
            model.read(in, null);
            model = conn.createModel("subscriptions");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/subscriptions/subscriptions.rdf"));
            model.read(in, null);

            model = conn.createModel("subsTreeSchema");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/subscriptions/substree.rdfs"));
            model.read(in, null);
            model = conn.createModel("subsTree");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/subscriptions/substree.rdf"));
            model.read(in, null);

            model = conn.createModel("vocabulariesSchema");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/vocabularies/vocabularies.rdfs"));
            model.read(in, null);
            model = conn.createModel("vocabularies");
            in = new FileInputStream(new File(conf.getAppWebDir() + "includes/data/vocabularies/vocabularies.rdf"));
            model.read(in, null);

            // Calcule la sélectivité du vocabulaire
            new VocUtils(conn, true).calcAllSelectivities();

            msg = "The database is succefully installed";
        }
        session.invalidate();
%>
<jsp:forward  page="index.jsp" >
    <jsp:param name="msg" value="<%=msg%>"></jsp:param>
</jsp:forward>

