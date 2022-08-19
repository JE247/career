package kr.co.career.control;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import kr.co.career.api.CompMainApi;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.LocalDto;
import kr.co.career.dto.SearchPagingDTO;
import kr.co.career.dto.pageUtil;
import kr.co.career.security.PrincipalDetails;
import kr.co.career.service.CompDetailService;
import kr.co.career.service.LocalService;
import kr.co.career.service.MainService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {
	@Autowired
	MainService ms;
	@Autowired
	CompDetailService cs;

	@Autowired
	LocalService ls;

	@Autowired
	CompMainApi compApi;

	@RequestMapping(value = { "/", "/career/main" })
	public String showMain(Model model, @AuthenticationPrincipal PrincipalDetails principalDetails)
			throws IOException, ParserConfigurationException, SAXException {
		List<CompDetailDto> popularList = ms.selectPopular();
		List<CompDetailDto> selectAnnual = ms.selectAnnual();

		List<LocalDto> sidoList = ls.findSido();
		List<LocalDto> sigunguList = ls.findSigungu(11);

		model.addAttribute("popularList", popularList);

		model.addAttribute("selectAnnual", selectAnnual);

		for (CompDetailDto dto : selectAnnual) {
			if (dto.getCphoto().isEmpty()) {
				dto.setCphoto(null);
			}
			dto.setCsal(Math.round(dto.getCsal() / 10000));
		}

		model.addAttribute("sidoList", sidoList);
		model.addAttribute("selectAnnual", selectAnnual);

		model.addAttribute("sigunguList", sigunguList);

		// 스크랩 리스트
		int mno = 0;
		if (principalDetails != null) {
			mno = principalDetails.getDto().getMno();
		}

		List<CompDetailDto> scrapList = new ArrayList<>();
		for (int i = 0; i < cs.selectAllWishList(mno).size(); i++) {
			CompDetailDto cdto = cs.selectOne(cs.selectAllWishList(mno).get(i).getCno()).get(0);

			if (cdto.getCaddrs().length() > 12) {
				cdto.setCaddrs(cdto.getCaddrs().substring(0, 11) + "...");
			}

			scrapList.add(cdto);
		}
		model.addAttribute("scrapList", scrapList);
		model.addAttribute("scrapSize", cs.selectAllWishList(mno).size());

		return "career/main";

	}

	@RequestMapping("/career/nav")
	public String nav(@AuthenticationPrincipal PrincipalDetails principaldetails, Model model) {

		boolean isLogin = false;
		boolean isAdmin = false;
		String nickname = null;
		if (principaldetails != null) {
			isLogin = true;
			nickname = principaldetails.getDto().getNickname();

			if (principaldetails.getDto().getRole().equals("ROLE_ADMIN")) {
				isAdmin = true;
			}
		}
		if (principaldetails != null) {
			model.addAttribute("mno", principaldetails.getDto().getMno());
			if(principaldetails.getDto().getCompany() != null) {
				model.addAttribute("cno", cs.searchCompList(principaldetails.getDto().getCompany()).get(0).getCno());
				model.addAttribute("cname", cs.searchCompList(principaldetails.getDto().getCompany()).get(0).getCname());
			}
			if (!cs.searchReview(principaldetails.getDto().getMno()).isEmpty()) {
				model.addAttribute("score", cs.searchReview(principaldetails.getDto().getMno()).get(0).getScore());
				model.addAttribute("title", cs.searchReview(principaldetails.getDto().getMno()).get(0).getTitle());
				model.addAttribute("contents",
						cs.searchReview(principaldetails.getDto().getMno()).get(0).getRcontents());
			}
		}
//		System.out.println("model : "+model);

//		System.out.println("isLogin_nav : " + isLogin);
		model.addAttribute("nickname", nickname);
		model.addAttribute("isLogin", isLogin);
		model.addAttribute("isAdmin", isAdmin);

		return "main/nav";
	}

	@RequestMapping("/career/result")
	public String search(@RequestParam(value = "searchText", defaultValue = "") String cname,
			@RequestParam(value = "checkCode", defaultValue = "") int[] code, Model model,
			@RequestParam(value = "page", defaultValue = "1") int page) {

		List<CompDetailDto> searchResult = new ArrayList();
		
		List<CompDetailDto> searchResultPage = new ArrayList();
		Map<String, Object> searchMap = new HashMap<String, Object>();
		List<LocalDto> searchList = new ArrayList<LocalDto>();
		
		Map<String, List> sigunguListAll = new HashMap<String, List>();
		
		String[] local = new String[code.length]; 
		

		if (code.length != 0) {

			int index = 0;

			for (int a : code) {
				
				int sido = Integer.parseInt(("" + a).substring(0, 2));
				int sigungo = Integer.parseInt(("" + a).substring(2, 5));

				LocalDto dto = new LocalDto();

				dto.setSido(sido);
				dto.setSigungu(sigungo);
				dto.setSidoname(cname);
				
				LocalDto resultDto = null;
				
				if(sigungo != 0) {
					resultDto = ls.selectSidoName(dto);
					local[index] = resultDto.getSidoname() + " > " + resultDto.getSigunguname();
				} else {
					local[index] = ls.findSigungu(sido).get(0).getSidoname() + " > " + "전체";
				}
				
				
				index++;
				
				searchList.add(dto);

				if(sido != 11) {
					List<LocalDto> sigunguList = ls.findSigungu(sido);
					sigunguListAll.put(""+sido, sigunguList);
				}
				
			}
			
			searchResult = ls.filterLocal(searchList);
			
			searchMap.put("searchList", searchList);
			searchMap.put("startNo", (page-1)*10);
			searchMap.put("countPerPage", 10);
			
			searchResultPage = ls.filterLocalPage(searchMap);
			
		} else {
			searchResult = ms.searchResult(cname);
			
			SearchPagingDTO pageDto = new SearchPagingDTO();
			pageDto.setCname(cname);
			pageDto.setCountPerPage(10);
			pageDto.setStartNo((page-1)*10);
			
			searchResultPage = ms.searchResultPage(pageDto);

		}
		
		for (CompDetailDto dto : searchResultPage) {
			if (dto.getCphoto().isEmpty()) {
				dto.setCphoto(null);
			}
		}

		List<LocalDto> sidoList = ls.findSido();
		List<LocalDto> sigunguList = ls.findSigungu(11);

		model.addAttribute("sidoList", sidoList);
		model.addAttribute("sigunguList11", sigunguList);
		model.addAttribute("sigunguListAll", sigunguListAll);

		int totalList = searchResult.size();
		int pageNum = (totalList % 10 == 0) ? totalList / 10 : totalList / 10 + 1;

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

		model.addAttribute("Result", searchResultPage);
		model.addAttribute("searchWord", cname);
		model.addAttribute("ResultCount", searchResult.size());

		model.addAttribute("startNum", startPageNum);
		model.addAttribute("endNum", endPageNum);
		model.addAttribute("cp", page);
		model.addAttribute("next", next);
		model.addAttribute("prev", prev);
		
		model.addAttribute("code", code);
		model.addAttribute("local", local);

		return "career/result";
	}

	@PostMapping("/career/main/ajax")
	public @ResponseBody String localResult(@RequestParam("sido") int sido) {

		List<LocalDto> sigunguList = ls.findSigungu(sido);

		JSONArray localList = new JSONArray();

		for (LocalDto dto : sigunguList) {

			JSONObject local = new JSONObject();

			local.put("sigungu", dto.getSigungu());
			local.put("sigunguname", dto.getSigunguname());

			localList.add(local);

		}

		return localList.toJSONString();

	}

	@RequestMapping("/comp/viewReview")
	public String reviewView() {
		return "comp/compReview";
	}

	@RequestMapping("/career/footer")
	public String footer() {
		return "main/footer";
	}

}
