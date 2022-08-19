package kr.co.career.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import kr.co.career.dao.MemberDao;
import kr.co.career.dto.MemberDTO;

// 시큐리티 설정에서 loginProcessingUrl('/login')
// /login요청이 오면 자동으로 UserDetailsService로 IoC로 되어있는 loadUserByUsername함수가 실행됨
@Service
public class PrincipalDetailsService implements UserDetailsService{
	
	@Autowired
	private MemberDao dao;
	
	// login폼의 id에 해당하는 name값 = username과 매칭함
	// 리턴된 UserDetails 객체가 자동으리 Authentication에 쏙 들어간다. -> 시큐리티 session에 Authentication이 들어간다.
	// 시큐리티 session(내부 Authentication(내부 UserDetails))
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		MemberDTO userEntity = dao.findByUsername(username);
		
		if(userEntity != null) {
			return new PrincipalDetails(userEntity);
		}
		return null;
	}

}
