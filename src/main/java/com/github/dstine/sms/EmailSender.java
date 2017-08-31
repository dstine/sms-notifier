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

public class EmailSender {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailSender.class);

    public static void main(String[] args) {
        send();
    }

    public static void send() {
        LOGGER.info("Begin");

        // https://www.digitalocean.com/community/tutorials/how-to-use-google-s-smtp-server

        String host = getEnv("SMTP_HOST");
        String username = getEnv("SMTP_USERNAME");
        String password = getEnv("SMTP_PASSWORD");
        String from = getEnv("EMAIL_FROM");
        String subject = getEnv("EMAIL_SUBJECT");
        String msgFormat = getEnv("EMAIL_MSG_FORMAT");
        String to = getEnv("EMAIL_TO");

        try {
            Email email = new SimpleEmail();
            email.setHostName(host);
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

    private static String getEnv(String key) {
        String value = System.getenv(key);
        if (value == null || "".equals(value)) {
            throw new RuntimeException(String.format("Environment variable %s must be set", key));
        }
        return value;
    }
}

