package com.github.dstine.sms;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.*;

public class HelpersTest {

    @Rule
    public final ExpectedException exception = ExpectedException.none();

    @Test
    public void readExistingEnvVariable() {
        String javaHome = Helpers.getEnv("JAVA_HOME");
        assertNotNull(javaHome);
        assertFalse("".equals(javaHome));
    }

    @Test
    public void readNonExistingEnvVariable() {
        exception.expect(RuntimeException.class);
        Helpers.getEnv("FOO_BAR_NOT_EXIST");
    }
}

