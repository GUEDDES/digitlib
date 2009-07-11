/*
 * RdfQueryOnRsrce.java
 *
 * Created on 27 février 2008, 14:21
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib;

import java.util.List;

/**
 *
 * @author nguer
 */
public class ConfigQueries extends Config {

    private String model = "config";
    private String schemaModel = "configSchema";

    /**
     * Creates a new instance of RdfQueryOnRsrce
     */
    public ConfigQueries() {
    }

    public String getAllParams() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "SELECT DISTINCT ?p ?o " +
                "WHERE {?r ?p ?o . " +
                "       FILTER(str(?r) = \"" + this.getConfig() + "\")}";

    }
    /**
     * 
     * @return The query to have the resources attributes to use for resources searching
     */
    public String getResSrchAttribs() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "SELECT DISTINCT ?attr " +
                "WHERE {?r ?p ?attr . " +
                "       FILTER(str(?p) = \"" + this.getConfig() + "s#ressrchattrib\")} " +
                " ORDER BY ASC(?attr)";

    }

    public String getAllowedNotifAttrib() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "SELECT DISTINCT ?attr " +
                "WHERE {?r ?p ?attr . " +
                "       FILTER(str(?p) = \"" + this.getConfig() + "s#allowednotifattrib\")} " +
                " ORDER BY ASC(?attr)";

    }
    /**
     *
     * @return The query to have the resources attributes to use for resources searching
     */
    public String getConfigParams(String prop) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "SELECT DISTINCT ?attr " +
                "WHERE {?r ?p ?attr . " +
                "       FILTER(str(?p) = \"" + this.getConfig() + "s#"+prop+"\")}" +
                "ORDER BY ASC(?attr)";

    }

    /**
     * 
     * @param url
     * @param p
     * @param o
     * @param h
     * @return
     */
    public String updateConfigParam(String url, String p, String o) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + url + "> config:" + p + " ?o }" +
                "INSERT " +
                " { <" + url + "> config:" + p + " \"" + o + "\" }" +
                "WHERE " +
                " { <" + url + "> config:" + p + " ?o }";
    }

    /**
     *
     * @param url
     * @param p
     * @param o
     * @param h
     * @return
     */
    public String updateConfigParam(String url, String p, List<String> o) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX config:<" + this.getConfig() + "s#>" +
                "MODIFY   " +
                "DELETE { <" + url + "> config:" + p + " ?o }" +
                "INSERT {";

        for (String attr : o) {
            query += "  <" + url + "> config:" + p + " \"" + attr + "\" . ";
        }

        query += "}WHERE " +
                " { <" + url + "> config:" + p + " ?o }";

        return query;
    }

    public String getModel() {
        return model;
    }

    /**
     * @return the schemaModel
     */
    public String getSchemaModel() {
        return schemaModel;
    }
}
