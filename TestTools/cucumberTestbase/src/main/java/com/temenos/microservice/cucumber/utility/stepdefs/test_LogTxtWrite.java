package com.temenos.microservice.cucumber.utility.stepdefs;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 * TODO: Document me!
 *
 * @author mohamedasarudeen
 *
 */
public class test_LogTxtWrite {

    public static void main(String args[]) throws IOException {

        method2();

    }

    public static void method1() {

        String query = "selct form table where status='@STATUS1@' and status='@STATUS2@'";

        if (query.contains("@")) {
            String temp = null;
            do {
                temp = query.substring(query.indexOf(64) + 1);
                temp = temp.substring(0, temp.indexOf(64));

                String value = "100";
                query = query.replace("@" + temp + "@", value);
            } while (query.contains("@"));
        }

        System.out.println("PRINTING QUERY:" + query);

        if (query.isEmpty()) {
            System.out.println(true);
        }

    }

    public static void method2() throws IOException {

        File file = new File("./DEP_API_Output.txt");

        BufferedReader read = new BufferedReader(new FileReader(file));
        BufferedWriter write = new BufferedWriter(new FileWriter("./target/cucumber-report-html/DEP_API_Output_out.txt"));

        String str = null;
        Boolean copyLine = false;

        while ((str = read.readLine()) != null) {

            if (str.contains("URL:") || str.contains("Feature:") || str.contains("Scenario:")
                   /* || str.contains("Tests run:")*/) {

                copyLine = true;

            }
            if (str.contains("</entry") || str.contains("SLF4J: ") || str.contains("Given") || str.contains("When")
                    || str.contains("And") || str.contains("Then")) {
                copyLine = false;

            }
            if (copyLine) {
                System.out.println(str);
                write.write(str);
                write.newLine();

            }

        }
        write.close();

    }

}
