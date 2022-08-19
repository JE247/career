package kr.co.career.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.dao.LocalDao;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.LocalDto;

@Service
public class LocalService {

	@Autowired
	LocalDao dao;
	
	public List<LocalDto> selectAll(){
		return dao.selectAll();
	}
	
	public LocalDto selectOne(int lno) {
		return dao.selectOne(lno);
	}
	
	public List<LocalDto> findSido(){
		return dao.selectSido();
	}
	public List<LocalDto> findSigungu(int sido){
		return dao.selectSigungu(sido);
	}
	
	public List<CompDetailDto> filterLocal(List<LocalDto> list){
		return dao.filterLocal(list);
	}

	public List<CompDetailDto> filterLocalPage(Map<String, Object> searchMap) {
		return dao.filterLocalPaging(searchMap);
	}
	
	public LocalDto selectSidoName(LocalDto dto) {
		return dao.selectSidoName(dto);
	}
}
