package kr.co.career.control;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
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

import kr.co.career.dto.BoardDto;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.MemberDTO;
import kr.co.career.dto.ReviewDto;
import kr.co.career.security.PrincipalDetails;
import kr.co.career.service.BoardService;
import kr.co.career.service.CompDetailService;
import kr.co.career.service.RegisterService;
import kr.co.career.util.MyInfoUtil;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	BoardService boardService;

	@Autowired
	RegisterService registerService;

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	MyInfoUtil myinfoUtil;

	@Autowired
	CompDetailService compService;

	/* 글쓰기 관련 control */

	@GetMapping("/talk/write")
	public String writeForm() {
		return "talk/writeForm";
	}

	@PostMapping("/talk/write")
	public String save(BoardDto dto, @AuthenticationPrincipal PrincipalDetails principalDetails) {
		dto.setMno(principalDetails.getDto().getMno());
		boardService.add(dto);
		return "redirect:/talk/list";
	}

	@GetMapping("/talk/update")
	public String updateForm(@RequestParam("bno") int bno, Model model) {
		String[] category = { "잡담", "회사생활", "이직커리어", "투자" };
		model.addAttribute("dto", boardService.selectOne(bno));
		model.addAttribute("category", category);
		return "talk/updateForm";
	}

	@PostMapping("/talk/update")
	@ResponseBody
	public void update(BoardDto dto) {
		boardService.update(dto);
	}

	@PostMapping("/talk/select/ajax")
	@ResponseBody
	public String selectOne(@RequestParam("bno") int bno) {
		BoardDto dto = boardService.selectOne(bno);
		JSONObject object = new JSONObject();

		object.put("category", dto.getCategory());
		object.put("title", dto.getBtitle());
		object.put("contents", dto.getBcontents());

		return object.toJSONString();
	}

	@PostMapping("/talk/delete/ajax")
	@ResponseBody
	public String deleteOne(@RequestParam("bno") int bno) {

		boardService.deleteOne(bno);
		return "success";
	}

	/* 마이페이지 관련 control */
	@GetMapping("/career/mypage")
	public String myPage(@AuthenticationPrincipal PrincipalDetails principalDetails, Model model) {

		if (principalDetails == null) {
			return "redirect:/career/main";
		}

		int mno = principalDetails.getDto().getMno();
		MemberDTO dto = registerService.findMyInfo(mno);

		boolean isSNS = false;

		if (dto.getProvider() != null) {
			isSNS = true;
		}

		List<CompDetailDto> compList = myinfoUtil.myInfoCompany(mno);
		List<Map<String, Object>> scrapList = myinfoUtil.myInfoEmploy(mno);

		List<ReviewDto> reviewList = myinfoUtil.myInfoReview(mno);
		List<BoardDto> boardList = myinfoUtil.myInfoBoard(mno);

		model.addAttribute("info", dto);
		model.addAttribute("isSNS", isSNS);

		model.addAttribute("compList", compList);
		model.addAttribute("compListSize", compList.size());

		model.addAttribute("scrapList", scrapList);
		model.addAttribute("scrapListSize", scrapList.size());

		model.addAttribute("reviewList", reviewList);
		model.addAttribute("reviewListSize", reviewList.size());

		model.addAttribute("boardList", boardList);
		model.addAttribute("boardListSize", boardList.size());

		return "career/mypage";
	}

	@RequestMapping("/deleteReview")
	public String deleteReview(@RequestParam("rno") int reviewNo) {

		compService.deleteOneReview(reviewNo);

		return "redirect:/user/career/mypage";

	}

	/* 내 정보 수정 control */
	@PostMapping("/myinfo/update")
	public String updateInfo(@AuthenticationPrincipal PrincipalDetails principalDetails,
			@ModelAttribute MemberDTO dto) {

		MemberDTO newinfo = principalDetails.getDto();
		newinfo.setNickname(dto.getNickname());
		newinfo.setCompany(dto.getCompany());

		String originPassword = dto.getOriginpw();
		newinfo.setOriginpw(originPassword);

		if (originPassword != null) {
			String password = bCryptPasswordEncoder.encode(originPassword);
			newinfo.setPassword(password);
		}
		registerService.updateInfo(newinfo);

		// 세션 정보 초기화하기
		SecurityContextHolder.clearContext();
		// 새로운 dto정보를 UserDtails에 담기 PrincipalDetails는 UserDtails를 구현한 객체이다.
		UserDetails updateDetails = new PrincipalDetails(newinfo);
		// Authentication에 UserDetails정보를 담아주기
		Authentication newAuth = new UsernamePasswordAuthenticationToken(updateDetails, null,
				updateDetails.getAuthorities());
		// 담은 Authentication을 session에 추가해주기
		SecurityContextHolder.getContext().setAuthentication(newAuth);

		return "redirect:/user/career/mypage";
	}

}
