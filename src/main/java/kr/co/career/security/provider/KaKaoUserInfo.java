package kr.co.career.security.provider;

import java.util.Map;

public class KaKaoUserInfo implements OAuth2UserInfo {
	
	private Map<String, Object> attributes;
	
	private Map<String, Object> attributesAccount;


	public KaKaoUserInfo(Map<String, Object> attributes) {
		this.attributes = attributes;
		this.attributesAccount = (Map)attributes.get("kakao_account");
	}

	@Override
	public String getProvider() {
		return "kakao";
	}

	@Override
	public String getProviderId() {
		return attributes.get("id").toString();
	}
	
	@Override
	public String getEmail() {
		return attributesAccount.get("email").toString();
	}

}
