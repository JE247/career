package kr.co.career.control;

import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.career.dto.MemberDTO;
import kr.co.career.security.PrincipalDetails;
import kr.co.career.service.RegisterService;

@Controller
public class LoginController {

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	public JavaMailSender javaMailSender;

	@Autowired
	RegisterService rService;

//	@Secured("ROLE_USER") // 특정 메소드에 간단하게 걸 수 있다.
//	@PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
	@GetMapping("/career/public")
	@ResponseBody
	public String allpublic() {
		return "공용";
	}

	@GetMapping("/user/public")
	@ResponseBody
	public String user(@AuthenticationPrincipal PrincipalDetails principalDetails) {

		System.out.println("principalDetails : " + principalDetails.getDto());
		return "유저";
	}

	@GetMapping("/admin/public")
	@ResponseBody
	public String admin() {
		return "관리자";
	}

	@GetMapping("/career/login")
	public String login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "exception", required = false) String exception, Model model) {

		model.addAttribute("error", error);
		model.addAttribute("exception", exception);

		return "career/login";
	}

	@GetMapping("/career/logout")
	public String logout(HttpServletRequest req, HttpServletResponse resp) {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		if (auth != null) {
			new SecurityContextLogoutHandler().logout(req, resp, auth);
		}

		return "redirect:/career/main";

	}

	@PostMapping("/career/forgotPass")
	public @ResponseBody String findPass(@ModelAttribute MemberDTO dto) {

		MemberDTO member = rService.findPass(dto);

		if (member == null) {
			return "0";
		}

		String code = UUID.randomUUID().toString().substring(0, 6);

		SimpleMailMessage simpleMessage = new SimpleMailMessage();
		simpleMessage.setFrom("career1247@naver.com"); // NAVER, DAUM, NATE일 경우 넣어줘야 함
		simpleMessage.setTo(member.getEmail());
		simpleMessage.setSubject("Career 임시 비밀번호 입니다.");
		simpleMessage.setText("임시 인증번호 : " + code);
		
		member.setOriginpw(code);
		member.setPassword(bCryptPasswordEncoder.encode(code));

		rService.updateInfo(member);

		javaMailSender.send(simpleMessage);

		return "1";
	}
}
