package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.FileDto;

@Mapper
@Repository
public interface FileDao {
	
	List<String> selectAll();
	
	void addOne(FileDto dto);
	void deleteBno(int bno);
}
