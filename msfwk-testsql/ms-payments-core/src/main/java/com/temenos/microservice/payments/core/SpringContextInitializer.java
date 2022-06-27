/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringContextInitializer {

	private static final SpringContextInitializer INSTANCE = new SpringContextInitializer();
	private ClassPathXmlApplicationContext ctx; 
	
	public static SpringContextInitializer instance() {
		return INSTANCE;
	}
	
	public Object getBean(Class<?> clazz) {
		if (ctx == null) {
			ctx = new ClassPathXmlApplicationContext("classpath:/spring-beans.xml");
		}
		return ctx.getBean(clazz);
	}
}
