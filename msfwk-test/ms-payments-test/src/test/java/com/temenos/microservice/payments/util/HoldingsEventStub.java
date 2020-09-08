package com.temenos.microservice.payments.util;

import com.temenos.des.eventtransformer.data.parse.data.DynamicArrayBuilder;
import com.temenos.des.eventtransformer.data.parse.marker.RuntimeMarker;
import com.temenos.des.eventtransformer.data.parse.marker.TAFJMarker;

public class HoldingsEventStub {

	private static RuntimeMarker marker = new TAFJMarker();

	private HoldingsEventStub() {
	}

	public static String getDataEvent() {
		return new DynamicArrayBuilder(marker).value("1544460586.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("186079759760588.010002").vm().value("186079759760588")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("200010000007307").lfm().value("GB0010001").lfm()
						.value("-0.01").lfm().value("213").lfm(4).value("150000891").lfm().value("1030001078").lfm()
						.value("6001").lfm().value("20180731").lfm().value("USD").lfm(4).value("TR").lfm()
						.value("FT1821239228").lfm(2).value("20180731").lfm().value("1").lfm(2).value("1").lfm()
						.value("FT1821239228").lfm().value("FT").lfm().value("20180731").lfm()
						.value("186079759760586.01").lvm().value("1").lvm().value("1").lfm(3).value("1").lfm()
						.value("97597_INPUTTER__OFS_GCS").lfm().value("1812101749").lfm().value("97597_INPUTTER").lfm(4)
						.value("CREDIT").lfm(3).value("AC.1.TR.USD.6001.1001").lfm(35).value("TD").lvm(7)
						.value("VALUE.DATE").lfm(17).value("CLDEFAULT").lfm(7).value("200010000007307").lfm(2)
						.value("20180731").lfm().value("CURBALANCE").lfm()
						.value("ACCOUNTS-DEBIT-ARRANGEMENT*20180731*GB0010001*AA18207L7MT9**DIRECT*AAACT182124GP8ZMWJ*")
						.lfm(2).value("1").lfm(2).vm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010002").lfm(4).value("AC").lfm(2)
						.value("150000891").lfm(37).value("20180731").lfm(11).value("9500.45").lfm().value("9500.45")
						.lfm().value("9500.44").lfm(47).fm())
				.value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES").build();
	}
	
	public static String getNewDataEvent() {
		return new DynamicArrayBuilder(marker).value("1544460586.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("186079759760587.010001").vm().value("186079759760587")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("500010000007307").lfm().value("GB0019991").lfm()
						.value("-0.01").lfm().value("213").lfm(4).value("150000891").lfm().value("1030001078").lfm()
						.value("6001").lfm().value("20180731").lfm().value("USD").lfm(4).value("TR").lfm()
						.value("FT1821239998").lfm(2).value("20180731").lfm().value("1").lfm(2).value("1").lfm()
						.value("FT1821239998").lfm().value("FT").lfm().value("20180731").lfm()
						.value("186079759760586.01").lvm().value("1").lvm().value("1").lfm(3).value("1").lfm()
						.value("97597_INPUTTER__OFS_GCS").lfm().value("1812101749").lfm().value("97597_INPUTTER").lfm(4)
						.value("CREDIT").lfm(3).value("AC.1.TR.USD.6001.1001").lfm(35).value("TD").lvm(7)
						.value("VALUE.DATE").lfm(17).value("CLDEFAULT").lfm(7).value("200010000007307").lfm(2)
						.value("20180731").lfm().value("CURBALANCE").lfm()
						.value("ACCOUNTS-DEBIT-ARRANGEMENT*20180731*GB0010001*AA18207L7MT9**DIRECT*AAACT182124GP8ZMWJ*")
						.lfm(2).value("1").lfm(2).vm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010895").lfm(4).value("AC").lfm(2)
						.value("150000895").lfm(37).value("20180731").lfm(11).value("9500.45").lfm().value("9500.45")
						.lfm().value("9500.44").lfm(47).fm())
				.value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES").build();
	}

