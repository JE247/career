package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.ReviewDto;

@Mapper
@Repository
public interface CompReviewDao {
	void insertOne(int mno, int cno, int score, String contents, String title);
	List<ReviewDto> searchReview(int mno);
	List<ReviewDto> searchReviewComp(int cno);
	List<ReviewDto> searchReviewCompPage(int cno, int startNo, int countPerPage);
	void updateOne(int mno, int cno, int score, String contents, String title);
	int getTotal(int cno);
	float getAVG(int cno);
	void deleteOne(int reviewno);
}
