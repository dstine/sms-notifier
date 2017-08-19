package com.github.dstine.sms;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class SmsHandler implements RequestHandler<Void, Void> {

    @Override
    public Void handleRequest(Void v, Context context) {
        context.getLogger().log("Hello");
        SmsSender.send();
        return null;
    }
}

