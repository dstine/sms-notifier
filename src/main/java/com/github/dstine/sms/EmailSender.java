package com.github.dstine.sms;

import java.lang.invoke.MethodHandles;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailSender {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    public static void main(String[] args) {
        send("default message");
    }

    public static void send(String msgFormat) {
        LOGGER.info("Begin");

        String host = Helpers.getEnv("SMTP_HOST");
        String username = Helpers.getEnv("SMTP_USERNAME");
        String password = Helpers.getEnv("SMTP_PASSWORD");
        String from = Helpers.getEnv("EMAIL_FROM");
        String subject = Helpers.getEnv("EMAIL_SUBJECT");
        String to = Helpers.getEnv("EMAIL_TO");

        List<String> recipients = Arrays.asList(to.replaceAll(" ", "").split(","));

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

            // Checked exceptions (EmailException) are not declared by functional interfaces
            for (String recipient : recipients) {
                email.addTo(recipient);
                LOGGER.info("Added recipient " + recipient);
            }

            email.send();
        } catch (EmailException e) {
            throw new RuntimeException(e);
        }

        LOGGER.info("End");
    }
}

