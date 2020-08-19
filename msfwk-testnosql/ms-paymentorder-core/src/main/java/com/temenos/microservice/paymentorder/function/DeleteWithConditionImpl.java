package com.temenos.microservice.paymentorder.function;

import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

public class DeleteWithConditionImpl implements DeleteWithCondition {

	@Override
    public PaymentStatus invoke(Context ctx, DeleteWithConditionInput input) throws FunctionException {
        PaymentStatus paymentStatus = new PaymentStatus();
        String deleteStatus =null;
        if(input.getParams().get().getStatus() != null && input.getParams().get().getStatus().get(0) != null) {
            deleteStatus = input.getParams().get().getStatus().get(0);
        } else {
            throw new InvalidInputException(new FailureMessage("Invalid or Null Status value entered",MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
        Criteria criteria = new Criteria();
        criteria.add(new CriterionImpl("status",deleteStatus, Operator.equal));
        long deletedCount = paymentOrderDao.deleteEntity(criteria);   
        paymentStatus.setStatus("Deleted "+deletedCount+" PaymentIds which satisfy this Criteria");
        return paymentStatus;
    }
}
