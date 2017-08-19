package com.github.dstine.sms;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SmsSender {

    private static final Logger LOGGER = LoggerFactory.getLogger(SmsSender.class);

    public static void main(String[] args) {
        send();
    }

    public static void send() {
        LOGGER.info("Begin");

        // https://www.digitalocean.com/community/tutorials/how-to-use-google-s-smtp-server

        String username = System.getenv("SMTP_USERNAME");
        String password = System.getenv("SMTP_PASSWORD");
        String from = System.getenv("EMAIL_FROM");
        String subject = System.getenv("EMAIL_SUBJECT");
        String msgFormat = System.getenv("EMAIL_MSG_FORMAT");
        String to = System.getenv("EMAIL_TO");

        try {
            Email email = new SimpleEmail();
            email.setHostName("smtp.gmail.com");
            email.setSmtpPort(465);
            email.setAuthenticator(new DefaultAuthenticator(username, password));
            email.setSSLOnConnect(true);
            email.setFrom(from);
            email.setSubject(subject);
            LocalTime lt = LocalTime.now(ZoneId.of("America/New_York")).truncatedTo(ChronoUnit.MINUTES);
            email.setMsg(String.format(msgFormat, lt));
            email.addTo(to);
            email.send();
        } catch (EmailException e) {
            throw new RuntimeException(e);
        }

        LOGGER.info("End");
    }
}

