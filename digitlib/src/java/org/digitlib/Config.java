package org.digitlib;
/*
 * Includes.java
 *
 * Created on 9 février 2006, 11:11
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

import java.util.*;
import java.util.regex.Pattern;
import org.digitlib.db.RdfDBAccess;
import com.hp.hpl.jena.rdf.model.*;

/**
 *
 * @author nguer 
 */
public class Config {

    private String dataLoc;
    private String config;
    private String dc;
    private String res;
    private String user;
    private String voc;
    private String term;
    private String subscrip;
    private String appWebDir;
    private Map<String, String> prefixUrl = new HashMap();//Nature of the subscription
    private Map<String, String> resType = new HashMap();
    private Map<String, String> vocabType = new HashMap();
    private Map<String, String> langArray = new HashMap();
    private Map<String, String> notifArray = new HashMap();
    private Map<String, String> natArray = new HashMap();
    RdfDBAccess conn = new RdfDBAccess();
    private String vocName;

    /**
     * Create a new Config instance
     */
    public Config() {
        ResourceBundle lg = ResourceBundle.getBundle("org/digitlib/lang");
        this.setDataLoc(lg.getString("dataLoc"));
        this.setConfig(getDataLoc() + "config.rdf");
        this.setDc("http://purl.org/dc/elements/1.1/");
        this.setRes(getDataLoc() + "resources.rdf");
        this.setUser(getDataLoc() + "users.rdf");
        this.setVoc(getDataLoc() + "vocabularies.rdf");
        this.setTerm(getDataLoc() + "vocterms.rdf");
        this.setSubscrip(getDataLoc() + "subscriptions.rdf");

        this.setAppWebDir(lg.getString("appWebDir"));


        prefixUrl.put("dataLoc", dataLoc);
        prefixUrl.put("config", dataLoc + "config.rdf");
        prefixUrl.put("dc", "http://purl.org/dc/elements/1.1/");
        prefixUrl.put("res", dataLoc + "resources.rdf");
        prefixUrl.put("user", dataLoc + "users.rdf");
        prefixUrl.put("voc", dataLoc + "vocabularies.rdf");
        prefixUrl.put("subscrip", dataLoc + "subscriptions.rdf");

    }

    /**
     * Create a new Config instance
     * @param locale: the locale language
     */
    public Config(Locale locale) {
        this();
        ResourceBundle lg = ResourceBundle.getBundle("org/digitlib/lang", locale);
        resType.put("0", "all");
        resType.put("1", "document");
        resType.put("2", "image");
        resType.put("3", "audio");
        resType.put("4", "video");

        vocabType.put("0", "Non controlled");
        vocabType.put("1", "controlled without taxonomy");
        vocabType.put("2", "controlled with taxonomy");

        langArray.put("en_US", "English");
        langArray.put("fr_FR", "Français");
        langArray.put("wo_SN", "Wolof");

        notifArray.put("0", "Email");
        notifArray.put("1", "Rss");

        natArray.put("0", "Modification");
        natArray.put("1", "Insertion");
        natArray.put("2", "Removing");
    }

    /**
     *
     * @param conn a connexion to rdf database
     */
    public Config(RdfDBAccess conn) {
        this();
        this.conn = conn;
    }

    public String[] split(String str) {
        Pattern p = Pattern.compile("[\\W\\s]+");
        String[] tab = p.split(str);
        if ((tab.length == 1) && tab[0] == "") {
            tab = null;
        }
        return tab;
    }

    /**
     * 
     * @param tab An array
     * @return A string from tab
     */
    public String arrayToString(String[] tab) {
        String ch = "";
        for (int i = 0; i < tab.length; i++) {
            ch += tab[i] + " ";
        }
        return ch;
    }

    /**
     *
     * @param tab An array
     * @return A string by concating the table elements
     */
    public List<String> arrayToList(String[] tab) {
        List<String> ch = new ArrayList();
        for (int i = 0; i < tab.length; i++) {
            ch.add(tab[i]);
        }
        return ch;
    }

    /**
     *
     * @param str a String
     * @return A list by spliting str
     */
    public List<String> stringToList(String str) {
        String[] tab = str.split(" ");
        List<String> p = new ArrayList();
        if((tab.length==1)&&"".equals(tab[0]))
            return p;
        for (int i = 0; i < tab.length; i++) {
            if (!"".equals(tab[i])) {
                p.add(tab[i]);
            }
        }
        return p;
    }

    /**
     *
     * @param lt a list of string
     * @return a string by concating the list's values
     */
    public String listToString(List<String> lt) {
        String ch = "";
        for (String m : lt) {
            ch += m + " ";
        }
        if ("".equals(ch)) {
            ch = "&nbsp;";
        }
        return ch;
    }

    public String[] split(String str, String chr) {
        Pattern p = Pattern.compile(chr);
        String[] tab = p.split(str);
        return tab;
    }

    public HashSet splith(String str, String chr) {

        String tab[] = str.split(chr);
        HashSet newTab = new HashSet();
        for (int i = 0; i < tab.length; i++) {
            if (!tab[i].equals("")) {
                newTab.add(tab[i]);
            }
        }
        return newTab;
    }

    public void split(String str, String chr, HashSet newTab) {
        String tab[] = split(chr, chr);
        for (int i = 0; i < tab.length; i++) {
            if (!tab[i].equals("")) {
                newTab.add(tab[i]);
            }
        }

    }

    public String getDataLoc() {
        return dataLoc;
    }

    public void setDataLoc(String dataLoc) {
        this.dataLoc = dataLoc;
    }

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public String getDc() {
        return dc;
    }

    public void setDc(String dc) {
        this.dc = dc;
    }

    public String getRes() {
        return res;
    }

    public void setRes(String res) {
        this.res = res;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getVoc() {
        return voc;
    }

    public void setVoc(String voc) {
        this.voc = voc;
    }

    public String getTerm() {
        return term;
    }

    public void setTerm(String term) {
        this.term = term;
    }

    public String getSubscrip() {
        return subscrip;
    }

    public void setSubscrip(String subscrip) {
        this.subscrip = subscrip;
    }

    /**
     * @return the appWebDir
     */
    public String getAppWebDir() {
        return appWebDir;
    }

    /**
     * @param appWebDir the appWebDir to set
     */
    public void setAppWebDir(String appWebDir) {
        this.appWebDir = appWebDir;
    }

    /**
     * @return the prefixUrl
     */
    public Map<String, String> getPrefixUrl() {
        return prefixUrl;
    }

    /**
     * @return the resType
     */
    public Map<String, String> getResType() {
        return resType;
    }

    /**
     * @return the vocabType
     */
    public Map<String, String> getVocabType() {
        return vocabType;
    }

    /**
     * @return the langArray
     */
    public Map<String, String> getLangArray() {
        return langArray;
    }

    /**
     * @return the notifArray
     */
    public Map<String, String> getNotifArray() {
        return notifArray;
    }

    /**
     * @return the natArray
     */
    public Map<String, String> getNatArray() {
        return natArray;
    }

    /**
     * @return the vocName
     */
    public String getVocName() {
        Property p = conn.getModel("config").createProperty(config+"#vocname");
        NodeIterator iter = conn.getModel("config").listObjectsOfProperty(p);
        String vName = null;
        while (iter.hasNext()) {
            vName = iter.nextNode().toString();
        }
        return vName;
    }
}
