package org.digitlib.resource;

import java.util.List;
import org.digitlib.Config;

/**
 * 
 * @author nguer
 */
public class ResQueries extends Config {

    private String model = "resources";
    private String schemaModel = "resourcesSchema";

    /**
     * Creates a new instance of Queries
     */
    public ResQueries() {
    }

    //Getting the query for no attribute form.
    public String getNAQuery(String query) {
        String tab[] = query.split(" ");
        int tabLen = tab.length;
        if (tabLen == 1) {
            if (tab[0].equals("")) {
                tab = null;
            }
        }
        query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/> " +
                "SELECT  DISTINCT ?uri  " +
                "WHERE {";
        for (int i = 0; i < tabLen; i++) {
            query += "{?uri ?p ?r . FILTER REGEX(str(?r),\"" + tab[i] + "\")}";
            if ((i + 1) < tabLen) {
                query += " UNION ";
            }
        }

        query += "}";
        return query;
    }

    //Get all terms registed in vocabulary named vocName
    public String getAttribValues(String vocName, String attrib) {//ok
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?term " +
                "WHERE {?r res:vocname \"" + vocName + "\" ." +
                "       ?r res:" + attrib + " ?term}" +
                " ORDER BY ASC(?term)";
    }
    //Get all docs registed in vocabulary named vocName

    public String getRsrceList(int limit, int offset) {
        if(limit==-1)
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?url ?smt ?stt " +
                "WHERE { ?url res:submitter ?smt ." +
                "       ?url res:state ?stt} ";
        //http://portal.acm.org/citation.cfm?id=800227.80689 .
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?url ?smt ?stt " +
                "WHERE { ?url res:submitter ?smt ." +
                "       ?url res:state ?stt} " +
                "LIMIT "+limit+" OFFSET "+offset;

    }

