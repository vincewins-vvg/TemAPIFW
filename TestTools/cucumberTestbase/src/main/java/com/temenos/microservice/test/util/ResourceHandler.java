package com.temenos.microservice.test.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Optional;

public class ResourceHandler {
    private static final String NEW_LINE = System.getProperty("line.separator");
    private static int EXPECTED_BUFFER_DATA = 8192;


    public static String readResource(String resourceName) throws IOException {
        try (InputStream inputStream = Optional.ofNullable(ResourceHandler.class.getResourceAsStream(resourceName)).orElseGet(() ->
                ClassLoader.getSystemClassLoader().getResourceAsStream(resourceName));
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
        ) {
            StringBuilder contents = new StringBuilder(EXPECTED_BUFFER_DATA);
            for (String line; (line = reader.readLine()) != null; ) {
                contents.append(line).append(NEW_LINE);
            }
            return contents.delete(contents.lastIndexOf(NEW_LINE), contents.length()).toString();
        }

    }
}
