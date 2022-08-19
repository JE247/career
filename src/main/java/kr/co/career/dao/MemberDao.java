package kr.co.career.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import kr.co.career.dto.MemberDTO;

@Mapper
@Repository
public interface MemberDao {
	int idCheck(String username);
	void addOne(MemberDTO memberdto);
	MemberDTO findByUsername(String username);
	void updateInfo(MemberDTO memberdto);
	MemberDTO findMyInfo(int mno);
	
	MemberDTO findPass(MemberDTO dto);
}

