package com.temenos.microservice.cucumber.utility.stepdefs;

import java.io.File;
import java.io.FileInputStream;

import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelDataConfig {

	XSSFWorkbook wb;
	XSSFSheet sheet1;

	public ExcelDataConfig(String excelPath) {

		String path = System.getProperty("user.dir");

		try {
			File src = new File(excelPath);

			FileInputStream fis = new FileInputStream(path + "/" + src);
			wb = new XSSFWorkbook(fis);			

		} catch (Exception e) {

			System.out.println(e.getMessage());
		}

	}

	public String getExpectedValueExcelData(int sheetNumber, int row, int column) {

		sheet1 = wb.getSheetAt(sheetNumber);
		
		String data = sheet1.getRow(row).getCell(column).getStringCellValue();

		return data;

	}

}
