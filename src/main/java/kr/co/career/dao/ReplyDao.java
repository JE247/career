package kr.co.career.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.GoodDto;
import kr.co.career.dto.ReplyDto;
import kr.co.career.dto.ReplyMemberDto;

@Mapper
@Repository
public interface ReplyDao {
	int selectOne(int rno);
	void addReply(ReplyDto rdto);
	int getMaxRef(int bno);
	List<ReplyMemberDto> getReplyAll(int bno);
	ReplyDto getReplyOne(int replyNo);
	int isReplyChild(int bno, int ref);
	void deleteOne(int replyNo);
	void deleteUpdate(int replyNo);
	GoodDto getLike(int bno, int mno);
	void updateLike(GoodDto gdto);
	void insertGoodOne(int bno, int mno);
	void deleteGood(int bno);
	int getMaxRefOrder(int ref, int bno);
	void modifyReply(ReplyDto rdto);
	int getReplyDeletedOne(int ref, int bno);
}
