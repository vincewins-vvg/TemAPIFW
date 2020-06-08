package com.temenos.microservice.cucumber.utility.stepdefs;

import org.springframework.stereotype.Component;

@Component
public class GlobalConfig {

	private String token;
	private String cookie;
	private String sharedSecretLoginToken;

	public String getSharedSecretLoginToken() {
		return sharedSecretLoginToken;
	}

	public void setSharedSecretLoginToken(String sharedSecretLoginToken) {
		this.sharedSecretLoginToken = sharedSecretLoginToken;
	}

	public String getCookie() {
		return cookie;
	}

	public void setCookie(String cookie) {
		this.cookie = cookie;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

}
