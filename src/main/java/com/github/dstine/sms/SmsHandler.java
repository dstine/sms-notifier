package com.github.dstine.sms;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.util.Map;

public class SmsHandler implements RequestHandler<Map<String, String>, Void> {

    @Override
    public Void handleRequest(Map<String, String> input, Context context) {
        context.getLogger().log("Hello" + System.lineSeparator());
        String msgFormat = input.get("msgFormat");
        context.getLogger().log("msgFormat: " + msgFormat + System.lineSeparator());
        EmailSender.send(msgFormat);
        context.getLogger().log("Goodbye" + System.lineSeparator());
        return null;
    }
}

