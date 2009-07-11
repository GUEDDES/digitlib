/*
 * RdfDBAccess.java
 *
 * Created on 22 février 2006, 11:12
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.db;

import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.update.*;
import com.hp.hpl.jena.db.*;

/**
 *
 * @author nguer
 */
public class RdfDBAccess {

    public IDBConnection conn;
    public QueryExecution qexec;
    public ModelRDB model;
    public static String DBTYPE = "";
    public static String URL = "";
    public static String DRIVER = "";
    public static String USER = "";
    public static String PWD = "";
    public static String PREFIX = "";

    /**
     * Creates a new instance of RdfDBAccess
     */
    public RdfDBAccess() {
    }

    public static void init(String dBType, String url, String driver, String user, String pwd, String prefix) {
        DBTYPE = dBType;
        URL = url;
        DRIVER = driver;
        USER = user;
        PWD = pwd;
        PREFIX = prefix;
    }

    public void DBConnect() {

        try {
            // Create database connection
            Class.forName(DRIVER);
            this.conn = new DBConnection(URL, USER, PWD, DBTYPE);
            this.conn.getDriver().setTableNamePrefix(PREFIX);
        //this.conn.getDriver().setDoCompressURI(true);



        } catch (Exception ex) {
            System.err.println("Exception: " + ex);
            ex.printStackTrace(System.err);
        }
    }

    public ModelRDB getModel(String modelName) {
        ModelRDB modl = null;

        if (this.conn.containsModel(modelName)) {
            modl = ModelRDB.open(this.conn, modelName);

        }/*else{
        model = ModelRDB.createModel(this.conn, modelName);

        }*/
        return modl;
    }

    public ModelRDB createModel(String modelName) {
        ModelRDB modl = null;

        if (this.conn.containsModel(modelName)) {
            modl = ModelRDB.open(this.conn, modelName);
            modl.remove();
        }
        modl = ModelRDB.createModel(this.conn, modelName);
        return modl;
    }

    public int size(ResultSet result) {
        int n = 0;
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            n++;
        }
        return n;
    }

    public void execUpdateQuery(String queryString, ModelRDB model) {
        try {
            UpdateRequest query = UpdateFactory.create(queryString);
            // Execute the query and obtain results
            UpdateAction.execute(query, model);
        // Important - free up resources used running the query

        } catch (Exception ex) {
            System.err.println("Exception: " + ex);
            ex.printStackTrace(System.err);
        }

    }

    public void execUpdateQuery(String queryString, String model) {
        execUpdateQuery(queryString, getModel(model));

    }

    public ResultSet execSelectQuery(String queryString, ModelRDB model) {
        ResultSet results = null;
        try {
            Query query = QueryFactory.create(queryString);
            // Execute the query and obtain results
            this.qexec = QueryExecutionFactory.create(query, model);
            // Important - free up resources used running the query
            try {
                results = this.qexec.execSelect();
            } catch (Exception ex) {
                System.err.println("Exception: " + ex);
            }

        } catch (Exception ex) {
            System.err.println("Exception: " + ex);
            ex.printStackTrace(System.err);
        }
        return results;

    }

    public ResultSet execSelectQuery(String queryString, String modelName) {
        return execSelectQuery(queryString, getModel(modelName));
    }

    public boolean execAskQuery(String queryString, ModelRDB model) {
        Query query = QueryFactory.create(queryString);
        QueryExecution qexc = QueryExecutionFactory.create(query, model);
        boolean result = qexc.execAsk();
        //qexec.close() ;
        return result;
    }

    public boolean execAskQuery(String query, String model) {
        return execAskQuery(query, getModel(model));
    }

    public void closeQExec() {
        try {
            this.qexec.close();
        } catch (Exception ex) {
            System.err.println("Qexec Exception : " + ex);
        }
    }

    public void closeModel() {
        try {
            this.model.close();
        } catch (Exception ex) {
            System.err.println("Exception: " + ex);
        }
    }

    public void closeConn() {
        try {
            this.conn.close();
        } catch (Exception ex) {
            System.err.println("Exception: " + ex);
        }
    }
}
