/*
 * VocQueries.java
 *
 * Created on 27 février 2008, 14:21
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.vocabulary;

import org.digitlib.Config;

/**
 *
 * @author nguer
 */
public class VocQueries extends Config {

    private String model = "vocabularies";

    /**
     * Creates a new instance of VocQueries
     */
    public VocQueries() {
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String getAllVoc() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?r ?vn ?lg ?vt ?ac " +
                "WHERE { ?r dc:name ?vn . " +
                "        ?r dc:language ?lg . " +
                "        ?r dc:state ?ac . " +
                "        ?r dc:type ?vt} ORDER BY DESC(?vt)";
    }

    public String getVoc(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?p ?o " +
                "WHERE {?url ?p ?o . " +
                "       FILTER(STR(?url)=\"" + url + "\")}";
    }

    public String getRoot(Vocabulary voc) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT  ?root " +
                "WHERE {?r rdfs:label ?root . " +
                "       FILTER(STR(?r)=\"" + voc.getUrl()+"#"+voc.getName() + "\")}";
    }

    public String vocExist(String url, String name) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "ASK " +
                "WHERE {{?r voc:name \"" + name + "\"} UNION " +
                "       {FILTER(str(?r) = \"" + url + "\")} }";
    }

    //Get all docs registed by a source in vocabulary named vocName
    public String getVocByType(String type) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?r ?vn ?lg " +
                "WHERE { ?r dc:name ?vn . " +
                "        ?r dc:language ?lg . " +
                "        ?r dc:type \"" + type + "\" }";
    }

    //Query to get the parameter of the vocabulary named vocname    //OK
    public String getVocByName(String vocname) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?uri ?vl ?vt ?vs " +
                "WHERE {?uri dc:name ?name . FILTER(STR(?name)= \"" + vocname + "\") . " +
                "       ?uri dc:language ?vl ." +
                "       ?uri dc:state ?vs . " +
                "       ?uri dc:type ?vt }";
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
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + url + "> voc:state \"" + state + "\" }" +
                "INSERT " +
                " { <" + url + "> voc:state \"" + (state.equals("0") ? "1" : "0") + "\" }";
    }

    /**
     * 
     * @param   rsce The resource object to add to the catalog 
     * @return  The Sparql query to add rsce in the catalog 
     */
    public String insert(Vocabulary voc) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "INSERT  " +
                " { <" + voc.getUrl() + ">  voc:name  \"" + voc.getName() + "\" ; " +
                "                       voc:language  \"" + voc.getLanguage() + "\" ; " +
                "                       voc:type  \"" + voc.getType() + "\" ; " +
                "                       voc:state  \"" + voc.getState() + "\" }";
    }

    /**
     * 
     * @param url The resource's url
     * @return  Te sparql query to delete a resource
     */
    public String delete(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "DELETE " +
                " { <" + url + "> ?p ?o }" +
                "WHERE" +
                "{<" + url + "> ?p ?o}";
    }

    public String getTermSuccessors(Vocabulary voc, String term) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "SELECT  ?succ ?label " +
                "WHERE {" +
                "       ?succ rdfs:label ?label . " +
                "       ?succ rdfs:subClassOf ?term . " +
                "   FILTER(str(?term)=\"" + voc.getUrl() + "#" + term + "\") . " +
                "   FILTER(regex(str(?succ), \"" + voc.getUrl() + "#\")) }";
    }
//\""+voc.getUrl()+"#"+ term + "\"

    /**
     *
     * @param c A character
     * @param voc A vocabulary name
     * @return All terms of a vocabulary voc starting by chr
     * It's applied to vocabulary without taxonomy
     */
    public String getVocTerms(String chr, String voc) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "SELECT  ?term " +
                "WHERE {?r dc:name \"" + voc + "\" ." +
                "       ?r dc:term ?term ." +
                "       FILTER(REGEX(STR(?term),\"^" + chr + "\",\"i\"))}";
    }

    public String getVocTerms(Vocabulary voc) {
        if ("1".equals(voc.getType())) {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "SELECT  ?term " +
                    "WHERE {" +
                    "   ?r voc:name \"" + voc.getName() + "\" ." +
                    "   ?r voc:term ?term }";
        } else {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "SELECT  ?term " +
                    "WHERE {" +
                    "   ?r voc:name \"" + voc.getName() + "\" ." +
                    "   ?term term:parentname ?s ." +
                    "   FILTER(regex(str(?term), str(?r))) }";
        }
    }

    public String getTaxoTerms(String taxo) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX term:<" + this.getTerm() + "s#>" +
                "SELECT  ?term " +
                "WHERE {" +
                "   ?r voc:name \"" + taxo + "\" ." +
                "   ?term term:parentname ?s ." +
                "   FILTER(regex(str(?term), str(?r))) }";
    }

