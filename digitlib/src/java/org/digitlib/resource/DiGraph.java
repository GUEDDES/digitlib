/*
 * DiGraph.java
 *
 * Created on 2 novembre 2007, 17:40
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.resource;

import java.util.*;
import java.util.regex.Pattern;

/**
 *
 * @author nguer
 */
public class DiGraph {

    //private List<String> V = new ArrayList();
    private Map<String, List<String>> V = new HashMap();
    private Map<String, List<String>> S = new HashMap();
    private Map<String, List<String>> P = new HashMap();
    //private boolean cyclic = false;
    private List<List<String>> cycles = new ArrayList();
    //public Map<String, List<String>> cyClasses = new HashMap();

    /** Creates a new instance of DiGraph */
    public DiGraph() {
    }

    public boolean isEmpty() {
        if (getV().isEmpty()) {
            return true;
        }
        return false;
    }

    public DiGraph(String[] V1, String[] S1, String[] P1) {
        String[] tab;// = Pattern.compile("[\\W\\s]+").split(getP().get(node));
        List<String> node = new ArrayList();
        for (int i = 0; i < V1.length; i++) {
            node = new ArrayList();
            node.add(V1[i]);
            getV().put(V1[i], node);
            tab = Pattern.compile("[\\W\\s]+").split(S1[i]);
            node = new ArrayList();
            for (int k = 0; k < tab.length; k++) {
                node.add(tab[k]);
            }
            getS().put(V1[i], node);
            node = new ArrayList();
            tab = Pattern.compile("[\\W\\s]+").split(P1[i]);
            for (int k = 0; k < tab.length; k++) {
                node.add(tab[k]);
            }
            getP().put(V1[i], node);
        }
    }

