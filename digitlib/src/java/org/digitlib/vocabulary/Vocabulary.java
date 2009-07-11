/*
 * NoTaxoRegister.java
 *
 * Created on 1 novembre 2006, 16:46
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.vocabulary;

import java.util.*;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;
import org.digitlib.db.RdfDBAccess;

/**
 *
 * @author nguer
 */
public class Vocabulary {

    private String url = "";
    private String name = "";
    private String language = "";
    private String state = "";
    private String type = "";
    VocQueries query = new VocQueries();
    RdfDBAccess conn = new RdfDBAccess();

    /** Creates a new instance of NoTaxoRegister */
    public Vocabulary() {
    }

    public Vocabulary(RdfDBAccess conn) {
        this.conn = conn;
    }

    public Vocabulary(String vocName, RdfDBAccess conn) {
        this(conn);
        this.name = vocName;
        ResultSet result = this.conn.execSelectQuery(query.getVocByName(vocName), query.getModel());
        if (result.hasNext()) {
            while (result.hasNext()) {
                QuerySolution rb = result.nextSolution();
                this.url = rb.get("uri").toString();
                this.language = rb.get("vl").toString();
                this.state = rb.get("vs").toString();
                this.type = rb.get("vt").toString();
            }
        }
    }

    public Vocabulary(Map<String, String> attr, RdfDBAccess conn) {
        this(conn);
        this.setUrl(attr.get("url"));
        this.setName(attr.get("name"));
        this.setLanguage(attr.get("language"));
        this.setState(attr.get("state"));
        this.setType(attr.get("type"));
    }

    public ResultSet getVocByName(String vocName) {
        return this.conn.execSelectQuery(query.getVocByName(vocName), query.getModel());
    }

    public boolean termExist(String term) {
        return this.conn.execAskQuery(query.termExist(this, term), query.getModel());

    }

    public String getLabelOfIb(String id) {
        Resource r = conn.getModel(query.getModel()).createResource(this.url+"#"+id);
        Property p = conn.getModel(query.getModel()).createProperty("http://www.w3.org/2000/01/rdf-schema#label");
        NodeIterator iter = conn.getModel(query.getModel()).listObjectsOfProperty(r, p);
        String label = null;
        while (iter.hasNext()) {
            label = iter.nextNode().toString();
        }
        return label;
    }

    public String getIdOfLabel(String label) {
        VocQueries vq =new VocQueries();
        Property p = conn.getModel(vq.getModel()).createProperty("http://www.w3.org/2000/01/rdf-schema#label");
        RDFNode node =  conn.getModel(vq.getModel()).createLiteral(label);
        ResIterator iter = conn.getModel(vq.getModel()).listResourcesWithProperty(p, node);
        String termId = null;
        while (iter.hasNext()) {
            termId = iter.nextResource().toString();

        }
        return termId;
    }

