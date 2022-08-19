package kr.co.career.control;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.MemberDTO;
import kr.co.career.security.PrincipalDetails;
import kr.co.career.service.CompDetailService;
import kr.co.career.service.RegisterService;

@Controller
@RequestMapping("/career")
public class RegisterController {
	
	@Autowired
	RegisterService rService;
	
	@Autowired
	CompDetailService cService;
	
	@Autowired
	public JavaMailSender javaMailSender;
	
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;
	
	@GetMapping("/register")
	public String register() {
		return "career/register";
	}
	
	@PostMapping("/register")
	public String join(MemberDTO dto) {
		
		dto.setRole("ROLE_USER");
		
		// 인코더를 해야 시큐리티 로그인을 할 수 있다.
		String rawPassword = dto.getPassword();
		String encPassword = bCryptPasswordEncoder.encode(rawPassword);
		dto.setOriginpw(rawPassword);
		dto.setPassword(encPassword);
		
		rService.addOne(dto);
		
		return "redirect:/career/main";
	}
	
	// 회사명 찾기
	@RequestMapping("/register/searchComp")
	public String searchComp(Model model, @RequestParam(value="keyword", defaultValue="")String cname) {
		
		List<CompDetailDto> cnameList;
		
		if(cname.equals("")) {
			cnameList = cService.compList();
		} else {
			cnameList = cService.searchCompList(cname);
		}
		
		model.addAttribute("cList", cnameList);
		
		return "career/searhComp";
	}
	
	@PostMapping("/register/ajaxIdCheck")
	@ResponseBody
	public int idCheck(@RequestParam("id")String username) {
		
		int result = rService.idCheck(username);
		
		return result;
	}
	
	@PostMapping("/register/ajaxEmailCheck")
	@ResponseBody
	public String emailCheck(@RequestParam("email")String email) {
		
		String code = UUID.randomUUID().toString().substring(0,6);
		
		SimpleMailMessage simpleMessage = new SimpleMailMessage();
		simpleMessage.setFrom("career1247@naver.com"); // NAVER, DAUM, NATE일 경우 넣어줘야 함
		simpleMessage.setTo(email);
		simpleMessage.setSubject("Career 회원가입 인증 코드 입니다.");
		simpleMessage.setText("이메일 인증번호 : " + code);
		
		javaMailSender.send(simpleMessage);
		
		return code;
	}
	
	@RequestMapping("/register/plusInfo")
	public String plusInfo(@AuthenticationPrincipal PrincipalDetails principalDetails) {
		
		if(principalDetails.getDto().getCompany() == null) {
			return "career/registerInfo";
		}
		return "redirect:/career/main";
	}
	
	@PostMapping("/registerInfo/update")
	public String updateInfo(@ModelAttribute("dto")MemberDTO dto, @AuthenticationPrincipal PrincipalDetails principalDetails) {
		
		MemberDTO newinfo = principalDetails.getDto();
		newinfo.setNickname(dto.getNickname());
		newinfo.setCompany(dto.getCompany());
		//dto.setMno(principalDetails.getDto().getMno());
		rService.updateInfo(newinfo);
		
		// 세션 정보 초기화하기
		SecurityContextHolder.clearContext();
		// 새로운 dto정보를 UserDtails에 담기 PrincipalDetails는 UserDtails를 구현한 객체이다.
		UserDetails updateDetails = new PrincipalDetails(newinfo);
		// Authentication에 UserDetails정보를 담아주기
		Authentication newAuth = new UsernamePasswordAuthenticationToken(updateDetails, null, updateDetails.getAuthorities());
		// 담은 Authentication을 session에 추가해주기
		SecurityContextHolder.getContext().setAuthentication(newAuth);
		
		
		
		
		
		return "redirect:/career/main";
	}
	
}
