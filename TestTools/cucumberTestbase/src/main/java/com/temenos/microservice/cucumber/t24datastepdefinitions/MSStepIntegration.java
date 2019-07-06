package com.temenos.microservice.cucumber.t24datastepdefinitions; 

import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateAttribute;
import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static org.junit.Assert.assertTrue;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.DaoFacade;
import com.temenos.microservice.framework.test.dao.DaoFactory;
import com.temenos.microservice.framework.test.dao.Item;
import com.temenos.microservice.framework.test.dao.TestDbUtil;

import cucumber.api.DataTable;
import cucumber.api.java8.En;

public class MSStepIntegration implements En {

	private Item item;

	public static DaoFacade daoFacade = DaoFactory.getInstance();

	private String deleteTableName;

	public MSStepIntegration() {

		Given("^enter the tablename (.*)", (String tablename) -> {
			item = new Item();
			item.setTableName(tablename);
		});

		When("^enter data for table", (DataTable inputData) -> {

			List<Map<String, String>> data = inputData.asMaps(String.class, String.class);
			setDataforTable(data);
		});

		Given("^enter tablename to delete (.*)", (String tablename) -> {
			deleteTableName = tablename;
		});

		When("^enter value to be deleted", (DataTable deleteData) -> {
			List<Map<String, String>> dataList = deleteData.asMaps(String.class, String.class);
			deleteDataFromTable(dataList);
		});

	}

	private void deleteDataFromTable(List<Map<String, String>> inputList) {
		List<Criterion> criterionList = new ArrayList<>();
		IntStream.rangeClosed(0, inputList.size() - 1).forEach(index -> {
			if (inputList.get(index).get("Fields").equals("balanceDate")) {
				criterionList.add(populateCriterian(inputList.get(index).get("Fields"),
						inputList.get(index).get("condition"), inputList.get(index).get("type"),
						String.valueOf(calculateSortKey(inputList.get(index).get("data")))));
			} else if (inputList.get(index).get("Fields").equals("sortKey")) {
				try {
					criterionList.add(populateCriterian(inputList.get(index).get("Fields"),
							inputList.get(index).get("condition"), inputList.get(index).get("type"),
							String.valueOf(DataTypeConverter.toDate(inputList.get(index).get("data")).getTime() * 10)));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				criterionList.add(
						populateCriterian(inputList.get(index).get("Fields"), inputList.get(index).get("condition"),
								inputList.get(index).get("type"), inputList.get(index).get("data")));
			}
		});
		daoFacade.openConnection();
		assertTrue(daoFacade.deleteItems(deleteTableName, criterionList));
		daoFacade.closeConnection();
	}
	   /**
     * calculateSortKey method is used to calculate sort key for holdings
     * 
     * @param date
     * @return long
     */
    private static long calculateSortKey(String date) {
        return TestDbUtil.stringToDate(date).getTime()/1000;
    }

	private void setDataforTable(List<Map<String, String>> inputList) {
		List<Attribute> attributeList = new ArrayList<>();
		IntStream.rangeClosed(0, inputList.size() - 1).forEach(index -> {
			if (inputList.get(index).get("Fields").equals("balanceDate")) {
				attributeList
						.add(populateAttribute(inputList.get(index).get("Fields"), inputList.get(index).get("type"),
								String.valueOf(calculateSortKey(inputList.get(index).get("data")))));
			} else if (inputList.get(index).get("Fields").equals("sortKey")) {
				try {
					attributeList.add(populateAttribute(inputList.get(index).get("Fields"),
							inputList.get(index).get("type"),
							String.valueOf(DataTypeConverter.toDate(inputList.get(index).get("data")).getTime() * 10)));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				attributeList.add(populateAttribute(inputList.get(index).get("Fields"),
						inputList.get(index).get("type"), inputList.get(index).get("data")));
			}
		});
		item.setAttributes(attributeList);
		daoFacade.openConnection();
		daoFacade.createRecord(item);
		daoFacade.closeConnection();
	}
}
