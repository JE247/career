package kr.co.career.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.dao.CompDetailDao;
import kr.co.career.dao.CompReviewDao;
import kr.co.career.dao.WishlistDao;
import kr.co.career.dto.CompDetailDto;
import kr.co.career.dto.ReviewDto;
import kr.co.career.dto.WishlistDto;

@Service
public class CompDetailService {

	@Autowired
	CompDetailDao cdao;
	@Autowired
	WishlistDao wdao;
	@Autowired
	CompReviewDao rdao;
	
	public List<CompDetailDto> selectOne(int cno){
		return cdao.selectOne(cno);
	}
	
	public List<CompDetailDto> compList(){
		return cdao.selectCompList();
	}
	
	public List<CompDetailDto> searchCompList(String cname){
	 	return cdao.searchCompList(cname);
	}
	
	public List<WishlistDto> selectAllWishList(int mno){
		return wdao.selectAll(mno);
	}
	
	public void insertOneWishList(int mno, int cno) {
		wdao.insertOne(mno, cno);
	}

	public void deleteOneWishList(int mno, int cno) {
		wdao.deleteOne(mno, cno);
	}

	public List<WishlistDto> findScrap(int mno, int cno) {
		return wdao.findScrap(mno, cno);
	}

	/*
	 * public List<WishlistDto> selectAllWish(int startNo, int endNo) { return
	 * wdao.selectAllWish(startNo, endNo); }
	 */
	
	public int getTotal() {
		return wdao.getTotal();
	}

	public float getAVG(int cno) {
		return rdao.getAVG(cno);
	}

	public int getTotalReview(int cno) {
		return rdao.getTotal(cno);
	}
	
	public void insertOneReview(int mno, int cno, int score, String contents, String title) {
		rdao.insertOne(mno, cno, score, contents,title);
	}
	
	public List<ReviewDto> searchReview(int mno){
		return rdao.searchReview(mno);
	}

	public List<ReviewDto> searchReviewComp(int cno){
		return rdao.searchReviewComp(cno);
	}

	public List<ReviewDto> searchReviewCompPage(int cno, int startNo, int countPerPage){
		return rdao.searchReviewCompPage(cno, startNo, countPerPage);
	}
	
	public void updateOneReview(int mno, int cno, int score, String contents, String title) {
		rdao.updateOne(mno, cno, score, contents, title);
	}
	public void deleteOneReview(int reviewno) {
		rdao.deleteOne(reviewno);
	}
	public void hit(int cno) {
		cdao.hit(cno);
	}
	
}
