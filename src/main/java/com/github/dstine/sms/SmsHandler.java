package com.github.dstine.sms;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.util.Map;

import com.amazonaws.services.cloudwatch.AmazonCloudWatch;
import com.amazonaws.services.cloudwatch.AmazonCloudWatchClientBuilder;
import com.amazonaws.services.cloudwatch.model.Dimension;
import com.amazonaws.services.cloudwatch.model.MetricDatum;
import com.amazonaws.services.cloudwatch.model.PutMetricDataRequest;
import com.amazonaws.services.cloudwatch.model.PutMetricDataResult;
import com.amazonaws.services.cloudwatch.model.StandardUnit;

public class SmsHandler implements RequestHandler<Map<String, String>, Void> {

    @Override
    public Void handleRequest(Map<String, String> input, Context context) {

        context.getLogger().log("Hello" + System.lineSeparator());

        String msgFormat = input.get("msgFormat");
        context.getLogger().log("msgFormat: " + msgFormat + System.lineSeparator());
        EmailSender.send(msgFormat);

        String recipient = Helpers.getEnv("EMAIL_TO");
        String sender = Helpers.getEnv("EMAIL_FROM");
        publishCustomMetric(recipient, sender);

        context.getLogger().log("Goodbye" + System.lineSeparator());

        return null;
    }

    // Contrived example custom metric
    private void publishCustomMetric(String recipient, String sender) {
        final AmazonCloudWatch cw = AmazonCloudWatchClientBuilder.defaultClient();

        Dimension dimension = new Dimension()
            .withName("SENDER")
            .withValue(sender);

        // Convert to numeric (even though actually categorical)
        double value = Double.parseDouble(recipient.split("@")[0]);
        MetricDatum datum = new MetricDatum()
            .withMetricName("RECIPIENTS")
            .withUnit(StandardUnit.None)
            .withValue(value)
            .withDimensions(dimension);

        PutMetricDataRequest request = new PutMetricDataRequest()
            .withNamespace("CUSTOM/SMS-NOTF")
            .withMetricData(datum);

        PutMetricDataResult response = cw.putMetricData(request);
    }
}

