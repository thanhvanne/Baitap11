package vn.edu.hcmute.bookstore.util;

import java.util.Properties;

import jakarta.mail.*;
import jakarta.mail.internet.*;

public class MailUtil_24110379 {

    private static final String EMAIL =
            "thanhvandz102@gmail.com";

    private static final String APP_PASSWORD =
            "ksccbhszmyzjnhqa";

    public static void sendOTP(String receiver, String otp)
            throws Exception {

        Properties props = new Properties();

        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(
                props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication
                    getPasswordAuthentication() {

                        return new PasswordAuthentication(
                                EMAIL, APP_PASSWORD);
                    }
                });

        Message message = new MimeMessage(session);

        message.setFrom(new InternetAddress(EMAIL));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(receiver));

        message.setSubject(
                "BookStore - Ma OTP kich hoat");

        message.setText(
                "Ma OTP cua ban la: " + otp
                + "\nOTP co hieu luc trong 5 phut.");

        Transport.send(message);
    }
}