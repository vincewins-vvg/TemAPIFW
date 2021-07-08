package com.temenos.microservice.payments.api.keycloakgenerator;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Form;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.json.JSONObject;
import org.junit.Test;

import com.temenos.microservice.framework.core.conf.Environment;

/**
 * TODO: Document me!
 *
 * @author kumarprasanth
 *
 */
public class GenerateKeyCloakTokenForMSITTest {
    String URL="";
    //@Ignore
    @Test
    public void keyCloakTokenGenerator() throws IOException, ConfigurationException {

        Properties endpointProperties = new Properties();
        endpointProperties.load(new FileInputStream(new File("src/test/resources/end-point.properties")));
        //String envKCUri = Environment.getEnvironmentVariable("KEYCLOAK_URI", "").toString();
        
//        if(Environment.getEnvironmentVariable("KeycloakURI", "").isEmpty()==false)
//        {
//        URL = (String) endpointProperties.getProperty("keyCloak_URI");
//        System.out.println("Keycloak server URI: "+URL);
//        }
//        else {
//            
//            URL = Environment.getEnvironmentVariable("KeycloakURI", "").toString();;
//            System.out.println("Keycloak server URI: "+URL);
//        } 
        
        URL = (String) endpointProperties.getProperty("keyCloak_URI");
        System.out.println("URL: "+URL);
        String client_secret=(String) endpointProperties.getProperty("keyCloak_client_secret");
        System.out.println("Client Secret: "+client_secret);
        Form form = new Form();
        form.param("grant_type", "password");
        form.param("client_id", "msfauthcode");
        form.param("username", "msuser");
        form.param("password", "123456");
        form.param("scope", "openid");
        form.param("roleId", "ADMIN");
        form.param("client_secret", client_secret);

        Client client = ClientBuilder.newClient();
       
        WebTarget target = client.target(URL);
        Entity<?> entity = Entity.form(form);

        Invocation.Builder build = target.request(MediaType.APPLICATION_FORM_URLENCODED);
        Response response = build.post(entity);
        System.out.println("Response code is: "+response.getStatus());
//        if(response.getStatus()>=400)
//        {
//            throw new RuntimeException("Keycloak server: "+URL+" cannot be reached");
//            
//        }
        
        JSONObject jsonResponse = new JSONObject(response.readEntity(String.class));
        String output = jsonResponse.getString("id_token");
       
        System.out.println("id token from Keycloak Server: "+output);

        PropertiesConfiguration configuration = new PropertiesConfiguration("src/test/resources/end-point.properties");
        configuration.setProperty("keyCloak_Authorization", output);
        configuration.save();
        

    }

}