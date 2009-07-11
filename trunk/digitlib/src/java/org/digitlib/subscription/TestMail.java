/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.util.Iterator;
import java.util.Vector;
import org.digitlib.db.*;

/**
 *
 * @author robu
 */
public class TestMail {

    public static void main(String Args[]) {
        RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://localhost:3306/digitlib1?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();

        Vector<Subscription> vectSubs = SubsUtils.getAllSubs(conn);

        // Affichage...
        Iterator it = vectSubs.iterator();
        while(it.hasNext()) {
            Subscription subs = (Subscription)it.next();
            System.out.println("---------------------");
            System.out.println("Url : " + subs.getUrl());
            System.out.println("Content : " + subs.descrToString("content"));
//            System.out.println("Nature : " + subs.natureToString());
//            System.out.println("Notif : " + subs.notifToString());
            System.out.print("Parents : ");
            for (Iterator iter = subs.getParentURLs().iterator(); iter.hasNext();) {
                String url = (String)iter.next();
                System.out.print(url + " ");
            }
            System.out.println();
        }
    }
}
