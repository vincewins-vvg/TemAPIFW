package com.temenos.microservice.test.cucumber;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import com.temenos.useragent.cucumber.config.EndPointConfiguration;

/**
 * 
 * T24EndPointConfiguration to add T24 related configurations
 * 
 * <p>
 * Add {@link @PropertySources PropertySources} only if there is an additional
 * property file other than <b>end-point.properties</b>
 * </p>
 * 
 * @author mohamedasarudeen
 *
 */
@Configuration
public class MSFrameworkEndPointConfiguration extends EndPointConfiguration {

	private List<String> users;
	private List<String> passwords;
	private List<String> uri;
	private String appkey;
	private String appSecret;
	private String loginURI;
	private String URI2;
	private String URI3;
	private String URI4;
	private String URI5;

	@Value("${URI}")
	public void setEndpointUri(String endpointUri) {
		/*
		 * URI gets sets only in the system property. In case of local machine, value
		 * from end.point properties
		 */
		String uri = System.getProperty("URI");
		if (uri == null) {

			uri = endpointUri;
		}
		super.setEndpointUri(uri);

		System.out.println("Endpoint URI set to " + Optional.ofNullable(endpointUri).orElse(""));
	}

	@Value("${kony.cucumber.appkey}")
	protected void setAppKey(String endPointAppKey) {

		String appkey = System.getProperty("kony.cucumber.appkey");
		if (appkey == null) {
			appkey = endPointAppKey;
		}

		super.setAppKey(appkey);

		System.out.println("Kony Appkey value is set to " + Optional.ofNullable(endPointAppKey).orElse(""));

	}

	@Value("${kony.cucumber.appsecret}")
	protected void setAppSecret(String appSecretKey) {

		String appsecret = System.getProperty("kony.cucumber.appsecret");
		if (appsecret == null) {
			appsecret = appSecretKey;
		}
		super.setAppSecret(appsecret);

		System.out.println("Kony AppSecret value is set to " + Optional.ofNullable(appSecretKey).orElse(""));

	}

	@Value("${loginURI}")
	public void setLoginURI(String loginURI) {

		/*
		 * loginURI gets sets only in the system property. In case of local machine,
		 * value from end.point properties
		 */

		String loginUri = System.getProperty("loginURI");
		if (loginUri == null) {
			loginUri = loginURI;
		}
		this.loginURI = loginURI;

		System.out.println("Login URI is set to " + Optional.ofNullable(loginURI).orElse(""));

	}

	@Value("${URI2}")
	public void setURI2(String endpointuRI2) {

		String uri2 = System.getProperty("URI2");
		if (uri2 == null) {
			uri2 = endpointuRI2;
		}
		this.URI2 = endpointuRI2;

		System.out.println("Endpoint URI2 is set to " + Optional.ofNullable(endpointuRI2).orElse(""));
	}

	@Value("${URI3}")
	public void setURI3(String endpointuRI3) {

		String uri3 = System.getProperty("URI3");
		if (uri3 == null) {
			uri3 = endpointuRI3;
		}
		this.URI3 = endpointuRI3;

		System.out.println("Endpoint URI3 is set to " + Optional.ofNullable(endpointuRI3).orElse(""));
	}

	@Value("${URI4}")
	public void setURI4(String endpointuRI4) {

		String uri4 = System.getProperty("URI4");
		if (uri4 == null) {
			uri4 = endpointuRI4;
		}
		this.URI4 = endpointuRI4;

		System.out.println("Endpoint URI4 is set to " + Optional.ofNullable(endpointuRI4).orElse(""));
	}

	@Value("${URI5}")
	public void setURI5(String endpointuRI5) {

		String uri5 = System.getProperty("URI5");
		if (uri5 == null) {
			uri5 = endpointuRI5;
		}
		this.URI5 = endpointuRI5;

		System.out.println("Endpoint URI5 is set to " + Optional.ofNullable(endpointuRI5).orElse(""));
	}

	public String getURI2() {

		String uri2 = this.URI2;
		if (!uri2.endsWith("/")) {
			return uri2;
		} else {
			return URI2 + "/";
		}
	}

	public String getURI3() {

		String uri3 = this.URI3;
		if (!uri3.endsWith("/")) {
			return uri3;
		} else {
			return URI3 + "/";
		}
	}

	public String getURI4() {

		String uri4 = this.URI4;
		if (!uri4.endsWith("/")) {
			return uri4;
		} else {
			return URI4 + "/";
		}
	}

	public String getURI5() {

		String uri5 = this.URI5;
		if (!uri5.endsWith("/")) {
			return uri5;
		} else {
			return URI5 + "/";
		}
	}

	public String getLoginURI() {

		String loginUri = this.loginURI;
		if (!loginUri.endsWith("/")) {
			return loginUri;
		} else {
			return loginURI + "/";
		}

	}

	public String getEndpointUri() {
		String uri = super.getEndpointUri();
		if (!uri.endsWith("/")) {
			return uri;
		} else {
			return uri + "/";
		}
	}

	public String getUserName(String userName) {
		if (users.contains(userName)) {
			return userName;
		} else {
			throw new IllegalArgumentException("User not configured : " + userName);
		}
	}

	public String getPassword(String userName) {
		int userIndex = users.indexOf(userName);
		if (userIndex != -1 && userIndex < passwords.size()) {
			return passwords.get(userIndex);
		} else {
			throw new IllegalArgumentException("Password not configured for User: " + userName);
		}
	}

}
