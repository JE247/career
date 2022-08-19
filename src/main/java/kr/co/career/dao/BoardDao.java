package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.BoardDto;
import kr.co.career.dto.BoardWriter;

@Mapper
@Repository
public interface BoardDao {
	
	
	List<BoardDto> selectBoardAll(String category, int startNo, int countPerPage);
	List<BoardDto> selectBoard(String category, int startNo, int countPerPage);
	
	int findBno(int mno);
	
	BoardDto selectOne(int bno);
	
	void addOne(BoardDto dto);
	void updateOne(BoardDto dto);
	int getCategoryTotal(String category);
	int getTotal();
	List<BoardWriter> selectBoardWriterAll(String category, int startNo, int countPerPage);
	List<BoardWriter> selectBoardWriter(String category, int startNo, int countPerPage);
	List<BoardDto> selectTopicBest();
	List<BoardDto> selectByCategory(String category);
	
	List<BoardDto> findMyboard(int mno);
	
	void deleteOne(int bno);
	
	int getSearchTotal(String btitle);
	
	List<BoardDto> searchBoardAll(String category, String btitle, int startNo, int countPerPage);
	List<BoardDto> searchBoard(String category, String btitle, int startNo, int countPerPage);
	List<BoardWriter> searchBoardWriterAll(String category, String btitle, int startNo, int countPerPage);
	List<BoardWriter> searchBoardWriter(String category, String btitle, int startNo, int countPerPage);
	void boardRaise(int bno);
	BoardWriter getMember(int bno);
	int getBoardLike(int bno);
	int getBoardReply(int bno);
	List<BoardWriter> selectBoardWriterBest();
}

