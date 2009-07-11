/*
 * RdfQueryOnRsrce.java
 *
 * Created on 27 février 2008, 14:21
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import org.digitlib.Config;

/**
 * This class store the rdf queries for the subscription class
 * @author nguer
 * @param model The model name corresponding in the rdf databse
 */
public class SubsQueries extends Config {

    private String model = "subscriptions";

    /**
     * Creates a new instance of SubsQueries
     */
    public SubsQueries() {
    }

    /**
     * Creates a new instance of SubsQueries
     * @param locale a locale language
     */
    public SubsQueries(Locale locale) {
        super(locale);
    }

    /**
     *
     * @return rdf query to obtain all the asubscriptions submmitted.
     */
    public String getAllSubs() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?r " +
                "WHERE { ?r subscrip:vocname ?o } " +
                " ORDER BY ASC(?r)";
    }

    /**
     *
     * @param lg a user's login
     * @return All the subscription submitted by a user
     */
    public String getSubsByLogin(String lg) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?r  " +
                "WHERE { ?r subscrip:submitter \"" + lg + "\"}" +
                "        ORDER BY ASC(?r)";
    }

    public String contentTerm(String cont) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?o  " +
                "WHERE { ?r rdf:type ?o . FILTER(STR(?r)=\"" + cont + "\") }";

    }

    /**
     * 
     * @param url The subscription's url
     * @return The Rdf query to obtain the corresponding subscription
     */
    public String getSubs(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?r ?p ?o " +
                "WHERE { ?r ?p ?o . " +
                "       FILTER(STR(?r)=\"" + url + "\")}";
    }

    public String subsContainsUser(String subsUrl, String login) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "ASK  " +
                "WHERE { ?r subscrip:submitter \"" + login + "\" . " +
                "       FILTER(STR(?r)=\"" + subsUrl + "\")}";
        return query;
    }

    public String subsContainsUser(String subsUrl) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "ASK  " +
                "WHERE { ?r subscrip:submitter ?o . " +
                "       FILTER(STR(?r)=\"" + subsUrl + "\")}";
        return query;
    }
    /**
     * 
     * @param subsUrl
     * @param login
     * @return the SparQl to know if the subscription subsUrl is submitteb by a user distinct to login
     */
    public String subsContainsDistinctUser(String subsUrl, String login) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "ASK  " +
                "WHERE { ?r subscrip:submitter ?o . " +
                "       FILTER(STR(?r)=\"" + subsUrl + "\")." +
                "       FILTER(STR(?o)=\"" + login + "\")}";
        return query;
    }
    /**
     *
     * @param subs a subscription
     * @return A rdf query to know if a subscription exists.
     */
    public String subsExist(Subscription subs, Map<String, String> urlList) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "ASK  " +
                "WHERE { ?r subscrip:nature \"" + subs.getNature() + "\" ." +
                "        ?r subscrip:vocname \"" + subs.getVoc().getName() + "\" ";

        for (Iterator it = subs.getResAttrib().keySet().iterator(); it.hasNext();) {
            String notifAttrib = it.next().toString();
            if ("content".equals(notifAttrib)) {
                query += ". ?r subscrip:" + notifAttrib + " \"" + urlList.get(notifAttrib) + "\" ";
            } else {
                for (String term : subs.getResAttrib().get(notifAttrib)) {
                    query += ". ?r subscrip:" + notifAttrib + " \"" + term + "\" ";
                }
            }
        }
        query += " }";
        return query;
    }

    public String getSubsUrl(Subscription subs, String descrUrl) {
        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "SELECT DISTINCT ?r " +
                "WHERE { ?r subscrip:nature \"" + subs.getNature() + "\" ." +
                "        ?r subscrip:vocname \"" + subs.getVoc().getName() + "\" ";

        for (Iterator it = subs.getResAttrib().keySet().iterator(); it.hasNext();) {
            String notifAttrib = it.next().toString();
            if ("content".equals(notifAttrib)&&(descrUrl!=null)) {
                query += " . ?r subscrip:" + notifAttrib + " \"" + descrUrl + "\" ";
            } else {
                for (String term : subs.getResAttrib().get(notifAttrib)) {
                    query += " . ?r subscrip:" + notifAttrib + " \"" + term + "\" ";
                }
            }
        }
        query += " }";
        return query;
    }
    /**
     * 
     * @param url The subscription's url
     * @return  Te sparql query to delete the subscription url
     */
    public String deleteSubscription(String subsUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "DELETE " +
                " { <" + subsUrl + "> ?p ?o }" +
                "WHERE" +
                "{<" + subsUrl + "> ?p ?o}";
    }

    public String existContent(String notifAttrib, String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "ASK  " +
                "WHERE { ?r subscrip:" + notifAttrib + " ?o ." +
                "       FILTER(STR(?o)=\"" + contUrl + "\")}";
    }

    public String deleteContent(String contUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "DELETE " +
                " { <" + contUrl + "> rdf:type ?o }" +
                "WHERE" +
                "{<" + contUrl + "> rdf:type ?o}";
    }

    /**
     * 
     * @param url The subscription url
     * @param state The subscription state 0 (inactive) or 1 (active)
     * @return The RdfQuery to active ou inactive a subscription
     */
    public String changeState(String subsUrl, String state) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + subsUrl + "> subscrip:state \"" + state + "\" }" +
                "INSERT " +
                " { <" + subsUrl + "> subscrip:state \"" + (state.equals("0") ? "1" : "0") + "\" }";
    }

    /**
     *
     * @param subs The subscription to insert in the catalog
     * @return The Rdfquery for insert a new subscription
     */
    public String addSubscription(Subscription subs, String contUrl) {
        String descr = "";
        for (Iterator it = subs.getResAttrib().keySet().iterator(); it.hasNext();) {
            String notifAttrib = it.next().toString();
            if ("content".equals(notifAttrib)&&(contUrl!=null)) {
                descr += "  ;  subscrip:" + notifAttrib + "  \"" + contUrl + "\"  ";
            } else {
                for (String term : subs.getResAttrib().get(notifAttrib)) {
                    descr += "  ;  subscrip:" + notifAttrib + "  \"" + term + "\"  ";
                }
            }

        }

        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "INSERT  " +
                " { <" + subs.getUrl() + "> subscrip:submitter  \"" + subs.getLogin() + "\"  " +
                "                      ; subscrip:state  \"" + subs.getState() + "\"  " +
                "                      ; subscrip:vocname  \"" + subs.getVoc().getName() + "\"  " +
                "                      ; subscrip:parentname  \"none\" " +
                "                      ; subscrip:nature  \"" + subs.getNature() + "\" " +
                descr + 
                "               }";
    }

    /**
     *
     * @param subs The subscription to insert in the catalog
     * @return The Rdfquery for insert a new subscription
     */
    public String addSubmitter(String subsUrl, String login) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "INSERT  " +
                " { <" + subsUrl + "> subscrip:submitter  \"" + login + "\" }";
    }

    public String delSubmitter(String subsUrl, String login) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "DELETE " +
                " { <" + subsUrl + "> subscrip:submitter ?o }" +
                "WHERE" +
                "{<" + subsUrl+ "> subscrip:submitter ?o . " +
                "       FILTER(STR(?o)=\"" + login + "\")}";
    }

    public String listContent(Subscription rsce, String notifAttrib) {
        String url = rsce.getQuery().getSubscrip();
        if ("content".equals(notifAttrib)) {
            url = rsce.getVoc().getUrl();
        }

        String query = "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "SELECT DISTINCT ?r  " +
                "WHERE { ";
        for (int i = 0; i < rsce.getResAttrib().get(notifAttrib).size(); i++) {
            query += "?r rdf:type ?o" + i + " . FILTER(STR(?o" + i + ")= \"" + url + "#" + rsce.getResAttrib().get(notifAttrib).get(i) + "\") . ";
        }

        query += " }";

        return query;
    }

    public String insertContent(Subscription rsce, String notifAttrib, String contUrl) {
        String url = rsce.getQuery().getSubscrip();
        if ("content".equals(notifAttrib)) {
            url = rsce.getVoc().getUrl();
        }

        String descr = "";
        for (String term : rsce.getResAttrib().get(notifAttrib)) {
            descr += "   rdf:type  \"" + url + "#" + term + "\" ; ";
        }
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "INSERT  " +
                " { <" + contUrl + "> " + descr + " }";
    }

    public String getContentUrl(String resUrl, String notifAttrib) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX subscrip:<" + this.getSubscrip() + "s#>" +
                "SELECT DISTINCT ?o " +
                "WHERE {?r subscrip:" + notifAttrib + " ?o . " +
                "       FILTER(STR(?r)=\"" + resUrl + "\")}";
    }

    public String getModel() {
        return model;
    }
}
