package com.temenos.microservice.payments.cucumber;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import com.temenos.useragent.cucumber.config.EndPointConfiguration;

/**
 * 
 * T24EndPointConfiguration To add T24 related configurations
 * 
 * <p>
 * Add {@link @PropertySources PropertySources} only if there is an additional
 * property file other than <b>end-point.properties</b>
 * </p>
 * 
 * @#Author mohamedasarudeen
 *
 */
@Configuration
public class MSEndPointConfiguration extends EndPointConfiguration {

    private List<String> users;
    private List<String> passwords;
  
  
    @Value("${URI}")
    public void setEndpointUri(String endpointUri) {
        /*  URI gets sets only in the AWS environment. In case of docker, value from end.point properties */
         String uri = System.getProperty("URI");
         if (uri == null) {            
             uri = endpointUri;
         }
        super.setEndpointUri(uri);
        
        
        System.out.println("Endpoint URI set To " + Optional.ofNullable(endpointUri).orElse(""));
    } 
 
  
    @Value("${t24.cucumber.users}")
    private void setUsers(String users) {
        this.users = Optional.of(users).isPresent() ? Arrays.asList(users.split(",")) : new ArrayList<String>();
    }

    @Value("${t24.cucumber.passwords}")
    private void setPasswords(String passwords) {
        this.passwords = Optional.of(passwords).isPresent() ? Arrays.asList(passwords.split(","))
                : new ArrayList<String>();
    } 

      public String getEndpointUri() {
        String uri = super.getEndpointUri();
        if (!uri.endsWith("/")) {
            return uri;
        } else {
            return uri + "/";
        }
    }
   
     public String getUserName(String userName) {
        if (users.contains(userName)) {
            return userName;
        } else {
            throw new IllegalArgumentException("User not configured : " + userName);
        }
    }

    public String getPassword(String userName) {
        int userIndex = users.indexOf(userName);
        if (userIndex != -1 && userIndex < passwords.size()) {
            return passwords.get(userIndex);
        } else {
            throw new IllegalArgumentException("Password not configured for User: " + userName);
        }
    }

}
