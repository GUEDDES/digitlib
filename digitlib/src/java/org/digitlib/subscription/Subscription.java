/*
 * NoTaxoRegister.java
 *
 * Created on 1 novembre 2006, 16:46
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.util.*;
import com.hp.hpl.jena.query.*;
import java.util.ArrayList;
import org.digitlib.ConfigQueries;
import org.digitlib.db.RdfDBAccess;
import org.digitlib.user.User;
import org.digitlib.vocabulary.Vocabulary;

/**
 * This class allows to manage a subscription. It will be used by the notification service to inform users about resources change (Modification, adding, deletion).
 * @author nguer@lri.fr
 *
 */
public class Subscription {

    private String url = "";
    private Vocabulary voc;
    private String nature = "";
    private List<String> submitter = new ArrayList<String>();
    private String state = ""; //if the resource is active or inactive
    private SubsQueries query = new SubsQueries();
    RdfDBAccess conn = new RdfDBAccess();
    private Map<String, List<String>> resAttrib = new HashMap();
    private Vector<String> parentURLs; // Contains URLs of parents subscriptions
    private String login = "";
    private SubTreeUtils substree;
    private List<String> contentTermsIds = new ArrayList<String>();

    /** Creates a new instance of NoTaxoRegister */
    public Subscription() {
        parentURLs = new Vector<String>();
    }

    public Subscription(RdfDBAccess conn) {
        this();
        this.conn = conn;
        this.substree = new SubTreeUtils(conn);
    }

    /**
     * Create a new subscription instance
     * @param attr A map containing subscription values
     * @param conn A rdf database connexion
     * @param locale a language
     */
    public Subscription(Map<String, String> attr, RdfDBAccess conn, Locale locale) {
        this(conn);
        query = new SubsQueries(locale);
        this.voc = new Vocabulary(attr.get("vocname"), conn);
        this.nature = attr.get("nature");

        this.submitter = query.stringToList(attr.get("submitter"));

        this.state = attr.get("state"); //if the resource is active or inactive
        //this.notifMethod = query.stringToList(attr.get("notifmethod"));   //resource type
        this.login = attr.get("login");
        this.url = attr.get("url");//query.getSubscrip() + "#" + this.login + "_" + new Date().getTime();
        String tab[] = attr.get("resnotifattrib").split("-");
        for (int i = 0; i < tab.length; i++) {
            String notifAttrib = tab[i];
            if ("content".equals(notifAttrib)) {
                //Set the IDs as content
                resAttrib.put("content", this.voc.labelsToIs(attr.get("content")));
            //resAttrib.put("content", this.voc.split(attr.get("content")));
            //System.out.println("new sub : " + attr.get("content"));
            } else {
                resAttrib.put(notifAttrib, query.stringToList(attr.get(notifAttrib)));
            }
        }
    }

    /**
     * Create a new subscription instance
     * @param url A subscription's url
     * @param conn A rdf database connexion
     */
    public Subscription(String url, RdfDBAccess conn) {
        this(conn);
        Map<String, String> resAttr = new HashMap();

        try {
            ConfigQueries cquery = new ConfigQueries();
            ResultSet result = conn.execSelectQuery(cquery.getConfigParams("resnotifattrib"), cquery.getModel());
            while (result.hasNext()) {
                QuerySolution rb = result.nextSolution();
                String attr = rb.get("attr").toString();
                resAttrib.put(attr, new ArrayList());
            }
        } catch (Exception e) {
            System.out.print("Exception : " + e);
        }
        //this.login = url;
        this.url = url;//query.getSubscrip()+"#"+this.login+"_"+new Date().getTime();
        ResultSet result = this.conn.execSelectQuery(query.getSubs(this.url), query.getModel());
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String tab[] = rb.get("p").toString().split("/|#");
            String p = tab[tab.length - 1];
            String o = rb.get("o").toString();
            if (resAttrib.containsKey(p)) {
                if ("content".equals(p)) {
                    resAttrib.put(p, this.substree.getTermCodesFromNode(o));
                } else {
                    resAttrib.get(p).add(o);
                }
            } else if ("submitter".equals(p)) {
                this.submitter.add(o);
            } else if ("parentname".equals(p)) {
                this.parentURLs.add(o);
            } else {
                resAttr.put(p, o);
            }
        }

