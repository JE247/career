package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.ScrapDto;

@Mapper
@Repository
public interface ScrapDao {
	public List<ScrapDto> findScrap(ScrapDto dto);
	public void insertScrap(ScrapDto dto);
	public void deleteScrap(ScrapDto dto);
	public List<ScrapDto> myScrap(int mno);
}
