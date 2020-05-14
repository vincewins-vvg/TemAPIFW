package com.temenos.microservice.cucumber.utility.stepdefs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

/**
 * Convert the txt output file to HTML
 *
 * @author mohamedasarudeen
 *
 */
public class ConvertTextToHTML {

    public static void main(String[] args) throws IOException {
        File htmlTemplateFile = new File("./target/cucumber-report-html/DEP_API_Output_out.txt");
        String htmlString = FileUtils.readFileToString(htmlTemplateFile);
        String htmlHeadersString = "<html><head><h2><center><U><font face=\"Times New Roman\" color=\"brown\">API OUTPUT</font></U></center></h2></head><body><xmp>";
        String htmlEnd = "</xmp></body></html>";
        htmlString = htmlHeadersString + htmlString + htmlEnd;
        File newHtmlFile = new File("./target/cucumber-report-html/DEP_API_Output_out.html");
        FileUtils.writeStringToFile(newHtmlFile,htmlString + "<br/>");
        
        editFeatureHtml(new File("./target/cucumber-report-html/cucumber-html-reports/feature-overview.html"),"<li role=\"presentation\" ><a href=\"failures-overview.html\">Failures</a></li>","<li role=\"presentation\" ><a href=\"failures-overview.html\">Failures</a></li><li role=\"presentation\"><a href=\"../DEP_API_Output_out.html\"target=\"_blank\">API-Output</a></li>");
    } 
    
    public static void editFeatureHtml(File file, String oldString, String newString) {
        try {
            // File file = new File("D:\\Index.html");
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line = " ", oldtext = " ";
            while ((line = reader.readLine()) != null) {
                oldtext += line + "\r\n";
            }
            reader.close();

            // replace a word in a file
            // String newtext = oldtext.replaceAll("drink", "Love");

            // To replace a line in a file
            if (!oldtext.contains("API-Output")){
            String newtext = oldtext.replace(oldString, newString);

            FileWriter writer = new FileWriter(file.getAbsolutePath());
            writer.write(newtext);
            writer.close();
            }
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

        
    }



