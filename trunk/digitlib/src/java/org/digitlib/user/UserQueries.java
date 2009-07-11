/*
 * PersQueries.java
 *
 * Created on 9 février 2006, 11:47
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.user;

import org.digitlib.Config;

/**
 *
 * @author nguer
 */
//Variable pour contenir les preferences
public class UserQueries extends Config {

    private String model = "users";

    /**
     * Creates a new instance of PersQueries
     */
    public UserQueries() {
    }

    //Get all docs registed in vocabulary named vocName
    public String getUsersList() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?fn ?ln ?lg ?pw ?ad ?pn ?em ?st ?se " +
                "WHERE {?r user:firstname ?fn . " +
                "       ?r user:lastname ?ln . " +
                "       ?r user:login ?lg . " +
                "       ?r user:password ?pw . " +
                "       ?r user:adress ?ad . " +
                "       ?r user:phone ?pn . " +
                "       ?r user:email ?em . " +
                "       ?r user:status ?st . " +
                "       ?r user:state ?se }";

    }

    public String getUsersList(String subsUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/>" +
                "SELECT DISTINCT ?fn ?ln ?lg ?pw ?ad ?pn ?em ?st ?se " +
                "WHERE {?r user:firstname ?fn . " +
                "       ?r user:lastname ?ln . " +
                "       ?r user:login ?lg . " +
                "       ?r user:password ?pw . " +
                "       ?r user:adress ?ad . " +
                "       ?r user:phone ?pn . " +
                "       ?r user:email ?em . " +
                "       ?r user:status ?st . " +
                "       ?r user:state ?se . " +
                "       ?r user:subscription ?subs . " +
                "       FILTER(STR(?subs)=\"" + subsUrl + "\")}";

    }
    /**
     * 
     * @return The rdf query to obtain all login'users
     */
    public String getAllUsers() {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "SELECT DISTINCT ?lg  " +
                "WHERE {                 " +
                "       ?r user:login ?lg }";

    }

    public String getDUserByLogin(String lg) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "SELECT DISTINCT ?fn ?ln ?pw ?ad ?pn ?em ?st ?se " +
                "WHERE {?r user:firstname ?fn . " +
                "       ?r user:lastname ?ln . " +
                "       ?r user:login ?lg . " +
                "       ?r user:password ?pw . " +
                "       ?r user:adress ?ad . " +
                "       ?r user:phone ?pn . " +
                "       ?r user:email ?em . " +
                "       ?r user:status ?st . " +
                "       ?r user:state ?se ." +
                "       FILTER(STR(?r)=\"" + lg + "\")}";

    }

    //Get all docs registed by a source in vocabulary named vocName
    public String getUserByLogin(String lg) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "SELECT DISTINCT ?p ?o " +
                "WHERE {?url ?p ?o ." +
                "       FILTER(STR(?url)=\"" + lg + "\")}";
    }


    //Get all docs registed by a source in vocabulary named vocName
    public String getUserByLogPwd(String login, String pwd) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "SELECT ?status ?email  " +
                "WHERE {?r user:login \"" + login + "\" ." +
                "       ?r user:password \"" + pwd + "\" ." +
                "       ?r user:status ?status ." +
                "       ?r user:email ?email}";
    }

    /**
     * 
     * @param url the url of the user 
     * @return The query to find if the user is subscribe 
     */
    public String userExist(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "ASK " +
                "WHERE {<" + url + "> ?p ?o }";
    }

    /**
     * 
     * @param   rsce The resource object to add to the catalog 
     * @return  The Sparql query to add rsce in the catalog 
     */
    public String addUser(User user) {
        String ntmQ = "";
        for (String ntm : user.getNotifmethod()) {
            ntmQ += " user:notifmethod  \"" + ntm + "\" ; ";
        }
        String subsQ = "";
        for (String subs : user.getSubscription()) {
            subsQ += " user:subscription  \"" + this.getSubscrip() + "#" + subs + "\" ; ";
        }

        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "INSERT  " +
                " { <" + this.getUser() + "#" + user.getLogin() + ">    user:firstname  \"" + user.getFirstname() + "\" ; " +
                "                                               user:lastname  \"" + user.getLastname() + "\" ; " +
                "                                               user:login  \"" + user.getLogin() + "\" ; " +
                "                                               user:password  \"" + user.getPassword() + "\" ; " +
                "                                               user:adress  \"" + user.getAdress() + "\" ; " +
                "                                               user:phone  \"" + user.getPhone() + "\" ; " +
                "                                               user:email  \"" + user.getEmail() + "\" ; " +
                "                                               user:status  \"" + user.getStatus() + "\" ; " +
                "                                               user:state  \"" + user.getState() + "\" ; " +
                "                                               " + ntmQ +
                "                                               " + subsQ +
                "}";
    }

    public String addSubscripId(String submitterLogin, String subsUrl) {

        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "INSERT  " +
                " { <" + this.getUser() + "#" + submitterLogin + ">    user:subscription  \"" + subsUrl + "\" ; }";
    }

    public String delSubscripId(String submitterLogin, String subsUrl) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "DELETE " +
                " { <" + this.getUser() + "#" + submitterLogin + "> user:subscription \""+subsUrl+"\" }" +
                "WHERE" +
                "{<" + this.getUser() + "#" + submitterLogin + "> user:subscription \""+subsUrl+"\" }";
    }
    /**
     * 
     * @param url The user's url
     * @return  Te sparql query to delete an user
     */
    public String delete(String url) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "DELETE " +
                " { <" + url + "> ?p ?o }" +
                "WHERE" +
                "{<" + url + "> ?p ?o}";
    }

    /**
     * 
     * @param url The user's url
     * @param state The user's state : 0 (inactive) or 1 (active)
     * @return The RdfQuery to active ou inactive an user
     */
    public String changeState(String url, String state) {
        return "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX user:<" + this.getUser() + "s#>" +
                "MODIFY   " +
                "DELETE " +
                " { <" + url + "> user:state \"" + state + "\" }" +
                "INSERT " +
                " { <" + url + "> user:state \"" + (state.equals("0") ? "1" : "0") + "\" }";
    }

    public String getModel() {
        return model;
    }
}
