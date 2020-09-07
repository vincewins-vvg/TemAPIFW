package com.temenos.microservice.payments.entity;

import java.util.Map;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.temenos.microservice.framework.core.data.ExtendableEntity;

@Entity
@Table(name = "ms_payment_employee")
public class Employee implements ExtendableEntity {

	@Id
	@GeneratedValue(generator = "uuid")
	@GenericGenerator(name = "uuid", strategy = "uuid")
	String employeeId;

	String name;

	public String getEmployeeId() {
		return employeeId;
	}

	public void setEmployeeId(String employeeId) {
		this.employeeId = employeeId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public Map<String, String> getExtensionData() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setExtensionData(Map<String, String> extensionData) {
		// TODO Auto-generated method stub

	}

}