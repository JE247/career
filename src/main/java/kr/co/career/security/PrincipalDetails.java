package kr.co.career.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import kr.co.career.dto.MemberDTO;
import lombok.Data;

// 시큐리티가 login주소를 낚아채서 로그인을 진행시킨다.
// 로그인이 완료되면 session에 넣어주어야 한다.(Securiy ContextHolder)
// session에 들어갈 수 있는 객체는 Authentication타입의 객체만 들어갈 수 있다.
// Authentication안에 User정보가 있어야 됨 이 User오브젝트의 타입은 UserDetails타입의 객체여야 한다.
@Data
public class PrincipalDetails implements UserDetails,OAuth2User {
	
	// 콤포지션
	private MemberDTO dto;
	private Map<String, Object> attributes;
	
	public PrincipalDetails(MemberDTO dto) {
		this.dto = dto;
	}
	
	public PrincipalDetails(MemberDTO dto, Map<String,Object> attributes) {
		this.dto = dto;
		this.attributes = attributes;
	}
	
	// 해당 유저의 권한을 리턴하는 곳
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		
		Collection<GrantedAuthority> collect = new ArrayList<>();
		
		collect.add(new GrantedAuthority() {
			@Override
			public String getAuthority() {
				return dto.getRole();
			}
		});
		
		return collect;
	}
	
	// 유저의 PW 리턴
	@Override
	public String getPassword() {
		return dto.getPassword();
	}

	// 유저의 ID 리턴
	@Override
	public String getUsername() {
		return dto.getUsername();
	}

	// 계정이 만료되었는지 확인 (true : 만료X)
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	// 계정이 잠겼는지 확인
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	// 계정의 비밀번호가 오래된건지 확인
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	// 계정이 활성화 되었는지 확인
	@Override
	public boolean isEnabled() {
		return true;
	}

	@Override
	public Map<String, Object> getAttributes() {
		return attributes;
	}

	@Override
	public String getName() {
		return null;
	}
}
