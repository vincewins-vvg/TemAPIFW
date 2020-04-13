package com.temenos.microservice.test.db;

public enum PartyDBFields {

OLD_PARTY_ID("partyid"),
PARTY_ID("identifierNumber"),
LEGAL_ENTITY_ID("legalentityid");

    private String name;

    PartyDBFields(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
