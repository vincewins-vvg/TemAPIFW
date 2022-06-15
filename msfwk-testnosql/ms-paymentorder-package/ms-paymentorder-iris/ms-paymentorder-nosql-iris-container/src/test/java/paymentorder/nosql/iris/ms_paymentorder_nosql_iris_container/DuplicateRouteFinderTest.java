/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package paymentorder.nosql.iris.ms_paymentorder_nosql_iris_container;

/**
 * A container level test to make sure only the unique routes are presents in the war file if there are any duplicate routes this will fail the build.
 * 
 * @author mohamednazir
 *
 */
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class DuplicateRouteFinderTest {
    
    ApplicationContext context = null;
    
    @Test
    public void checkDuplicateRoutes(){
        
        context = new ClassPathXmlApplicationContext("classpath*:**/applicationcontext.xml");
        // if there is a duplicate route this tet will throw an exception.
        assertNotNull(context);
    }

}
