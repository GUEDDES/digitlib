/*
 * User.java
 *
 * Created on 28 février 2008, 17:38
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.user;

import java.util.*;
import com.hp.hpl.jena.query.*;
import java.lang.reflect.Field;
import org.digitlib.db.RdfDBAccess;

/**
 *
 * @author nguer
 */
public class User {

    private String firstname = "";
    private String lastname = "";
    private String login = "";
    private String password = "";
    private String adress = "";
    private String phone = "";
    private String email = "";
    private String status = "";
    private String state = "";
    private List<String> notifmethod = new ArrayList();
    private List<String> subscription = new ArrayList();
    private UserQueries query = new UserQueries();
    RdfDBAccess conn = new RdfDBAccess();

    /**
     * Creates a new instance of User
     */
    public User() {
    }

    /**
     * 
     * @param conn A connection to the rdf databse
     */
    public User(RdfDBAccess conn) {
        this.conn = conn;
    }

    /**
     * 
     * @param login The login of the user
     * @param conn A connection to the rdf databse
     */
    public User(String login, RdfDBAccess conn) throws Exception {
        this(conn);
        ResultSet result = this.conn.execSelectQuery(query.getUserByLogin(query.getUser() + "#" + login), query.getModel());
        this.login = login;
        QuerySolution rb;
        while (result.hasNext()) {
            rb = result.nextSolution();
            String tab[] = rb.get("p").toString().split("/|#");
            String p = tab[tab.length - 1];
            String o = rb.get("o").toString();
            if ("notifmethod".equals(p)) {
                notifmethod.add(o);
            } else if ("subscription".equals(p)) {
                subscription.add(o.split("/|#")[1]);
            } else {
                Field f = this.getClass().getDeclaredField(p);
                if (f != null) {
                    f.set(this, o);
                }
            }

        }
    }

    /**
     * 
     * @param attr A map witch contains the attribute 's values of the user
     * @param conn A connection to the rdf databse
     */
    public User(Map<String, String> attr, RdfDBAccess conn) throws Exception {
        this(conn);
        for (Map.Entry<String, String> e : attr.entrySet()) {
            String key = e.getKey();
            String value = e.getValue();
            Field f = this.getClass().getDeclaredField(key);
            if ("notifmethod".equals(key) || "subscription".equals(key)) {
                if (f != null) {
                    f.set(this, query.stringToList(value));
                }
            } else {
                if (f != null) {
                    f.set(this, value);
                }
            }
        }

    }

    /**
     * 
     * @param login The login of the user to activate
     * @param value The actual state of the user
     */
    public void activate(String login, String value) {
        this.conn.execUpdateQuery(this.query.changeState(query.getUser() + "#" + login, value), this.query.getModel());
    }

    /**
     * 
     * @param login The login of the user to delete
     */
    public void delete(String login) {
        this.conn.execUpdateQuery(this.query.delete(query.getUser() + "#" + login), this.query.getModel());
    }

    /**
     * Add a new user in the community
     * 
     * @return False if user is already subscribe otherwise add it and return true
     */
    public boolean addUser() {
        if (this.conn.execAskQuery(query.userExist(query.getUser() + "#" + login), this.query.getModel())) //return "<b>Registration is impossible</b><br /><br />This document is already registed!";
        {
            return false;
        } else {
            this.conn.execUpdateQuery(this.query.addUser(this), this.query.getModel());
            return true;
        }
    }

    public void addSubscripId(String submitterLogin, String subsUrl) {
        this.conn.execUpdateQuery(this.query.addSubscripId(submitterLogin, subsUrl), this.query.getModel());
    }

    public void delSubscripId(String submitterLogin, String subsUrl) {
        this.conn.execUpdateQuery(this.query.delSubscripId(submitterLogin, subsUrl), this.query.getModel());
    }
    /**
     * 
     * @param url The user's url to update
     */
    public void update(String url) {
        delete(url);
        addUser();
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAdress() {
        return adress;
    }

    public void setAdress(String adress) {
        this.adress = adress;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    /**
     * @return the notifmethod
     */
    public List<String> getNotifmethod() {
        return notifmethod;
    }

    /**
     * @return the subscription
     */
    public List<String> getSubscription() {
        return subscription;
    }
}
