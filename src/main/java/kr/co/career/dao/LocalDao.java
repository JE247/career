package kr.co.career.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.LocalDto;

@Mapper
@Repository
public interface LocalDao {
	List<LocalDto> selectAll();
	LocalDto selectOne(int lno);
	List<LocalDto> selectSido();
	List<LocalDto> selectSigungu(int sido);
	
	List<CompDetailDto> filterLocal(List<LocalDto> list);
	List<CompDetailDto> filterLocalPaging(Map<String, Object> searchMap);
	
	LocalDto selectSidoName(LocalDto dto);
}