    //Get all docs registed in vocabulary named vocName
    public String getRsrceList(String vocName) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?url ?srce ?active " +
                "WHERE {?url res:vocname \"" + vocName + "\"." +
                "       ?url res:submitter ?srce ." +
                "       OPTIONAL{?url res:state ?active}}";

    }

    public String getRsrceByRegister(String submitter, int limit, int offset) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?url ?smt ?stt " +
                "WHERE {?url res:submitter ?smt ." +
                "       ?url res:state ?stt . " +
                "       FILTER(STR(?smt)=\"" + submitter + "\")} " +
                "LIMIT "+limit+" OFFSET "+offset;
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String getRsrceByUrl(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?p ?o " +
                "WHERE {?url ?p ?o . " +
                "       FILTER(STR(?url)=\"" + url + "\")}";
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String getContentUrl(String resUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?o " +
                "WHERE {?r res:content ?o . " +
                "       FILTER(STR(?r)=\"" + resUrl + "\")}";
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String existResource(Resource res) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "ASK  " +
                "WHERE { ?r ?p ?o ." +
                "       FILTER(STR(?r)=\"" + res.getUrl() + "\")}";
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String existContent(String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "ASK  " +
                "WHERE { ?r res:content ?o ." +
                "       FILTER(STR(?o)=\"" + contUrl + "\")}";
    }

    /**
     * 
     * @param rsce A resource
     * @return All content description containing rsce content description
     */
    public String listContent(Resource rsce) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?r  " +
                "WHERE { ";
        for (int i = 0; i < rsce.getContent().size(); i++) {
            query += "?r rdf:type ?o" + i + " . FILTER(STR(?o" + i + ")= \"" + rsce.getVoc().getUrl() + "#" + rsce.getContent().get(i) + "\") . ";
        }

        query += " }";

        return query;
    }

    /**
     *
     * @param vocUrl : The vocabulary Url
     * @param labelsIds Labels ids list
     * @return Query to get the list of description Url matching labelsIds elements
     */
        public String contentUrlList(String vocUrl, List<String> labelsIds) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?r  " +
                "WHERE { ";
        for (int i = 0; i < labelsIds.size(); i++) {
            query += "{ ?r rdf:type ?o" + i + " . FILTER(STR(?o" + i + ")= \"" + vocUrl + "#" + labelsIds.get(i) + "\")} ";
            if(i<labelsIds.size()-1)
                query += "UNION";
        }


        query += " }";

        return query;
    }

        public String contentUrlList(List<String> labelsIds) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?r  " +
                "WHERE { ";
        for (int i = 0; i < labelsIds.size(); i++) {
            query += "{ ?r rdf:type ?o" + i + " . FILTER(STR(?o" + i + ")= \""+ labelsIds.get(i) + "\")} ";
            if(i<labelsIds.size()-1)
                query += "UNION";
        }


        query += " }";

        return query;
    }

    public String getResource(String attribName, String attribValue) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?url " +
                "WHERE {?url res:"+attribName+" ?o . " +
                "       FILTER(STR(?o)=\"" + attribValue + "\")}";
    }
    /**
     *
     * @param rsce A resource
     * @return query to have all content description containing rsce content description
     */
    public String contentTerm(String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?o  " +
                "WHERE { ?r rdf:type ?o . FILTER(STR(?r)=\"" + contUrl + "\") }";

    }


    public String addContent(Resource rsce) {
        String descr = "";
        for (String term : rsce.getContent()) {
            descr += "  ;  res:content  \"" + term + "\"  ";
        }
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "INSERT  " +
                " { <" + rsce.getUrl() + "> res:submitter  \"" + rsce.getSubmitter().getLogin() + "\" ; " +
                "                       res:state  \"" + rsce.getState() + "\" ; " +
                "                       res:vocname  \"" + rsce.getVoc().getName() + "\" ; " +
                "                       res:type  \"" + rsce.getType() + "\" ; " +
                "                       res:language  \"" + rsce.getLanguage() + "\" ; " +
                "                       res:format  \"" + rsce.getFormat() + "\" ; " +
                "                       res:author  \"" + rsce.getAuthor() + "\"  " +
                descr +
                "               }";
    }

    public String insertContent(Resource rsce, String contUrl) {
        String descr = "";
        for (String term : rsce.getContent()) {
            descr += "   rdf:type  \"" + term + "\" ; ";
        }
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "INSERT  " +
                " { <" + contUrl + "> " + descr + " }";
    }

    public String insertResource(Resource rsce, String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "INSERT  " +
                " { <" + rsce.getUrl() + "> res:submitter  \"" + rsce.getSubmitter().getLogin() + "\" ; " +
                "                       res:state  \"" + rsce.getState() + "\" ; " +
                "                       res:vocname  \"" + rsce.getVoc().getName() + "\" ; " +
                "                       res:type  \"" + rsce.getType() + "\" ; " +
                "                       res:language  \"" + rsce.getLanguage() + "\" ; " +
                "                       res:format  \"" + rsce.getFormat() + "\" ; " +
                "                       res:author  \"" + rsce.getAuthor() + "\" ; " +
                "                       res:content  \"" + contUrl + "\"  " +
                "               }";
    }

    public String insert(Resource rsce) {
        String descr = "";
        for (String term : rsce.getContent()) {
            descr += "  ;  res:content  \"" + term + "\"  ";
        }
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "INSERT  " +
                " { <" + rsce.getUrl() + "> res:submitter  \"" + rsce.getSubmitter().getLogin() + "\" ; " +
                "                       res:state  \"" + rsce.getState() + "\" ; " +
                "                       res:vocname  \"" + rsce.getVoc().getName() + "\" ; " +
                "                       res:type  \"" + rsce.getType() + "\" ; " +
                "                       res:language  \"" + rsce.getLanguage() + "\" ; " +
                "                       res:format  \"" + rsce.getFormat() + "\" ; " +
                "                       res:author  \"" + rsce.getAuthor() + "\"  " +
                descr +
                "               }";
    }

    /**
     * 
     * @param url
     * @param p
     * @param o
     * @param h
     * @return
     */
    public String updateResource(String url, String p, String o, String h) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + url + "> ?p ?o }" +
                "INSERT " +
                " { <" + url + "> dc:" + p + " \"" + h + "\" }" +
                "WHERE " +
                " { <" + url + "> dc:" + p + " \"" + o + "\" }";
    }

    /**
     * 
     * @param url The resource's url
     * @return  Te sparql query to delete a resource
     */
    public String deleteResource(String resUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "DELETE " +
                " { <" + resUrl + "> ?p ?o }" +
                "WHERE" +
                "{<" + resUrl + "> ?p ?o}";
    }

    public String deleteContent(String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "DELETE " +
                " { <" + contUrl + "> rdf:type ?o }" +
                "WHERE" +
                "{<" + contUrl + "> rdf:type ?o}";
    }

    /**
     * 
     * @param url The resource url
     * @param state The resource state 0 (inactive) or 1 (active)
     * @return The RdfQuery to active ou inactive a resource
     */
    public String changeState(String url, String state) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + url + "> res:state \"" + state + "\" }" +
                "INSERT " +
                " { <" + url + "> res:state \"" + (state.equals("0") ? "1" : "0") + "\" }";
    }

    public String getAllResAttribs() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX res:<" + this.getRes() + "s#>" +
                "SELECT DISTINCT ?attr " +
                "WHERE {?attr ?p rdfs:Property }" +
                "ORDER BY ASC(?attr)";

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
