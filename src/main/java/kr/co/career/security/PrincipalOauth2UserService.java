package kr.co.career.security;

import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import kr.co.career.dao.MemberDao;
import kr.co.career.dto.MemberDTO;
import kr.co.career.security.provider.GoogleUserInfo;
import kr.co.career.security.provider.KaKaoUserInfo;
import kr.co.career.security.provider.NaverUserInfo;
import kr.co.career.security.provider.OAuth2UserInfo;

@Service
public class PrincipalOauth2UserService extends DefaultOAuth2UserService{
	
	@Autowired
	private MemberDao mDao;
	
	// 구글로부터 받은 userRequest데이터에 대한 후처리 함수
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		
		OAuth2User oauth2User = super.loadUser(userRequest);

		OAuth2UserInfo oAuth2UserInfo = null;
		
		if(userRequest.getClientRegistration().getRegistrationId().equals("google")) {
			oAuth2UserInfo = new GoogleUserInfo(oauth2User.getAttributes());
		} else if (userRequest.getClientRegistration().getRegistrationId().equals("naver")) {
			oAuth2UserInfo = new NaverUserInfo((Map)oauth2User.getAttributes().get("response"));
		} else if (userRequest.getClientRegistration().getRegistrationId().equals("kakao")) {
			oAuth2UserInfo = new KaKaoUserInfo(oauth2User.getAttributes());
		} else {
			System.out.println("google, kakao, naver만 지원합니다.");
		}
		
		// SNS로그인시 회원가입 시키기
		String provider = oAuth2UserInfo.getProvider();
		String providerId = oAuth2UserInfo.getProviderId();
		
		String username = provider+"_"+providerId;
		String originpw = provider;
		String password = UUID.randomUUID().toString();
		
		String email = oAuth2UserInfo.getEmail();
		
		String role = "ROLE_USER";
		
		MemberDTO dto = mDao.findByUsername(username);
		
		if(dto == null) {
			dto = MemberDTO.builder()
					.username(username)
					.originpw(originpw)
					.password(password)
					.email(email)
					.role(role)
					.provider(provider)
					.providerId(providerId)
					.build();
			
			mDao.addOne(dto);
			
		}
		
		dto = mDao.findByUsername(username);
		
		return new PrincipalDetails(dto, oauth2User.getAttributes());
	}
}
