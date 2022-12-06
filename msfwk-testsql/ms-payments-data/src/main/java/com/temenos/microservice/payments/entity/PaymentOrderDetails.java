/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.entity;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

import com.temenos.microservice.framework.core.data.BaseEntity;
import com.temenos.microservice.framework.core.data.ExtendableEntity;

@Entity(name = "PaymentOrderDetails")
@Table(name = "ms_payment_order_details")
public class PaymentOrderDetails extends BaseEntity implements ExtendableEntity {

	private static final long serialVersionUID = 91461269991669620L;

	@EmbeddedId
	private PaymentOrderDetailsPK paymentOrderTxnDetails;

	public PaymentOrderDetails() {
	}

	public PaymentOrderDetails(String txnId, String balance) {
		this.paymentOrderTxnDetails = new PaymentOrderDetailsPK(txnId, balance);
	}

	public PaymentOrderDetailsPK getPaymentDetails() {
		return paymentOrderTxnDetails;
	}

	public void setAcBalanceTypeDetails(PaymentOrderDetailsPK paymentOrderDetails) {
		this.paymentOrderTxnDetails = paymentOrderDetails;
	}

	@Embeddable
	public static class PaymentOrderDetailsPK implements Serializable {

		private static final long serialVersionUID = 9146156931169669620L;

		@Column(name = "recId", unique = false, nullable = false)
		private String recId;

		@Column(name = "balance", unique = false, nullable = false)
		private String balance;

		public PaymentOrderDetailsPK() {
		}

		public PaymentOrderDetailsPK(String recId, String balance) {
			this.balance = balance;
			this.recId = recId;
		}

		public String getRecId() {
			return recId;
		}

		public void setRecId(String recId) {
			this.recId = recId;
		}

		public String getBalance() {
			return balance;
		}

		public void setBalance(String balance) {
			this.balance = balance;
		}

		@Override
		public boolean equals(Object o) {
			if (this == o)
				return true;
			if (!(o instanceof PaymentOrderDetailsPK))
				return false;
			PaymentOrderDetailsPK that = (PaymentOrderDetailsPK) o;
			return Objects.equals(getRecId(), that.getBalance()) && Objects.equals(getRecId(), that.getBalance());
		}

		@Override
		public int hashCode() {
			return Objects.hash(getRecId(), getBalance());
		}

	}
}
