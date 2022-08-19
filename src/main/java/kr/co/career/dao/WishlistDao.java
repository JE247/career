package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.WishlistDto;

@Mapper
@Repository
public interface WishlistDao {
	List<WishlistDto> selectAll(int mno);
	void insertOne(int mno, int cno);
	void deleteOne(int mno, int cno);
	List<WishlistDto> findScrap(int mno, int cno);
//	List<WishlistDto> selectAllWish(int startNo, int endNo);
	int getTotal();
}
