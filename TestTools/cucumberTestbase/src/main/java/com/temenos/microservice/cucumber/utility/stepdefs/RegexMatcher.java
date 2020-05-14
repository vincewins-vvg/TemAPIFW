package com.temenos.microservice.cucumber.utility.stepdefs;

import org.hamcrest.BaseMatcher;
import org.hamcrest.Description;
import org.hamcrest.Factory;
import org.hamcrest.Matcher;

/**
 * A regular expression matcher.
 * /**
 * 
 *
 * @author mohamedasarudeen
 *
 */

public class RegexMatcher extends BaseMatcher {
    private final String regex;

    @Factory
    @SuppressWarnings("unchecked")
    public static <T> Matcher<T> matchesRegex(T operand) {
        if(operand instanceof String) {
            return new RegexMatcher(String.class.cast(operand));
        }
        throw new RuntimeException("Invalid regex operand=" + operand.toString());
    }

    private RegexMatcher(String regex) {
        this.regex = regex;
    }

    @Override
    public boolean matches(Object value) {
        return value instanceof String && ((String) value).matches(regex);
    }

    @Override
    public void describeTo(Description description) {
        description.appendText("matching regex=" + regex + " for " + description);
    }
}