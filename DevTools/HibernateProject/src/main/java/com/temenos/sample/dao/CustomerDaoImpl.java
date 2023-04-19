package com.temenos.sample.dao;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.temenos.sample.entity.Address;
import com.temenos.sample.entity.Card;
import com.temenos.sample.entity.CreditCard;
import com.temenos.sample.entity.Customer;
import com.temenos.sample.entity.Customer.Gender;
import com.temenos.sample.entity.CustomerMiscInfo;
import com.temenos.sample.entity.Shares;
import com.temenos.sample.entity.Shares.SharePK;

@Repository
public class CustomerDaoImpl implements CustomerDAO {

	@Autowired
	private EntityManagerFactory entityManagerFactory;
	
	@Override
	public void addCustomer() {
		EntityManager em = entityManagerFactory.createEntityManager();
		em.getTransaction().begin();
		Customer cust = new Customer();
		cust.setName("Abc");
		cust.setEmail("abc@email.com");
		Address a = new Address();
		a.setCity("NYC");
		a.setDoorNo("100");
		a.setState("NY");
		a.setStreet("D street");
		a.setCustomer(cust);
		Set<Address> addressSet = new HashSet<>();
		Address b = new Address();
		b.setCity("TXD");
		b.setDoorNo("101");
		b.setState("TX");
		b.setStreet("Y street");
		b.setCustomer(cust);
		addressSet.add(a);
		addressSet.add(b);
		cust.setAddresses(addressSet);
		Card card = new Card();
		card.setCardname("VISA");
		card.setCustomer(cust);
		card.setCardlimit(new BigDecimal(10000));
		cust.setCard(card);
		CreditCard ccard = new CreditCard();
		ccard.setCardNo(12341234);
		ccard.setCustomer(cust);
		ccard.setCardType("CRX");
		ccard.setInfo("123qesa3efsgg");
		ccard.setKeyInfo("32e23edsf23we");
		cust.setCcard(ccard);
		Set<Customer> custSet = new HashSet<>();
		custSet.add(cust);
		Shares share = new Shares();
		SharePK s1 = new SharePK();
		s1.setCompanyId("ABC");
		s1.setProductId("001");
		share.setId(s1);
		share.setStockName("ABC stock");
		share.setSharesCount(1000);
		share.setBuyPrice(new BigDecimal(100));
		share.setCustomers(custSet);
		share.setLastUpdatedTimestamp(new Timestamp(System.currentTimeMillis()));
		Shares share1 = new Shares();
		share1.setStockName("DEF stock");
		share1.setSharesCount(100);
		share1.setBuyPrice(new BigDecimal(99));
		share1.setCustomers(custSet);
		share1.setLastUpdatedTimestamp(new Timestamp(System.currentTimeMillis()));
		SharePK s2 = new SharePK();
		s2.setCompanyId("DEF");
		s2.setProductId("001");
		share1.setId(s2);
		Set<Shares> shareSet = new HashSet<>();
		shareSet.add(share1);
		shareSet.add(share);
		cust.setLastUpdatedDate(new Date());
		cust.setShares(shareSet);
		cust.setGender(Gender.MALE);
		CustomerMiscInfo cmi = new CustomerMiscInfo();
		cmi.setHobby("Travel");
		cmi.setLanguagesKnown("English,Espanol");
		cmi.setCustomer(cust);
		cust.setCustomerMiscInfo(cmi);
		em.persist(cust);
		em.getTransaction().commit();	
	}
	
	@Override
	public void addCustomerUsingHibernate() {
		EntityManager em = entityManagerFactory.createEntityManager();
		Session s = em.unwrap(Session.class);
		s.beginTransaction();
		Customer cust = new Customer();
		cust.setName("Abc");
		cust.setEmail("abc@email.com");
		Address a = new Address();
		a.setCity("NYC");
		a.setDoorNo("100");
		a.setState("NY");
		a.setStreet("D street");
		a.setCustomer(cust);
		Set<Address> addressSet = new HashSet<>();
		Address b = new Address();
		b.setCity("TXD");
		b.setDoorNo("101");
		b.setState("TX");
		b.setStreet("Y street");
		b.setCustomer(cust);
		addressSet.add(a);
		addressSet.add(b);
		cust.setAddresses(addressSet);
		Card card = new Card();
		card.setCardname("VISA");
		card.setCustomer(cust);
		card.setCardlimit(new BigDecimal(10000));
		cust.setCard(card);
		CreditCard ccard = new CreditCard();
		ccard.setCardNo(12341234);
		ccard.setCustomer(cust);
		ccard.setCardType("CRX");
		cust.setCcard(ccard);
		Set<Customer> custSet = new HashSet<>();
		custSet.add(cust);
		Shares share = new Shares();
		share.setStockName("ABC stock");
		share.setSharesCount(1000);
		share.setBuyPrice(new BigDecimal(100));
		share.setCustomers(custSet);
		Shares share1 = new Shares();
		share1.setStockName("DEF stock");
		share1.setSharesCount(100);
		share1.setBuyPrice(new BigDecimal(99));
		share1.setCustomers(custSet);
		Set<Shares> shareSet = new HashSet<>();
		shareSet.add(share1);
		shareSet.add(share);
		cust.setShares(shareSet);
		s.save(cust);
		s.getTransaction().commit();
	}

	public Customer viewCustomer(long id) {
		EntityManager em = entityManagerFactory.createEntityManager();
		return em.find(Customer.class, id);
	}
	
	public void updateCustomer(long id) {
		EntityManager em = entityManagerFactory.createEntityManager();
		em.getTransaction().begin();
		Customer customer = em.find(Customer.class, id);
		customer.setGender(Gender.UNKNOWN);
		em.merge(customer);
		em.getTransaction().commit();
	}
	
	public void deleteCustomer(long id) {
		EntityManager em = entityManagerFactory.createEntityManager();
		em.getTransaction().begin();
		Customer customer = em.find(Customer.class, id);
		em.remove(customer);
		em.getTransaction().commit();
	}
}
