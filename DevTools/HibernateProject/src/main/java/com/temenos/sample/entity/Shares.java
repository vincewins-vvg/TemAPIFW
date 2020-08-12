package com.temenos.sample.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

@Entity
public class Shares {

	@Id
	@EmbeddedId
	private SharePK id;
	
	private String stockName;
	
	private int sharesCount;
	
	private BigDecimal buyPrice;
	
	private BigDecimal sellPrice;
	
	private Timestamp lastUpdatedTimestamp;
	
	@ManyToMany(mappedBy = "shares")
    private Set<Customer> customers = new HashSet<>();

	public String getStockName() {
		return stockName;
	}

	public void setStockName(String stockName) {
		this.stockName = stockName;
	}

	public int getSharesCount() {
		return sharesCount;
	}

	public void setSharesCount(int sharesCount) {
		this.sharesCount = sharesCount;
	}

	public BigDecimal getBuyPrice() {
		return buyPrice;
	}

	public void setBuyPrice(BigDecimal buyPrice) {
		this.buyPrice = buyPrice;
	}

	public BigDecimal getSellPrice() {
		return sellPrice;
	}

	public void setSellPrice(BigDecimal sellPrice) {
		this.sellPrice = sellPrice;
	}

	public Set<Customer> getCustomers() {
		return customers;
	}

	public void setCustomers(Set<Customer> customers) {
		this.customers = customers;
	}
	
	public SharePK getId() {
		return id;
	}

	public void setId(SharePK id) {
		this.id = id;
	}

	public Timestamp getLastUpdatedTimestamp() {
		return lastUpdatedTimestamp;
	}

	public void setLastUpdatedTimestamp(Timestamp lastUpdatedTimestamp) {
		this.lastUpdatedTimestamp = lastUpdatedTimestamp;
	}

	@Embeddable
	public static class SharePK implements Serializable {
		
		private static final long serialVersionUID = 91461569211669620L;
		
		private String productId;
		
		private String companyId;
		
		public SharePK() {
		}

		public SharePK(String productId, String companyId) {
			this.productId = productId;
			this.companyId = companyId;
		}

		public String getCompanyId() {
			return companyId;
		}

		public void setCompanyId(String companyId) {
			this.companyId = companyId;
		}

		public String getProductId() {
			return productId;
		}

		public void setProductId(String productId) {
			this.productId = productId;
		}

		@Override
		public boolean equals(Object o) {
			if (this == o)
				return true;
			if (!(o instanceof SharePK))
				return false;
			SharePK that = (SharePK) o;
			return Objects.equals(getProductId(), that.getProductId())
					&& Objects.equals(getCompanyId(), that.getCompanyId());
		}

		@Override
		public int hashCode() {
			return Objects.hash(getProductId(), getCompanyId());
		}

	}
}