    /**
     * 
     * @param url The url of the vocabulary to activate
     * @param value Its actual state value
     */
    public void activate(String url, String value) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.changeState(url, value), this.query.getModel());
    }

    /**
     *
     * @param url The url of the vocabulary to delete
     */
    public void delete(String url) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.delete(url), this.query.getModel());

    }

    /**
     * 
     * @return FALSE if the vocabulary is already in the catalog and otherwise return TRUE after added it in the catalog.
     */
    public boolean add() {
        //
        if (this.conn.execAskQuery(query.vocExist(this.url, this.name), this.query.getModel())) //return "<b>Registration is impossible</b><br /><br />This document is already registed!";
        {
            return false;
        } else {
            this.conn.execUpdateQuery(this.query.insert(this), this.query.getModel());
            return true;
        }
    }

    /**
     * 
     * @param url the url of the vocabulary to update
     */
    public void update(String url) {
        delete(url);
        add();
    }

    public boolean addTerm(String term, String parent) {
        if (this.conn.execAskQuery(this.query.termExist(this, term), this.query.getModel())) {
            return false;
        } else {
            this.conn.execUpdateQuery(this.query.addTerm(this, term, parent), this.query.getModel());
            return true;
        }
    }

    public void deleteTerm(String term) {//Delete resource from the model
        if (!this.getType().equals("2")) {
            this.conn.execUpdateQuery(this.query.deleteTerm(this, term), this.query.getModel());
        } else {
            ResultSet result = this.conn.execSelectQuery(query.getTermSuccessors(this, term), query.getModel());
            while (result.hasNext()) {
                QuerySolution rb = result.nextSolution();
                String succ = rb.get("succ").toString().split("#")[1];
                deleteTerm(succ);
            }
            this.conn.execUpdateQuery(this.query.deleteTerm(this, term), this.query.getModel());
        }
    }

    public String updateTerm(String term, String parent, String newTerm, String newParent) {

        if ("".equals(term) || "".equals(newTerm) || (term.equals(newTerm) && parent.equals(newParent))) {
            return "Nothing to update !";
        }

        if (!term.equals(newTerm) && (this.conn.execAskQuery(this.query.termExist(this, newTerm), this.query.getModel()))) {
            return "The new term's name must not already be in the vocabulary";
        }

        if ("1".equals(this.getType())) {
            if (this.conn.execAskQuery(this.query.termExist(this, newTerm), this.query.getModel())) {
                return "The new term musn't already be in the vocabulary";
            } else {
                this.conn.execUpdateQuery(this.query.updateTerm(this, term, "", newTerm, ""), this.query.getModel());
                return "Update is succefully done !";
            }
        }

        if ("2".equals(this.getType())) {
            this.conn.execUpdateQuery(this.query.updateTerm(this, term, parent, newTerm, newParent), this.query.getModel());

            //Update the parent value of all successors of term
            if (!term.equals(newTerm)) {
                ResultSet result = this.conn.execSelectQuery(query.getTermSuccessors(this, term), query.getModel());
                while (result.hasNext()) {
                    QuerySolution rb = result.nextSolution();
                    String succ = rb.get("succ").toString().split("#")[1];
                    this.conn.execUpdateQuery(this.query.updateTermParent(this, succ, newTerm), this.query.getModel());
                }

            }
            return "Update is succefully done !";
        }
        return "No update effect !";
    }

    public String getTermParent(String term) {
        ResultSet result = this.conn.execSelectQuery(query.getTermParent(this, term), query.getModel());
        String parent = "";
        if (result.hasNext()) {
            while (result.hasNext()) {
                QuerySolution rb = result.nextSolution();
                parent = rb.get("parent").toString();
            }
        }
        return parent;
    }

    public List<String> split(String descrip) {
        List<String> tab = new ArrayList();
        String[] terms = descrip.split(" ");
        if ("0".equals(this.type)) {
            for (int i = 0; i < terms.length; i++) {
                tab.add(terms[i]);
            }
        } else {
            for (int i = 0; i < terms.length; i++) {
                if (termExist(terms[i])) {
                    tab.add(terms[i]);
                }
            }
        }
        return tab;
    }

    /**
     *
     * @param descrip content set of terms separed by scape ex: java c++
     * @return the list of id corresponding of the terms in description
     */
    public List<String> labelsToIs(String descrip) {
        List<String> tab = new ArrayList();
        String[] terms = descrip.split(" ");
        if ("0".equals(this.type)) {
            for (int i = 0; i < terms.length; i++) {
                tab.add(terms[i]);
            }
        } else {
            for (int i = 0; (i < terms.length); i++) {
                if(terms[i].length()==0)
                    continue;
                String termId = getIdOfLabel(terms[i]);
                if (termId != null) {
                    tab.add(termId);
                }
            }
        }
        return tab;
    }

    public List<String> idsToLabels(String descrip) {
        List<String> tab = new ArrayList();
        String[] ids = descrip.split(" ");
        if ((ids.length == 1) && "".equals(ids[0])) {
            return tab;

            
        }
        for (int i = 0; i < ids.length; i++) {
            String termId = getLabelOfIb(ids[i]);
            if (termId != null) {
                tab.add(termId);
            }
        }
        return tab;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
