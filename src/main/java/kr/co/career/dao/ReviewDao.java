package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.ReviewDto;

@Mapper
@Repository
public interface ReviewDao {

	public List<ReviewDto> myReview(int mno);
}
