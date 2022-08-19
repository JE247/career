package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.SearchPagingDTO;

@Mapper
@Repository
public interface CompDetailDao {
	List<CompDetailDto> selectOne(int cno);
	List<CompDetailDto> selectCompList();
	List<CompDetailDto> searchCompList(String cname);
	List<CompDetailDto> selectPopular();
	List<CompDetailDto> selectAnnual();
	List<CompDetailDto> searchResult(String cname);
	void hit(int cno);
	List<CompDetailDto> searchResultPaging(SearchPagingDTO pageDto);
}
