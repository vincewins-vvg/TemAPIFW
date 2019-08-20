/*******************************************************************************
 * Copyright © Temenos Headquarters SA 2012-2018. All rights reserved.
 ******************************************************************************/
package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static java.text.MessageFormat.format;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.*;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.Base64;
import java.util.Calendar;
import java.util.Random;
import java.util.concurrent.TimeUnit;

import org.apache.http.HttpHeaders;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.useragent.cucumber.config.EndPointConfiguration;
import com.temenos.useragent.cucumber.config.StepDefinitionConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.cucumber.transformer.ExpressionListConverter.ExpressionList;
import com.temenos.useragent.cucumber.transformer.StringListConverter.StringList;
import com.temenos.useragent.cucumber.utils.StringEvaluator;
import com.temenos.useragent.generic.Links;
import com.temenos.useragent.generic.internal.ActionableLink;

import cucumber.api.java8.En;

/**
 * T24 Generic Action Step definition
 *
 * @author mohamedasarudeen
 *
 */

public class MSGenericActionStepDefs implements En {
    
    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;
    private static String currentDate;
    private static String dateAfterIncrement;
    private static String dateAfterDecrement;
    private static String truncatedValue;
    private static String inputValue;
    private static int currentTime;
    private static String uniqueIdentifier;
    private static final String METHOD_EXCEPTION_MSG = "Link method not available {0}. Exception: {1}";
        
    public MSGenericActionStepDefs(StepDefinitionConfiguration stepConfig, EndPointConfiguration endPointConfig, StringEvaluator stringEvaluator) {
        
        And(format("^(?:I ?)*remove mulitvalue property {0}$", stepConfig.stringRegEx()), 
                (String key) -> removeMultivalueProperty(key));

        Then("^response item count should be (\\d+)$", (Integer count) -> {
            assertEquals("Item count mismatch expected " + count +
                            " actual " + cucumberInteractionSession.entities().item().count("items"),
                    count, (Integer) cucumberInteractionSession.entities().item().count("items"));
        });
        
        
        Then(format("^count of multivalue property {0} should be equal to {0}$", stepConfig.stringRegEx()), 
                (String key, String value) -> {
                    assertThat(multivaluePropertyCount(key), equalTo(value));
                });
        
        Then("^(?:I ?)*set request header username property with password values$", () -> {
            cucumberInteractionSession.header(endPointConfig.getUserName(), endPointConfig.getPassword());
                            });
        
        And("^the response item is not empty$",
                () -> assertNotNull(cucumberInteractionSession.entities().item()));
        
        And("^set timeout session for one minute$",
                () -> //Thread.sleep(60000));  
        TimeUnit.MINUTES.sleep(1));
        
        /* Examples:
         * And increment "systemDate" with value "15 days" in bundle 
         * And increment "systemDate" with value "11 months" in bundle 
         * And increment "systemDate" with value "2 years" in bundle 
         */
        
        And(format("^increment {0} with value {0} in bundle$", stepConfig.stringRegEx()),
                (String key, String value) -> incrementBundleStringValue(key, value));
        
        And(format("^decrement {0} with value {0} in bundle$", stepConfig.stringRegEx()),
                (String key, String value) -> decrementBundleStringValue(key, value));
        
        
        And(format("^set bundle {0} with unique identifier value$", stepConfig.stringRegEx()),
                (String key) -> setBundleStringValue(key));
        
        /* Examples:
         * And set bundle "uniqID" with "4" characters "alphabet" unique identifier value 
         * And set bundle "uniqID" with "7" characters "alphanumeric" unique identifier value 
         * And set bundle "uniqID" with "2" characters "numeric" unique identifier value 
         */
        
        And(format("^set bundle {0} with {0} characters {0} unique identifier value$", stepConfig.stringRegEx()),
                (String key, String number, String type) -> setBundleUniqueValue(key, number, type));
        
        /* Examples:
         * And set bundle "ResponseToken" with session link attribute "href" */
        
        
        And(format("^set bundle {0} with session link attribute {0}$", stepConfig.stringRegEx()),
                (String bundleId, String attribute) -> setBundleWithSessionLinkAttribute(bundleId, attribute));
        
        /* Examples:
         * And truncate the bundle value "MaturityDate" from startindex "0" to endindex "6" */
        
        And(format("^truncate the bundle value {0} from startindex {0} to endindex {0}$", stepConfig.stringRegEx()),
                (String bundlekey, Integer startIndex, Integer endIndex) -> truncateBundleValue(bundlekey, startIndex, endIndex));
        
        /* To handle different date related scenarios, below step definitions can be used */
        
        And(format("^(?:I ?)*set current system date value to bundle {0}$", stepConfig.stringRegEx()),
                (String key) -> currentSystemDate(key));

        And(format("^(?:I ?)*set business working day value to bundle {0}$", stepConfig.stringRegEx()),
                (String key) -> businessWorkingDays(key));

        And(format("^(?:I ?)*set next working day value to bundle {0}$", stepConfig.stringRegEx()),
                (String key) -> nextWorkingDays(key));

        And(format("^(?:I ?)*set previous working day value to bundle {0}$", stepConfig.stringRegEx()),
                (String key) -> previousWorkingDays(key));
        
        And(format("^(?:I ?)*set EncodedBasicAuth user-name {0} and password {0}$", stepConfig.stringRegEx()),
                (String userName, String password) -> {
                    setEncodedBasicAuth(userName, password);
                });
        
        And(format("^set request header key {0} with bundle value {0}$", stepConfig.stringRegEx()),
                (String key, String bundleValue) -> setHeaderWithBundleValue(key,bundleValue)); 
        
        /* Example:
         * And the enquiry payload has link with href value should contain string "enqPctCustomers()" for Rel "next"
         */
        
        And(format("^the enquiry payload has link with {0} value {4} {2}string {1} for {3} {1}$", stepConfig.linkStringRegEx(),
                stepConfig.stringRegEx(), stepConfig.modeRegEx(), stepConfig.linkGetRegEx(),
                stepConfig.stringCompareRegEx()),
                (String linkField, ExpressionList expressions, String modeVal, StringList values, String methodName,
                        String methodArg) -> {
                    String linkValue = getLinkValue(linkField, methodName,
                            methodArg);
                    stringEvaluator.evaluate(expressions, values, linkValue, stepConfig.getEnum(modeVal)).assertError();
                });
        
        Then(format("^property {0} should be equal to bundle value {0} {0} {0}$", stepConfig.stringRegEx()),
                (String key, String prefix, String bundleKey, String suffix) -> comparePropetyValueWithBundleValue(key, prefix, bundleKey, suffix));
        
    }
    
    
    
