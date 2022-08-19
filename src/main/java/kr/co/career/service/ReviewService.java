package kr.co.career.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.dao.ReviewDao;
import kr.co.career.dto.ReviewDto;

@Service
public class ReviewService {

	@Autowired
	ReviewDao reviewDao;
	
	public List<ReviewDto> findReview(int mno){
		return reviewDao.myReview(mno);
	}
}
