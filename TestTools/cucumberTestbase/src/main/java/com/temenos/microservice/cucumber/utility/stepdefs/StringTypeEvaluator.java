package com.temenos.microservice.cucumber.utility.stepdefs;

import org.hamcrest.Matcher;

import com.temenos.useragent.cucumber.utils.StringEvaluator;

/**
 * {@inheritDoc}
 * 
 * <ul>
 * <b>Additional matchers</b>
 * <li>matches regex</li>
 * </ul>
 * 
 */
public class StringTypeEvaluator extends StringEvaluator {

    public Matcher<String> getMatcher(String method, String expected) {
        switch (method) {
        case "matches regex":
            return RegexMatcher.matchesRegex(expected);
        default:
            return super.getMatcher(method, expected);
        }
    }

}