package com.temenos.microservice.test.db;

public enum PartyDBFields {

PARTY_ID("partyid"),
LEGAL_ENTITY_ID("legalentityid");

    private String name;

    PartyDBFields(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
