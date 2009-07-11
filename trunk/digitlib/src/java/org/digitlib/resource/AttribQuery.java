/*
 * AttribQuery.java
 *
 * Created on 1 mars 2007, 16:19
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.resource;

import java.util.*;

/**
 *
 * @author nguer
 */
public class AttribQuery extends DiGraph {

    public String name;
    public List<String> queryTerms = new ArrayList();
    public String values;
    public int prefSize;
    //The others fields come from the class DiGraph

    /**
     * Creates a new instance of AttribQuery
     */
    public AttribQuery() {
    }

    public String getValues() {
        return values;
    }

    public void setValues(String values) {
        this.values = values;
    }

    public int getPrefSize() {
        return prefSize;
    }

    public void setPrefSize(int prefSize) {
        this.prefSize = prefSize;
    }

    public List<List<String>> prefBlocks() {
        List<List<String>> QB = new ArrayList();
        List<String> sources;
        List<String> nodes;

        do {
            sources = getSrces();
            nodes = new ArrayList();
            if (!sources.isEmpty()) {
                for (String n : sources) {
                    nodes.addAll(getV().get(n));
                }
                QB.add(nodes);
                for (String node : sources) {
                    delIncEdges(node, "R");
                }
            }
        } while ((!getV().isEmpty()) && (!sources.isEmpty()));
        return QB;
    }

    public void setPrefSize(String size) {
        try {
            this.prefSize = Integer.parseInt(size);
        } catch (Exception e) {
            this.prefSize = 0;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
