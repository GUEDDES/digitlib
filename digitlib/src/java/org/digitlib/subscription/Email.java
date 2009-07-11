/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import org.apache.commons.mail.SimpleEmail;

/**
 *
 * @author robu
 */
public class Email {

    private static final String HOST = "smtp.free.fr";
    private static final String USER = "digitlib";
    private static final String PASS = "digitlib";
    private static final String FROM = "digitlib@free.fr";
    private static final String FROM_NAME = "Digitlib Notifier";

    public void send(String email, String subject, String message) throws Exception {
        SimpleEmail simpleEmail = new SimpleEmail();
        simpleEmail.setAuthentication(Email.USER, Email.PASS);
        simpleEmail.setHostName(Email.HOST);
        simpleEmail.addTo(email);
        simpleEmail.setFrom(Email.FROM, Email.FROM_NAME);
        simpleEmail.setSubject(subject);
        simpleEmail.setMsg(message);
        simpleEmail.send();
    }
}