	public static String buildLatestBalance() {
		return new DynamicArrayBuilder(marker).value("1544460586.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.EB.CONTRACT.BALANCES").fm())
				.value(new DynamicArrayBuilder(marker).value("100100").fm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010001").lfm(4).value("AC").lfm(2)
						.value("150000892").lfm(37).value("20180801").lfm(11).value("8500").lfm().value("8500").lfm()
						.value("8500").lfm(47).fm())
				.value("FBNK.EB.CONTRACT.BALANCES").build();
	}

	public static String buildOldBalance() {
		return new DynamicArrayBuilder(marker).value("1544460586.005").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.EB.CONTRACT.BALANCES").fm())
				.value(new DynamicArrayBuilder(marker).value("100100").fm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010001").lfm(4).value("AC").lfm(2)
						.value("150000892").lfm(37).value("20180801").lfm(11).value("9500").lfm().value("9500").lfm()
						.value("9500").lfm(47).fm())
				.value("FBNK.EB.CONTRACT.BALANCES").build();
	}

	public static String getT24Event() {
		return new DynamicArrayBuilder(marker).value("1544460587.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("186079759760587.010001").vm().value("186079759760587")
						.fm())
				.value(new DynamicArrayBuilder(marker).value("200010000007308").lfm().value("GB0010001").lfm()
						.value("-0.01").lfm().value("213").lfm(4).value("150000891").lfm().value("1030001078").lfm()
						.value("6001").lfm().value("20180801").lfm().value("USD").lfm(4).value("TR").lfm()
						.value("FT1821239229").lfm(2).value("20180801").lfm().value("1").lfm(2).value("1").lfm()
						.value("FT1821239229").lfm().value("FT").lfm().value("20180801").lfm()
						.value("186079759760587.01").lvm().value("1").lvm().value("1").lfm(3).value("1").lfm()
						.value("97597_INPUTTER__OFS_GCS").lfm().value("1812101749").lfm().value("97597_INPUTTER").lfm(4)
						.value("CREDIT").lfm(3).value("AC.1.TR.USD.6001.1001").lfm(35).value("TD").lvm(7)
						.value("VALUE.DATE").lfm(17).value("CLDEFAULT").lfm(7).value("200010000007308").lfm(2)
						.value("20180801").lfm().value("CURBALANCE").lfm()
						.value("ACCOUNTS-DEBIT-ARRANGEMENT*20180801*GB0010001*AA18207L7MT9**DIRECT*AAACT182124GP8ZMWJ*")
						.lfm(2).value("1").lfm(2).vm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010001").lfm(4).value("AC").lfm(2)
						.value("150000892").lfm(37).value("20180801").lfm(11).value("8500.45").lfm().value("8500.45")
						.lfm().value("8500.44").lfm(47).fm())
				.value("FBNK.STMT.ENTRY").vm().value("FBNK.EB.CONTRACT.BALANCES").build();
	}

	public static String getBalanceEvent() {
		return new DynamicArrayBuilder(marker).value("1544460586.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.EB.CONTRACT.BALANCES").fm())
				.value(new DynamicArrayBuilder(marker).value("150100").fm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010055").lfm(4).value("AC").lfm(2)
						.value("160000892").lfm(37).value("20180801").lfm(11).value("8500").lfm().value("8500").lfm()
						.value("8500").lfm(47).fm())
				.value("FBNK.EB.CONTRACT.BALANCES").build();
	}
	
	public static String getNewBalanceEvent() {
		return new DynamicArrayBuilder(marker).value("1544460586.405").fm(4)
				.value(new DynamicArrayBuilder(marker).value("FBNK.EB.CONTRACT.BALANCES").fm())
				.value(new DynamicArrayBuilder(marker).value("116600").fm())
				.value(new DynamicArrayBuilder(marker).value("USD").lfm(15).value("GB0010077").lfm(4).value("AC").lfm(2)
						.value("160000892").lfm(37).value("20180801").lfm(11).value("8500").lfm().value("8500").lfm()
						.value("8500").lfm(47).fm())
				.value("FBNK.EB.CONTRACT.BALANCES").build();
	}

}