    public DiGraph clone() {
        List<String> b = new ArrayList();
        DiGraph clG = new DiGraph();
        String node;
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            b = new ArrayList(getV().get(node));
            clG.getV().put(node, b);
            b = new ArrayList(getP().get(node));
            clG.getP().put(node, b);
            b = new ArrayList(getS().get(node));
            clG.getS().put(node, b);
        }
        return clG;
    }

    public String printGraph(String msg) {
        String str = "<br><u><b>" + msg + "</b></u><br>V = ";
        String node;
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            str += node;
            str += (it.hasNext()) ? " - " : "";
        }
        str += "<br>C = ";
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            str += (getV().get(node).isEmpty()) ? "N" : getV().get(node);
            str += (it.hasNext()) ? " - " : "";
        }
        str += "<br>S = ";
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            if (getS().get(node).isEmpty()) {
                str += "N";
            } else {
                for (int k = 0; k < getS().get(node).size(); k++) {
                    str += getS().get(node).get(k) + " ";
                }
            }
            str += (it.hasNext()) ? " - " : "";
        }
        str += "<br>P = ";
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            if (getP().get(node).isEmpty()) {
                str += "N";
            } else {
                for (int k = 0; k < getP().get(node).size(); k++) {
                    str += getP().get(node).get(k) + " ";
                }
            }
            str += (it.hasNext()) ? " - " : "";
        }
        return str;
    }

    public List<String> getSrces() {
        List<String> roots = new ArrayList();
        String node;
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            if (getP().get(node).isEmpty()) {
                roots.add(node);
            }
        }
        return roots;
    }

    public List<String> getSinks() {
        List<String> leaves = new ArrayList();
        String node;
        for (Iterator<String> it = V.keySet().iterator(); it.hasNext();) {
            node = it.next();
            if (getS().get(node).isEmpty()) {
                leaves.add(node);
            }
        }
        return leaves;
    }

    public void delNode(String node) {
        getP().remove(node);
        getS().remove(node);
        getV().remove(node);
    }

    public void delIncEdges(String node, String sense) {

        if (sense.equals("L") || sense.equals("ALL")) {
            for (int k = 0; k < getP().get(node).size(); k++) {
                getS().get(getP().get(node).get(k)).remove(node);
            }
        }


        if (sense.equals("R") || sense.equals("ALL")) {
            for (int k = 0; k < getS().get(node).size(); k++) {
                getP().get(getS().get(node).get(k)).remove(node);
            }
        }
        delNode(node);
    }

    public void addEdge(String tail, String head) {
        List<String> emp = new ArrayList();
        if (!tail.equals(head)) {
            if (!getV().containsKey(tail)) {
                emp = new ArrayList();
                emp.add(tail);
                getV().put(tail, emp);
                emp = new ArrayList();
                emp.add(head);
                getS().put(tail, emp);
                emp = new ArrayList();
                getP().put(tail, emp);
            } else {
                if (!getS().get(tail).contains(head)) {
                    getS().get(tail).add(head);
                }
            }

            if (!getV().containsKey(head)) {
                emp = new ArrayList();
                emp.add(head);
                getV().put(head, emp);
                emp = new ArrayList();
                emp.add(tail);
                getP().put(head, emp);
                emp = new ArrayList();
                getS().put(head, emp);
            } else {
                if (!getP().get(head).contains(tail)) {
                    getP().get(head).add(tail);
                }
            }
        }
    }

    public boolean reduce() {
        List<String> sources, sinks;
        if (isEmpty()) {
            return true;
        }
        do {
            sinks = getSinks();
            for (String node : sinks) {
                delIncEdges(node, "L");
            }
        } while ((!getV().isEmpty()) && (!sinks.isEmpty()));

        do {
            sources = getSrces();
            for (String node : sources) {
                delIncEdges(node, "R");
            }
        } while ((!getV().isEmpty()) && (!sources.isEmpty()));

        return isEmpty();
    }

    public Map<String, List<String>> getV() {
        return this.V;
    }

    public void setV(Map<String, List<String>> V) {
        this.V = V;
    }

    public Map<String, List<String>> getS() {
        return this.S;
    }

    public void setS(Map<String, List<String>> S) {
        this.S = S;
    }

    public Map<String, List<String>> getP() {
        return this.P;
    }

    public void setP(Map<String, List<String>> P) {
        this.P = P;
    }

    public void decal() {
        if (reduce()) {
            return;
        }
        List<List<String>> paths = new ArrayList();
        List<String> succ = new ArrayList();
        List<List<String>> tmpath = new ArrayList();
        Iterator<String> it = V.keySet().iterator();
        String t = it.next();
        List<String> pp = new ArrayList();
        pp.add(t);
        paths.add(pp);
        do {
            tmpath = new ArrayList();
            for (List<String> p : paths) {
                succ = getS().get(p.get(p.size() - 1));
                for (String s : succ) {
                    if (s.equals(t)) {
                        getCycles().add(p);
                    } else if (!p.contains(s)) {
                        pp = new ArrayList(p);
                        pp.add(s);
                        tmpath.add(pp);
                    }
                }
            }
            paths = new ArrayList(tmpath);
        } while (!paths.isEmpty());
        delIncEdges(t, "ALL");
        decal();
    }

    public String printCycles(int nbvert, long rtime, boolean gc) {
        String str = "<br><u><b>Decal running time :</b></u>";
        str += "<br>Number of vertices :" + nbvert;
        str += "<br>Number of cycles :" + getCycles().size();
        str += "<br>Running time :" + rtime + " milliseconds";
        if (gc) {
            str += "<br>List of cycles :";
            for (int k = 0; k < getCycles().size(); k++) {
                str += "<br>" + getCycles().get(k);
            }
        }
        return str;
    }

    public String printCycles(String msg) {
        String str = "<br><u><b>" + msg + ":</b></u>";
        str += "<br>List of cycles :";
        for (int k = 0; k < getCycles().size(); k++) {
            str += "<br>" + getCycles().get(k);
        }
        return str;
    }

    public boolean intersect(List<String> A, List<String> B) {
        boolean find = false;
        int i = 0, j = 0;
        while ((!find) && (i < A.size())) {
            j = 0;
            while ((!find) && (j < B.size())) {
                find = (A.get(i).equals(B.get(j)));
                j++;
            }
            i++;
        }
        return find;
    }

    public void grEqCycles() {//Allows grouping the equivalent cycles
        int i = 0, j = 0;
        boolean find;
        do {
            find = false;
            j++;
            while ((!find) && (j < getCycles().size())) {
                if (intersect(getCycles().get(i), getCycles().get(j))) {
                    //append cycles.get(i) in cycles.get(j)
                    for (int k = 0; k < getCycles().get(i).size(); k++) {
                        if (!getCycles().get(j).contains(getCycles().get(i).get(k))) {
                            getCycles().get(j).add(getCycles().get(i).get(k));
                        }
                    }
                    //delete cycles.get(i) from cycles
                    getCycles().remove(getCycles().get(i));
                    find = true;
                    j = 0;
                } else {
                    j++;
                }

            }
            if (!find) {
                i++;
            }
        } while (i < getCycles().size() - 1);
    }

    public void getAcyclicGraph() {
        String nodei, nodej, nodek;
        grEqCycles();
        for (int i = 0; i < cycles.size(); i++) {
            V.put(cycles.get(i).get(0), cycles.get(i));
        }

        for (int i = 0; i < cycles.size(); i++) {
            nodei = cycles.get(i).get(0);
            S.get(nodei).removeAll(cycles.get(i));
            P.get(nodei).removeAll(cycles.get(i));
            for (int j = 1; j < cycles.get(i).size(); j++) {
                nodej = cycles.get(i).get(j);
                S.get(nodej).removeAll(cycles.get(i));
                for (int k = 0; k < S.get(nodej).size(); k++) {
                    nodek = S.get(nodej).get(k);
                    S.get(nodei).add(nodek);
                    P.get(nodek).remove(nodej);
                    P.get(nodek).add(nodei);
                }
                P.get(nodej).removeAll(cycles.get(i));
                for (int k = 0; k < P.get(nodej).size(); k++) {
                    nodek = P.get(nodej).get(k);
                    P.get(nodei).add(nodek);
                    S.get(nodek).remove(nodej);
                    S.get(nodek).add(nodei);
                }
                delNode(nodej);
            }
        }
    }

    public void setCycles(List<List<String>> cycles) {
        this.cycles = cycles;
    }

    public List<List<String>> getCycles() {
        return cycles;
    }
}
