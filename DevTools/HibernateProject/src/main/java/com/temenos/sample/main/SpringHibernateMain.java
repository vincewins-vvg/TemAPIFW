
package com.temenos.sample.main;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.temenos.sample.dao.CustomerDAO;

public class SpringHibernateMain {

	public static void main(String[] args) {

		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
		
		CustomerDAO custDao = context.getBean(CustomerDAO.class);
		
		//add customer
		//custDao.addCustomer();
		
		//view a customer
		//System.out.println(custDao.viewCustomer(1l).toString());
		 
		//update a customer
		//custDao.updateCustomer(1l);
		
		//delete a customer
		custDao.deleteCustomer(1l);
		
		//close resources
		context.close();	
	}
}
