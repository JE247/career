package kr.co.career.security.provider;

import java.util.Map;

public class GoogleUserInfo implements OAuth2UserInfo {
	
	private Map<String, Object> attributes;


	public GoogleUserInfo(Map<String, Object> attributes) {
		this.attributes = attributes;
	}

	@Override
	public String getProvider() {
		return "google";
	}

	@Override
	public String getProviderId() {
		return (String)attributes.get("sub");
	}
	
	@Override
	public String getEmail() {
		// TODO Auto-generated method stub
		return (String)attributes.get("email");
	}

}