/**
 *
 * @param voc
 * @param label
 * @return the id corresponding to the term label in the vocabulary voc
 */

    public String getIdOfLabel(Vocabulary voc, String label) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "SELECT  ?r " +
                "WHERE {" +
                    "       ?r rdfs:label \"" + label + "\" ." +
                    "   FILTER(regex(str(?r), \"" + voc.getUrl() + "#\")) }";                
    }

/**
 *
 * @param voc
 * @param id
 * @return the label corresponding to the id id from the vocabulary voc
 */
    public String getLabelOfId(Vocabulary voc, String id) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "SELECT  ?label " +
                "WHERE {" +
                    "       ?r rdfs:label ?label ." +
                    "   FILTER(str(?r) = \"" + voc.getUrl() + "#"+id+"\") }";
    }

    public String termExist(Vocabulary voc, String term) {
        if ("1".equals(voc.getType())) {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "ASK " +
                    "WHERE {?r dc:name \"" + voc.getName() + "\" ." +
                    "       ?r dc:term \"" + term + "\" }";
        } else {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                    "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "ASK " +
                    "WHERE { " +
                    "       ?r rdfs:label \"" + term + "\" ." +
                    "   FILTER(regex(str(?r), \"" + voc.getUrl() + "#\")) }";
        }
    }
    /*                "       ?succ rdfs:label ?label . " +
    "       ?succ rdfs:subClassOf ?term . " +
    "   FILTER(str(?term)=\""+voc.getUrl()+"#"+term+"\") . "+
    "   FILTER(regex(str(?succ), \""+voc.getUrl()+"#\")) }";*/

    public String addTerm(Vocabulary voc, String term, String parent) {
        if ("2".equals(voc.getType())) {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "INSERT  " +
                    " { <" + voc.getUrl() + "#" + term + ">  term:parentname  \"" + parent + "\"  }";
        } else {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "INSERT  " +
                    " { <" + voc.getUrl() + ">  voc:term  \"" + term + "\" }";
        }
    }

    public String deleteTerm(Vocabulary voc, String term) {
        if ("2".equals(voc.getType())) {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "DELETE " +
                    " { <" + voc.getUrl() + "#" + term + "> ?p ?o }" +
                    "WHERE" +
                    "{<" + voc.getUrl() + "#" + term + "> ?p ?o }";
        } else {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "DELETE " +
                    " { <" + voc.getUrl() + "> voc:term \"" + term + "\" }" +
                    "WHERE" +
                    " { <" + voc.getUrl() + "> voc:term \"" + term + "\" }";
        }
    }

    //Query to obtain the parent of a term of a vocabulary named vocName //OK
    public String getTermParent(Vocabulary voc, String term) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "PREFIX term:<" + this.getTerm() + "s#>" +
                "SELECT  ?parent " +
                "WHERE {" +
                "   ?r voc:name \"" + voc.getName() + "\" ." +
                "   ?term term:parentname ?parent ." +
                "   FILTER(str(?term) = \"" + voc.getUrl() + "#" + term + "\") }";
    }

    public String updateTerm(Vocabulary voc, String term, String parent, String newTerm, String newParent) {
        if ("1".equals(voc.getType())) {
            return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                    "PREFIX voc:<" + this.getVoc() + "s#>" +
                    "PREFIX term:<" + this.getTerm() + "s#>" +
                    "MODIFY   " +
                    "DELETE " +
                    " { <" + voc.getUrl() + "> voc:term \"" + term + "\"} " +
                    "INSERT " +
                    " { <" + voc.getUrl() + "> voc:term \"" + newTerm + "\"} " +
                    "WHERE  " +
                    " { <" + voc.getUrl() + "> voc:term \"" + term + "\"} ";
        }

        //In case of taxonomy

        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX term:<" + this.getTerm() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + voc.getUrl() + "#" + term + "> term:parentname \"" + parent + "\" }" +
                "INSERT " +
                " { <" + voc.getUrl() + "#" + newTerm + "> term:parentname \"" + newParent + "\" }" +
                "WHERE  " +
                " { <" + voc.getUrl() + "#" + term + "> term:parentname \"" + parent + "\" }";
    }

    public String updateTermParent(Vocabulary voc, String term, String newParent) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX term:<" + this.getTerm() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + voc.getUrl() + "#" + term + "> term:parentname ?pr } " +
                "INSERT " +
                " { <" + voc.getUrl() + "#" + term + "> term:parentname \"" + newParent + "\" } " +
                "WHERE     " +
                " { <" + voc.getUrl() + "#" + term + "> term:parentname ?pr } ";
    }

    /**
     *
     * @param voc
     * @param label
     * @return the request
     */
    public String getTermByLabel(Vocabulary voc, String label) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>" +
                "PREFIX voc:<" + this.getVoc() + "s#>" +
                "SELECT  ?term ?label " +
                "WHERE {" +
                "       ?term rdfs:label ?label . " +
                "   FILTER(str(?label) = \"" + label + "\") }";
    }

    public String getModel() {
        return model;
    }
}
