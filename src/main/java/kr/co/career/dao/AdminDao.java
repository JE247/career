package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.MemberDTO;

@Mapper
@Repository
public interface AdminDao {
	List<MemberDTO> selectAll();
	List<MemberDTO> selectOne(int mno);
	void deleteBoard(int mno);
	void deleteGood(int mno);
	void deleteReview(int mno);
	void deleteScrap(int mno);
	void deleteWishList(int mno);
	void deleteOne(int mno);
	void deleteFile(int mno);
	void updateOne(int mno, String username, String password, String email, String nickname);
	int getTotalMem();
	List<MemberDTO> selectAllPage(int startNo, int countPerPage);
	int searchTotal(String id);
	List<MemberDTO> searchID(int startNo, int countPerPage, String id);
}
