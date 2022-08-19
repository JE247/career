package kr.co.career.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true) // Secure어노테이션 및 preAuthorize어노테이션 활성화
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	AuthenticationFailureHandler handler;
	
	@Autowired
	private PrincipalOauth2UserService principalOauth2UserService;
	
	// Bean으로 설정하면 더이상 초기에 제공되는 비밀번호로는 로그인이 진행되지 않는다.
	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		
		http
			.headers()
				.frameOptions().sameOrigin();
		
		http
			.authorizeRequests()
				.antMatchers("/user/**/*").authenticated()
				.antMatchers("/admin/**/*").access("hasRole('ROLE_ADMIN')")
				.anyRequest().permitAll();
		
		http
			.formLogin()
				.loginPage("/career/login")
				.loginProcessingUrl("/login") // /login이라는 주소가 호출이 되면 시큐리티가 낚아채서 대신 로그인을 진행해준다.
				.defaultSuccessUrl("/career/main")
				.failureHandler(handler)
				.and()
			.logout()
            	.logoutUrl("/career/logout")
            	.invalidateHttpSession(true)
				.logoutSuccessUrl("/career/main");
		
		http.oauth2Login()
				.loginPage("/career/login")
				.defaultSuccessUrl("/career/register/plusInfo")
				.userInfoEndpoint()//로그인이 완료된 후의 후처리 진행 1. 코드받기 2. 엑세스토큰 3. 사용자프로필정보 가져오기 4. 그정보를 토대로 회원가입 또는 추가정보 받아 회원가입진행
				.userService(principalOauth2UserService);  // 구글로그인이 완료가 되면 코드가 아닌 엑세스토큰 및 사용자 프로필정보를 한번에 받는다.
				
	}	
}
