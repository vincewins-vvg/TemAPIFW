package com.temenos.microservice.cucumber.t24datastepdefinitions;

import java.io.IOException;
import java.util.Random;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.useragent.cucumber.config.EndPointConfiguration;
import com.temenos.useragent.cucumber.config.StepDefinitionConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.cucumber.steps.HeaderStepDefs;
import com.temenos.useragent.cucumber.steps.InteractionSessionStepDefs;
import com.temenos.useragent.cucumber.steps.UrlStepDefs;
import com.temenos.useragent.generic.internal.DefaultEntityWrapper;
import com.temenos.useragent.generic.internal.EntityHandler;
import com.temenos.useragent.generic.internal.EntityWrapper;
import com.temenos.useragent.generic.mediatype.PlainTextEntityHandler;

import cucumber.api.java8.En;

/**
 * TODO: Document me!
 *
 * @author soundaryaa
 *
 */
public class StepdefinitionforUniqueValue implements En {

    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;
    @Autowired
    private InteractionSessionStepDefs interactionSessionStepDefs;
    @Autowired
    private UrlStepDefs urlStepDefs;
    @Autowired
    private HeaderStepDefs headerStepDefs;

    @SuppressWarnings("unchecked")
    public StepdefinitionforUniqueValue(StepDefinitionConfiguration stepConfig, EndPointConfiguration endPointConfig) {

        Given("^set json payload unique body value for property path \"([^\"]*)\" with payload \"([^\"]*)\"$",
                (String path, String payloadFile) -> {
                    createEntryWithPayload(path, payloadFile);
                });

    }

    public void createEntryWithPayload(String path, String payloadFile) throws IOException {
        createInteractionSession();

        String payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(payloadFile));
        JSONObject test = new JSONObject(payload);
       
        JSONObject testBody = test.getJSONObject("body").put(path,
                "C".concat(setBundleUniqueValue("", "5", "alphanumeric")));
        // test.put("", "C".concat(setBundleUniqueValue("", "5",
        // "alphanumeric")));
        test.put("body", testBody);
        EntityHandler handler = new PlainTextEntityHandler(test.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        cucumberInteractionSession.use(entity);
       

    }

    public void createInteractionSession() {
        interactionSessionStepDefs.createSession();
        interactionSessionStepDefs.setDefaultBasicAuthoriztion();
        interactionSessionStepDefs.setDefaultMediaType();
    }

    private EntityWrapper getRequestPayloadWithMandatoryFieldsSet(String fileName) {
        String payload = "";
        try {
            payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(fileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject jsonPayload = new JSONObject(payload);
        EntityHandler handler = new PlainTextEntityHandler(jsonPayload.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }

    public String setBundleUniqueValue(String key, String number, String type) {

        String expected = null;
        int numb = Integer.parseInt(number);
        if (type.matches("alphabet")) {

            String alphabet_list = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            expected = "";
            Random random = new Random();

            for (int i = 0; i < numb; i++) {
                char ch = alphabet_list.charAt(random.nextInt(26));
                expected += ch;
            }
        } else if (type.matches("numeric")) {

            String number_list = "1234567890";
            expected = "";
            Random random = new Random();
            for (int i = 0; i < numb; i++) {
                char ch = number_list.charAt(random.nextInt(10));
                expected += ch;
            }
        } else if (type.matches("alphanumeric")) {

            String alphanumeric_list = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            expected = "";
            Random random = new Random();
            for (int i = 0; i < numb; i++) {
                char ch = alphanumeric_list.charAt(random.nextInt(36));
                expected += ch;
            }
        }

        return expected;

    }

}
