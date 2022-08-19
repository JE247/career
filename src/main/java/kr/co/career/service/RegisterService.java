package kr.co.career.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.career.dao.MemberDao;
import kr.co.career.dto.MemberDTO;

@Service
public class RegisterService {
	
	@Autowired
	MemberDao mdao;
	
	public void addOne(MemberDTO memberdto) {
		mdao.addOne(memberdto);
	}
	
	public void updateInfo(MemberDTO memberdto) {
		mdao.updateInfo(memberdto);
	}
	
	public MemberDTO findByUsername(String username) {
		return mdao.findByUsername(username);
	}
	
	public int idCheck(String username) {
		int result = mdao.idCheck(username);
		
		return result;
	}
	
	public MemberDTO findMyInfo(int mno) {
		return mdao.findMyInfo(mno);
	}
	
	public MemberDTO findPass(MemberDTO dto) {
		return mdao.findPass(dto);
	}
}

