package com.temenos.sample.dao;

import com.temenos.sample.entity.Customer;

public interface CustomerDAO {

	public void addCustomer();
	public void addCustomerUsingHibernate();
	public Customer viewCustomer(long id);
	public void updateCustomer(long id);
	public void deleteCustomer(long id);
}