    public String getPropertyValue(String propertyKey) {
        return cucumberInteractionSession.entities().item().get(propertyKey);
    }
    
    public void comparePropetyValueWithBundleValue(String propertyKey, String prefixValue, String bundleKey, String suffixValue) {
        String keyValue = getPropertyValue(propertyKey);
        String bundleValue = prefixValue.concat(cucumberInteractionSession.scenarioBundle().getString(bundleKey)).concat(suffixValue);
        assertTrue("Values of expected property and bundle are not equal", keyValue.equals(bundleValue));
    }
    
    
    public void setBundleWithSessionLinkAttribute(String bundleId, String propertyKey) {
        cucumberInteractionSession.scenarioBundle().put(bundleId,
                cucumberInteractionSession.entities().item().get(propertyKey));
    } 
    

    public ActionableLink getLinkforRel(String rel) {
        return cucumberInteractionSession.entities().item().links().byRel(rel);
    }
    
    private String getLinkFieldValue(ActionableLink link, String targetMethod) {
        try {
            Method refMethod = link.getClass().getDeclaredMethod(targetMethod);
            return (String) refMethod.invoke(link);
        } catch (InvocationTargetException e) {
            throw new IllegalArgumentException(
                    MessageFormat.format(METHOD_EXCEPTION_MSG, targetMethod, e.getTargetException().getMessage()));
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    MessageFormat.format(METHOD_EXCEPTION_MSG, targetMethod, e.getMessage()));
        }
    }
    
    private ActionableLink getActionableLink(Links links, String methodName, String methodArg) {
        try {
            Method refMethod = links.getClass().getDeclaredMethod("by".concat(methodName), String.class);
            return (ActionableLink) refMethod.invoke(links, methodArg);
        } catch (InvocationTargetException e) {
            throw new IllegalArgumentException(
                    MessageFormat.format(METHOD_EXCEPTION_MSG, methodName, e.getTargetException().getMessage()));
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    MessageFormat.format(METHOD_EXCEPTION_MSG, methodName, e.getMessage()));
        }
    }
    
    public String getLinkValue(String targetField, String forField, String forValue) {

        Links links = cucumberInteractionSession.links();
        ActionableLink link = getActionableLink(links, forField, forValue);
        return getLinkFieldValue(link, targetField);
    }
    
    public Object setBundleUniqueValue(String key, String number, String type) {
        
        String expected = null;
        int numb = Integer.parseInt(number);
        if(type.matches("alphabet")){
            
            String alphabet_list= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            expected = "";
            Random random = new Random();
            
            for (int i = 0; i < numb; i++) {
                char ch = alphabet_list.charAt(random.nextInt(26));
                expected+=ch;
                }
            }else if(type.matches("numeric")){
             
                String number_list= "1234567890";
                expected = "";
                Random random = new Random();
                for (int i = 0; i < numb; i++) {
                    char ch = number_list.charAt(random.nextInt(10));
                    expected+=ch;
                }
            }else if(type.matches("alphanumeric")){
             
                String alphanumeric_list= "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
                expected = "";
                Random random = new Random();
                for (int i = 0; i < numb; i++) {
                    char ch = alphanumeric_list.charAt(random.nextInt(36));
                    expected+=ch;
                }
            }         
       
        return cucumberInteractionSession.scenarioBundle().put(key, expected);
    }



    public Object incrementBundleStringValue(String bundleKey, String value) throws ParseException {
        
        currentDate = (String) cucumberInteractionSession.scenarioBundle().get(bundleKey);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(sdf.parse(currentDate));
        
        StringBuffer alpha = new StringBuffer(), 
                num = new StringBuffer(), special = new StringBuffer();
        
        for (int i=0; i<value.length(); i++)
        {
            if (Character.isDigit(value.charAt(i)))
                num.append(value.charAt(i));
            else if(Character.isAlphabetic(value.charAt(i)))
                alpha.append(value.charAt(i));
            else
                special.append(value.charAt(i));
        }
        
        String updateValue = num.toString();
        String dateToUpdate = alpha.toString();
        
        if(dateToUpdate.contains("day")){
            calendar.add(Calendar.DATE, Integer.parseInt(updateValue));
            dateAfterIncrement = sdf.format(calendar.getTime());            
            
        }else if(dateToUpdate.contains("month")){
            calendar.add(Calendar.MONTH, Integer.parseInt(updateValue));
            dateAfterIncrement = sdf.format(calendar.getTime());     

        }else if(dateToUpdate.contains("year")){
            calendar.add(Calendar.YEAR, Integer.parseInt(updateValue));
            dateAfterIncrement = sdf.format(calendar.getTime()); 
          
        }; 
        
        return cucumberInteractionSession.scenarioBundle().put(bundleKey, dateAfterIncrement);    
        }
    
    public Object truncateBundleValue(String bundleKey, int startIndex, int endIndex) {

        inputValue = (String) cucumberInteractionSession.scenarioBundle().get(bundleKey);
        truncatedValue = inputValue.substring(startIndex, endIndex);  
        return cucumberInteractionSession.scenarioBundle().put(bundleKey, truncatedValue);
        
    }
    
    
    public Object decrementBundleStringValue(String bundleKey, String value) throws ParseException {
        
        currentDate = (String) cucumberInteractionSession.scenarioBundle().get(bundleKey);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(sdf.parse(currentDate));
        
        StringBuffer alpha = new StringBuffer(), 
                num = new StringBuffer(), special = new StringBuffer();
        
        for (int i=0; i<value.length(); i++)
        {
            if (Character.isDigit(value.charAt(i))){
                num.append('-');
                num.append(value.charAt(i));
            }
            else if(Character.isAlphabetic(value.charAt(i))){
                alpha.append(value.charAt(i));
            }
            else
                special.append(value.charAt(i));
        }
        
        String updateValue = num.toString();
        String dateToUpdate = alpha.toString();
        
        if(dateToUpdate.contains("day")){
            calendar.add(Calendar.DATE, Integer.parseInt(updateValue));
            dateAfterDecrement = sdf.format(calendar.getTime());            
            
        }else if(dateToUpdate.contains("month")){
            calendar.add(Calendar.MONTH, Integer.parseInt(updateValue));
            dateAfterDecrement = sdf.format(calendar.getTime());     

        }else if(dateToUpdate.contains("year")){
            calendar.add(Calendar.YEAR, Integer.parseInt(updateValue));
            dateAfterDecrement = sdf.format(calendar.getTime()); 
          
        }; 
        
        return cucumberInteractionSession.scenarioBundle().put(bundleKey, dateAfterDecrement);    
        }


    public void removeMultivalueProperty(String propertyKey) {
        cucumberInteractionSession.remove(propertyKey);
    }
    
    public String multivaluePropertyCount(String propertyKey) {
        String propertyCount = Integer.toString(cucumberInteractionSession.entities().item().count(propertyKey));
        return propertyCount;
    }
    
    public Object setBundleStringValue(String key) {
        currentTime = (int) System.currentTimeMillis();
        uniqueIdentifier = (Integer.toString(currentTime)).substring(3);
        return cucumberInteractionSession.scenarioBundle().put(key, uniqueIdentifier);
    }
    
    public Object currentSystemDate(String key) {

        LocalDate date = LocalDate.now();

        String systemDate = DateTimeFormatter.ofPattern("yyy/MM/dd").format(date);
        String currentSystemDate = systemDate.replace("/", "");
        return cucumberInteractionSession.scenarioBundle().put(key, currentSystemDate);

    }

    public Object businessWorkingDays(String key) {

        LocalDate date = LocalDate.now();
        if (date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY) {
            date = date.with(TemporalAdjusters.next(DayOfWeek.MONDAY));

        }

        String businessWorkingDays = DateTimeFormatter.ofPattern("yyy/MM/dd").format(date);
        String businessWorkingDate = businessWorkingDays.replace("/", "");
        return cucumberInteractionSession.scenarioBundle().put(key, businessWorkingDate);
    }

    public Object previousWorkingDays(String key) {

        LocalDate previousDay = LocalDate.now().minusDays(1);
        if (previousDay.getDayOfWeek() == DayOfWeek.SATURDAY || previousDay.getDayOfWeek() == DayOfWeek.SUNDAY) {
            previousDay = previousDay.with(TemporalAdjusters.previous(DayOfWeek.FRIDAY));
        }

        String previousWorkingDay = DateTimeFormatter.ofPattern("yyy/MM/dd").format(previousDay);
        String previousWorkingDate = previousWorkingDay.replace("/", "");
        return cucumberInteractionSession.scenarioBundle().put(key, previousWorkingDate);
    }

    public Object nextWorkingDays(String key) {

        LocalDate nextday = LocalDate.now().plusDays(1);
        if (nextday.getDayOfWeek() == DayOfWeek.SATURDAY || nextday.getDayOfWeek() == DayOfWeek.SUNDAY) {
            nextday = nextday.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        }

        String nextWorkingDay = DateTimeFormatter.ofPattern("yyy/MM/dd").format(nextday);
        String nextWorkingDate = nextWorkingDay.replace("/", "");
        return cucumberInteractionSession.scenarioBundle().put(key, nextWorkingDate);
    }
    
    public void setEncodedBasicAuth(String username, String password) {
        Base64.Encoder encoder = Base64.getEncoder();
        String normalString = "username:password";
        String encodedString = encoder.encodeToString(
                normalString.getBytes(StandardCharsets.UTF_8));
        cucumberInteractionSession.header(HttpHeaders.AUTHORIZATION, "Basic "+ encodedString);
        
    }
    
    public void setHeaderWithBundleValue(String key, String bundleValue) {
        String bundleValueStore =cucumberInteractionSession.scenarioBundle().getString(bundleValue.replace("{", "").replace("}", ""));
        cucumberInteractionSession.header(key, bundleValueStore);
    }
    
    
}
