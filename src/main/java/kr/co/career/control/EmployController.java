package kr.co.career.control;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.career.api.SaraminApi;
import kr.co.career.dao.ScrapDao;
import kr.co.career.dto.ScrapDto;
import kr.co.career.security.PrincipalDetails;

@Controller
public class EmployController {

	@Autowired
	SaraminApi saraminApi;

	@Autowired
	ScrapDao dao;

	@RequestMapping("/career/employlist")
	public String employlist(Model model, @RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "category", defaultValue = "0") String job,
			@AuthenticationPrincipal PrincipalDetails principalDetails) {

		int mno = 0;
		boolean isLogin = false;

		if (principalDetails != null) {
			mno = principalDetails.getDto().getMno();
			isLogin = true;
		}

		String[] category = { "기획/전략", "마케팅/홍보/조사", "회계/세무/재무", "인사/노무/HRD", "총무/법무/사무", "IT개발/데이터", "디자인", "영업/판매/무역",
				"고객상담/TM", "구매/자재/물류", "상품기획/MD", "운전/운송/배송", "서비스", "생산", "건설/건축", "의료", "연구/R&D", "교육", "미디어/문화/스포츠",
				"금융/보험", "공공/복지" };

		int[] code = { 16, 14, 3, 5, 4, 2, 15, 8, 21, 18, 12, 7, 10, 11, 22, 6, 9, 19, 13, 17, 20};
		int[] codePosition = { 12, 14, 19, 20, 7, 18, 3, 11, 13, 6, 8, 22, 10, 9, 17, 21, 2, 4, 16, 5, 15, 21};

		int position = 0;

		for (int i = 0; i < codePosition.length; i++) {
			if (codePosition[i] == Integer.parseInt(job)) {
				position = i;
			}
		}

		if (job.equals("0"))
			job = "";

		Map<String, Object> map = new HashMap<String, Object>();

		for (int i = 0; i < code.length; i++) {
			map.put(category[i], code[i]);
		}

		Map<String, Object> mapList = saraminApi.list(keyword, job, "" + (page - 1), mno);

		int totalList = Integer.parseInt((String) mapList.get("totalResult"));

		int pageNum = (totalList % 10 == 0) ? totalList / 10 : totalList / 10 + 1;

		// 페이지 시작번호, 끝번호 설정하기
		int startPageNum = ((page - 1) / 10) * 10 + 1;
		int endPageNum = startPageNum + 10 - 1;

		if (endPageNum > pageNum) {
			endPageNum = pageNum;
		}

		// 이전 페이지, 다음 페이지
		boolean prev = false;
		boolean next = false;

		if (startPageNum + 10 < pageNum)
			next = true;
		if (endPageNum - 10 > 0)
			prev = true;

		model.addAttribute("map", map);
		model.addAttribute("mapList", mapList);

		model.addAttribute("startNum", startPageNum);
		model.addAttribute("endNum", endPageNum);
		model.addAttribute("cp", page);

		model.addAttribute("isLogin", isLogin);

		model.addAttribute("next", next);
		model.addAttribute("prev", prev);

		// filter값 기억할 수 있도록 설정
		model.addAttribute("txt", keyword);
		model.addAttribute("category", job);
		
		model.addAttribute("position", position);

		return "career/employlist";
	}

	@PostMapping("/career/employee/ajax")
	public @ResponseBody String scrapAjax(@RequestParam("id") int id,
			@AuthenticationPrincipal PrincipalDetails principalDetails) {

		String result = "";

		if (principalDetails != null) {

			ScrapDto dto = new ScrapDto();
			dto.setMno(principalDetails.getDto().getMno());
			dto.setApplynum(id);

			List<ScrapDto> scrapList = dao.findScrap(dto);

			boolean isScrap = false;

			if (scrapList.size() != 0) {
				isScrap = true;
			}

			if (isScrap) {
				dao.deleteScrap(dto);
				result = "delete";
			} else {
				dao.insertScrap(dto);
				result = "insert";
			}
		}

		return result;
	}
}
