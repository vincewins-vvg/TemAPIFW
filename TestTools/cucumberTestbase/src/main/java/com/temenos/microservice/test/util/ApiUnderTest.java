package com.temenos.microservice.test.util;

public enum ApiUnderTest {
    HOLDINGS_API("HOLDINGS"),
    ENTITLEMENT_API("ENTITLEMENT"),
    MKT_CATALOG_API("MARKETING_CATALOG");

    String name;
    ApiUnderTest(String name){
        this.name = name;
    }

    public static ApiUnderTest from(String name) {
        for(ApiUnderTest prop : values()){
            if(name.equals(prop.getName())){
                return prop;
            }
        }
        throw new IllegalArgumentException("Invalid API='" + name + "'.");
    }

    public String getName(){
        return this.name;
    }


}
