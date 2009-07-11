/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import org.digitlib.db.RdfDBAccess;
import org.digitlib.subscription.*;

/**
 *
 * @author robu
 */
public class Test {

    public static void main(String Args[]) {
        RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://localhost:3306/digitlib?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();

        new SubTreeUtils(conn).printTheTree();
        //VocUtils vocUtils = new VocUtils(conn,true);
        //System.out.println(vocUtils.getCodeByLabel("ool"));
        //System.out.println(vocUtils.getNbTermes2());
    }
}