        this.nature = resAttr.get("nature");
        this.state = resAttr.get("state");
        this.voc = new Vocabulary(resAttr.get("vocname"), this.conn);
    }

    /**
     * Create a new subscription instance
     * @param url A subscription's url
     * @param conn A rdf database connexion
     * @param locale a language
     */
    public Subscription(String url, RdfDBAccess conn, Locale locale) {
        this(url, conn);
        query = new SubsQueries(locale);
    }

    /**
     *
     * @return Check if a subscription exists and return its url and null otherwise
     */
    public String getSubsUrl() {
        //get content url from substree. descrUrl == null if not found
        SubTreeUtils subMem = new SubTreeUtils(conn, true);
        String descrUrl = subMem.getSubsContentUrl(this);
        //If they exist then check if a subscription with these url exists
        String subsUrl = null;
        ResultSet result = this.conn.execSelectQuery(this.getQuery().getSubsUrl(this, descrUrl), this.getQuery().getModel());
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            subsUrl = rb.get("r").toString();
        }
        return subsUrl;
    }

    public void addSubmitter(String subsUrl, String login) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.addSubmitter(subsUrl, login), this.query.getModel());
    }

    public void delSubmitter(String subsUrl, String login) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.delSubmitter(subsUrl, login), this.query.getModel());
    }

    public boolean subsContainsUser(String subsUrl, String login) {
        return this.conn.execAskQuery(this.getQuery().subsContainsUser(subsUrl, login), this.getQuery().getModel());

    }

    public boolean subsContainsUser(String subsUrl) {
        return this.conn.execAskQuery(this.getQuery().subsContainsUser(subsUrl), this.getQuery().getModel());

    }

    public boolean subsContainsDistinctUser(String subsUrl, String login) {
        return this.conn.execAskQuery(this.getQuery().subsContainsDistinctUser(subsUrl, login), this.getQuery().getModel());

    }

    /**
     * Allows to add the subscription instance in the Rdf database
     * @return true if it's done false otherwise
     */
    public String test() {
        String descrUrl = substree.getSubsContentUrl(this);
        return descrUrl;
    }

    public boolean addSubscription() {
        double timeDepart = new Date().getTime();
        String subsUrl = getSubsUrl();//Find a subscription with these descriptions
        System.out.println("Temps de calcul de la sub contenant le content (ms) : " + (new Date().getTime() - timeDepart));
        if (subsUrl != null) {//If it's found
            if (!subsContainsUser(subsUrl, this.login)) {//If the subscription dosen't contain the user login
                timeDepart = new Date().getTime();
                addSubmitter(subsUrl, this.login);                     //Add submitter to the subscription
                new User(this.conn).addSubscripId(login, subsUrl);//Add subscription id to user
                System.out.println("Temps d'insertion d'un nouveau submitter (ms) : " + (new Date().getTime() - timeDepart));
                return true;
            } else {
                return false;
            }
        } else {
            String contUrl = null;
            if (!getResAttrib().get("content").isEmpty()) {
                timeDepart = new Date().getTime();
                contUrl = substree.insertSubsInTree(this, login);
                System.out.println("Temps d'insertion dans l'arbre (ms) : " + (new Date().getTime() - timeDepart));
            }
            this.conn.execUpdateQuery(this.getQuery().addSubscription(this, contUrl), this.getQuery().getModel());
            new User(this.conn).addSubscripId(login, url);//After we add subscription id to user
            System.out.println("Subscription " + this.url + " ajoutée.");
            //Pourquoi rappeler insertSubsInTree ?
            //new SubTreeUtils(conn).insertSubsInTree(this, this.login);
            return true;
        }
    }

    /**
     * Activate or disactivate the subscription instance to users access
     * @param url The url of the subscription 
     * @param value actual state of the subscription
     */
    public void activateSubscription(String subsUrl, String value) {
        this.conn.execUpdateQuery(this.getQuery().changeState(subsUrl, value), this.getQuery().getModel());
    }

    public void updateSubscription() {
        if (subsContainsDistinctUser(this.url, this.login)) {//If the subscription is used by an other user
            deleteSubscription(this.url); //Delete him from it
            this.url = query.getSubscrip() + "#" + login + "_" + new Date().getTime();//Create a new one
            addSubscription();
        } else {//He's the only user using this subscription
            deleteSubscription(url);
            addSubscription();
        }
    }

    /**
     * Delete the subscription instance from Rdf database
     * @param url The url of the subscription to delete
     */
    public void deleteSubscription(String subsUrl) {//Delete resource from the model
        if (subsContainsUser(subsUrl, this.login)) {//If the subscription contains the user login
            delSubmitter(subsUrl, this.login);
            new User(this.conn).delSubscripId(login, subsUrl);
        //return "ok";
        } else {
            return;
        }
        //No user uses the subscription subsUrl
        if (!subsContainsUser(subsUrl)) {
            String descrUrl = substree.getNodeURI(subsUrl); //Get the id of the content description
            //remove the subscription from the tree
            substree.removeSubFromNode(subsUrl, descrUrl);
            //delete the subscription
            this.conn.execUpdateQuery(this.query.deleteSubscription(subsUrl), this.query.getModel());
            //if its content id is not used
            if (!contentIsUsed("content", descrUrl)) {
                substree.deleteNode(descrUrl);
            }
        //return "ok3";
        }
    //return "fin";
    }

    public boolean contentIsUsed(String notifAttrib, String contUrl) {
        return conn.execAskQuery(query.existContent(notifAttrib, contUrl), query.getModel());
    }

    /**
     * Transform a description field values to a string
     * @param attr the name of the subscription attribute
     * @return A string
     */
    public String descrToString(String attr) {
        String ch = "";
        for (String tm : this.getResAttrib().get(attr)) {
            ch += tm + " ";
        }
        return ch;
    }

    public String descriptionToString(String contUrl) {
        ResultSet result = conn.execSelectQuery(getQuery().contentTerm(resAttrib.get(contUrl).get(0)), getQuery().getModel());
        String cont = "";
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            cont += rb.get("o").toString().split("#")[1] + " ";
        }
        return cont;
    }

    public List<String> descriptionToList(String contUrl) {
        ResultSet result = conn.execSelectQuery(getQuery().contentTerm(contUrl), getQuery().getModel());
        List<String> cont = new ArrayList();
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            cont.add(rb.get("o").toString().split("#")[1]);
        }
        return cont;
    }

    public Vocabulary getVoc() {
        return voc;
    }

    public List<String> getSubmitter() {
        return submitter;
    }

    public String getState() {
        return state;
    }

    public String getUrl() {
        return url;
    }

    public String getNature() {
        return nature;
    }

    /**
     * @return the resAttrib
     */
    public Map<String, List<String>> getResAttrib() {
        return resAttrib;
    }

    /**
     * @return the parentURLs
     */
    public Vector<String> getParentURLs() {
        return parentURLs;
    }

    /**
     * @return the query
     */
    public SubsQueries getQuery() {
        return query;
    }

    /**
     * @return the login
     */
    public String getLogin() {
        return login;
    }

    /**
     * @param login the login to set
     */
    public void setLogin(String login) {
        this.login = login;
    }

    /**
     * @return the contentTermsIds
     */
    public List<String> getContentTermsIds() {
        return contentTermsIds;
    }

    /**
     * @param contentTermsIds the contentTermsIds to set
     */
    public void setContentTermsIds(List<String> contentTermsIds) {
        this.contentTermsIds = contentTermsIds;
    }
}
