package kr.co.career.dto;

import java.util.HashMap;
import java.util.Map;

public class pageUtil {
	public static Map<String, Object> getPageData(int totalNum, int countPerPage, int currentPage){
		Map<String, Object> map = new HashMap<String, Object>();
		
		//총게시물 수
		int totalPage = (totalNum%countPerPage==0)?totalNum/countPerPage:totalNum/countPerPage+1;
		
		//현재페이지의 게시물 시작번호
		//3페이지 게시물 시작번호
		//(3-1)*10+1 : 21
		int startNo = (currentPage-1)*countPerPage+1;
		
		// 현재 페이지의 게시물 끝번호
		int endNo = (currentPage)*countPerPage;
		
		// 시작 페이지번호
		int startPageNo = currentPage-5<=0?1:currentPage-5;
		
		// 끝 페이지
		int endPageNo = startPageNo+5>=totalPage?totalPage:startPageNo+4;
		
		// 이전
		boolean prev = currentPage>1?true:false;
		// 다음
		boolean next = currentPage<totalPage?true:false;
		
		map.put("currentPage", currentPage);
		map.put("totalPage", totalPage);
		map.put("startNo", startNo);
		map.put("endNo", endNo);
		map.put("startPageNo", startPageNo);
		map.put("endPageNo", endPageNo);
		map.put("prev", prev);
		map.put("next", next);
		
		System.out.println(map);
		
		return map;
	}
}
