package com.github.dstine.sms;

public class Helpers {

    static String getEnv(String key) {
        String value = System.getenv(key);
        if (value == null || "".equals(value)) {
            throw new RuntimeException(String.format("Environment variable %s must be set", key));
        }
        return value;
    }
}

