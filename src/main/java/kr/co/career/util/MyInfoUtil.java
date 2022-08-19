package kr.co.career.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.api.SaraminApi;
import kr.co.career.dao.ScrapDao;
import kr.co.career.dao.WishlistDao;
import kr.co.career.dto.BoardDto;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.LocalDto;
import kr.co.career.dto.ReviewDto;
import kr.co.career.dto.ScrapDto;
import kr.co.career.dto.WishlistDto;
import kr.co.career.service.BoardService;
import kr.co.career.service.CompDetailService;
import kr.co.career.service.LocalService;
import kr.co.career.service.ReviewService;

@Service
public class MyInfoUtil {
	
	@Autowired
	WishlistDao wishlistDao;
	@Autowired
	CompDetailService compService;
	@Autowired
	LocalService localService;
	@Autowired
	SaraminApi saramin;
	@Autowired
	ScrapDao scrapDao;
	
	@Autowired
	ReviewService reviewService;
	
	@Autowired
	BoardService boardService;
	
	
	/* 마이페이지 정보 가져오는 function */
	public List<Map<String, Object>> myInfoEmploy(int mno) {
		
		List<Map<String, Object>> employList = new ArrayList<Map<String, Object>>();
		
		List<ScrapDto> scrapList = scrapDao.myScrap(mno);
		
		if(scrapList.size() != 0) {
			for(ScrapDto sDto : scrapList) {
				Map<String, Object> employResult = saramin.myList(mno, sDto.getApplynum());
				
				if(employResult.size() != 0) employList.add(employResult);
			}
		}
		return employList;
	}
	
	public List<CompDetailDto> myInfoCompany(int mno) {
		List<WishlistDto> wishList = wishlistDao.selectAll(mno);
		List<CompDetailDto> compList = new ArrayList<CompDetailDto>();
		
		if(wishList.size() != 0) {
			for(WishlistDto wDto : wishList) {
				CompDetailDto compDto = compService.selectOne(wDto.getCno()).get(0);
				
				if(compDto.getCphoto() == null) {
					compDto.setCphoto("/img/company.png");
				}
				
				if(compDto.getCname().length() > 7) {
					compDto.setCname(compDto.getCname().substring(0, 6) + "...");
				}
				
				LocalDto localDto = localService.selectOne(compDto.getLno());
				compDto.setCaddrs(localDto.getSidoname() + " " +localDto.getSigunguname());
				compList.add(compDto);
			}
		}
		return compList;
	}
	
	public List<ReviewDto> myInfoReview(int mno){
		return reviewService.findReview(mno);
	}
	
	public List<BoardDto> myInfoBoard(int mno){
		return boardService.findMyboard(mno);
	}

}
