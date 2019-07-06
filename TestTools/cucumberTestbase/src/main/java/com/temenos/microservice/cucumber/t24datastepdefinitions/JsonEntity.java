package com.temenos.microservice.cucumber.t24datastepdefinitions;

import java.util.Map;

import org.springframework.stereotype.Component;

/**
 * TODO: Document me!
 *
 * @author mohamedasarudeen
 *
 */

@Component
public class JsonEntity {
    
    private Map<String, String> json;

    /**
     * @return the json
     */
    public Map<String, String> getJson() {
        return json;
    }

    /**
     * @param json the json to set
     */
    public void setJson(Map<String, String> json) {
        this.json = json;
    }


}
