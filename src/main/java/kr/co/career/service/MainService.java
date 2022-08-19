package kr.co.career.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.dao.CompDetailDao;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.SearchPagingDTO;

@Service
public class MainService {
	@Autowired
	CompDetailDao cdao;

	

	public List<CompDetailDto> selectPopular() {
		return cdao.selectPopular();

	}
	public List<CompDetailDto> selectAnnual() {
		return cdao.selectAnnual();
		
	}
	
	public List<CompDetailDto> searchResult(String cname){
		
		return cdao.searchResult(cname);
	}
	public List<CompDetailDto> searchResultPage(SearchPagingDTO pageDto) {
		return cdao.searchResultPaging(pageDto);
	}

}
