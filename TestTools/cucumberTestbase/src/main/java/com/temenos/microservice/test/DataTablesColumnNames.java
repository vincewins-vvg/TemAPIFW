package com.temenos.microservice.test;

public enum DataTablesColumnNames {
    TEST_CASE_ID("TestCaseID"),
    COLUMN_NAME("ColumnName"),
    COLUMN_OPERATOR("Operator"),
    COLUMN_DATATYPE("DataType"),
    COLUMN_VALUE("ColumnValue");

    private String name;

    DataTablesColumnNames(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
