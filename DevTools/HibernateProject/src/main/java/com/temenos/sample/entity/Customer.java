package com.temenos.sample.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name="customer",
indexes = {@Index(name = "cust_index",  columnList="name", unique = true)})
public class Customer {

	@Id
	@GeneratedValue
	private long id;
	
	@Column
	private String name;
	
	@Column
	private String email;
	
	@Enumerated(EnumType.STRING)
	private Gender gender;

	@OneToMany(mappedBy="customer",cascade = CascadeType.ALL,fetch = FetchType.EAGER,orphanRemoval = true)
    private Set<Address> addresses;
	
	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "cardid", referencedColumnName = "id")
	private Card card;
	
	@OneToOne(cascade = CascadeType.ALL)
    @JoinTable(name = "customer_credit", 
      joinColumns = 
        { @JoinColumn(name = "customer_id", referencedColumnName = "id") },
      inverseJoinColumns = 
        { @JoinColumn(name = "cc_id", referencedColumnName = "id") })
	private CreditCard ccard;

	@ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(
        name = "Customer_Shares", 
        joinColumns = { @JoinColumn(name = "customer_id") }, 
        inverseJoinColumns = { @JoinColumn(name = "share_id1"),@JoinColumn(name = "share_id2") }
    )
    Set<Shares> shares = new HashSet<>();
	
	private Date lastUpdatedDate;
	
	public enum Gender {
		MALE, FEMALE, UNKNOWN
	}
	
	@OneToOne(mappedBy = "customer",cascade = CascadeType.ALL)
	private CustomerMiscInfo customerMiscInfo;
	
	public Gender getGender() {
		return gender;
	}

	public void setGender(Gender gender) {
		this.gender = gender;
	}
	
	public CustomerMiscInfo getCustomerMiscInfo() {
		return customerMiscInfo;
	}

	public void setCustomerMiscInfo(CustomerMiscInfo customerMiscInfo) {
		this.customerMiscInfo = customerMiscInfo;
	}

	public Date getLastUpdatedDate() {
		return lastUpdatedDate;
	}

	public void setLastUpdatedDate(Date lastUpdatedDate) {
		this.lastUpdatedDate = lastUpdatedDate;
	}

	public CreditCard getCcard() {
		return ccard;
	}

	public void setCcard(CreditCard ccard) {
		this.ccard = ccard;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Card getCard() {
		return card;
	}

	public void setCard(Card card) {
		this.card = card;
	}

	public Set<Address> getAddresses() {
		return addresses;
	}

	public void setAddresses(Set<Address> addresses) {
		this.addresses = addresses;
	}

	public Set<Shares> getShares() {
		return shares;
	}

	public void setShares(Set<Shares> shares) {
		this.shares = shares;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", name=" + name + ", email=" + email + ", gender=" + gender
				+ ", lastUpdatedDate=" + lastUpdatedDate + "]";
	}
	
}
