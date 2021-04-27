package com.temenos.microservice.paymentorder.function;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriteriaUpdate;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.CriterionUpdateImpl;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.view.CriteriaDetails;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

public class UpdatePaymentStatusImpl implements UpdateStatus{

	@Override
    public PaymentStatus invoke(Context ctx, UpdateStatusInput input) throws FunctionException {
        PaymentStatus paymentStatus = null;
        if(input.getBody() != null && input.getBody().get().getStatus() != null) {
            paymentStatus = input.getBody().get().getStatus();
        } else {
            throw new InvalidInputException(new FailureMessage("Invalid Status or Null Body in request",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        List<CriteriaDetails> updateCondition = null;
        if(input.getBody().get().getCriteriaDetails() != null) {
            updateCondition = input.getBody().get().getCriteriaDetails();
        } else {
            throw new InvalidInputException(new FailureMessage("Invalid Criteria or Null Body in request",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
                .getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);   
        Criteria criteria = new Criteria();
        for(CriteriaDetails details: updateCondition) {
            if(details.getNameOfCriteria() != null && details.getValueOfCriteria() != null) {
                if(details.getValueOfCriteria() instanceof String && details.getValueOfCriteria().matches("[0-9]{4}[-]{1}[0-9]{2}[-]{1}[0-9]{2}")) {
                    try {
                        criteria.add(new CriterionImpl(details.getNameOfCriteria(),DataTypeConverter.toDate(details.getValueOfCriteria(),"yyyy-MM-dd") , Operator.equal));
                    } catch (ParseException e) {
                        throw new InvalidInputException(new FailureMessage("Invalid or Null date values entered",
                                MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
                    }
                } else {
                criteria.add(new CriterionImpl(details.getNameOfCriteria(), details.getValueOfCriteria(), Operator.equal));
                }
            } else {
                throw new InvalidInputException(new FailureMessage("Invalid or Null Criteria values entered",
                        MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
            }
        }
        CriteriaUpdate updaeCriteria = new CriteriaUpdate();
        if(paymentStatus.getStatus() != null && paymentStatus.getStatus().length() > 0){
            updaeCriteria.add(new CriterionUpdateImpl("status", paymentStatus.getStatus()));
        }   
        else {
            throw new InvalidInputException(new FailureMessage("Invalid or Null status value entered",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        if(paymentStatus.getDebitAccount() != null && paymentStatus.getDebitAccount().length() > 0){
            updaeCriteria.add(new CriterionUpdateImpl("debitAccount", paymentStatus.getDebitAccount()));
        }
        if(paymentStatus.getPaymentId() != null && paymentStatus.getPaymentId().length() > 0){
            updaeCriteria.add(new CriterionUpdateImpl("paymentId", paymentStatus.getPaymentId()));
        }
        if(paymentStatus.getFileReadWrite() != null){
            updaeCriteria.add(new CriterionUpdateImpl("fileReadWrite", paymentStatus.getFileReadWrite()));
        }
        if(paymentStatus.getExtensionData() != null){
            updaeCriteria.add(new CriterionUpdateImpl("extensionData", paymentStatus.getExtensionData()));
        }
        if(paymentStatus.getPaymentMethod() != null){
            updaeCriteria.add(new CriterionUpdateImpl("paymentMethod", paymentStatus.getPaymentMethod()));
        }
        if(paymentStatus.getExchangeRates() != null){
            updaeCriteria.add(new CriterionUpdateImpl("exchangeRates", paymentStatus.getExchangeRates()));
        }
        
        
        long updatedCount = paymentOrderDao.updateEntity(criteria, updaeCriteria, com.temenos.microservice.paymentorder.entity.PaymentOrder.class);   
        PaymentStatus payStatus = new PaymentStatus();
        payStatus.setStatus("Updated "+updatedCount +" PaymentIds which satisfy this Criteria");
        return payStatus;
    }
}
