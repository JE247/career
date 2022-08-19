package kr.co.career.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import kr.co.career.dao.BoardDao;
import kr.co.career.dao.FileDao;
import kr.co.career.dao.ReplyDao;
import kr.co.career.dto.BoardDto;
import kr.co.career.dto.BoardWriter;
import kr.co.career.dto.FileDto;
import kr.co.career.dto.GoodDto;
import kr.co.career.dto.ReplyDto;
import kr.co.career.dto.ReplyMemberDto;

@Service
public class BoardService {

	@Autowired
	BoardDao boardDao;

	@Autowired
	FileDao fileDao;
	
	@Autowired
	ReplyDao replyDao;
	
	public List<BoardDto> selectBoardAll(String category, int startNo, int countPerPage) {
		if (category.equals("all")) {
			return boardDao.selectBoardAll(category, startNo, countPerPage);
		} else if(category.equals("best")) {
			return boardDao.selectTopicBest();
		}else {
			return boardDao.selectBoard(category, startNo, countPerPage);
		}
	}

	public BoardDto selectOne(int bno) {
		BoardDto dto = boardDao.selectOne(bno);
		return dto;
	}

	public void add(BoardDto dto) {

		int mno = dto.getMno();
		boardDao.addOne(dto);

		int bno = boardDao.findBno(mno);

		// 작성한 글 내용 중 이미지 태그 가져오기
		String contents = dto.getBcontents();

		Pattern imgSrcPattern = Pattern.compile("<img[^>]*src=[\\”‘]?([^>\\”‘]+)[\\”‘]?[^>]*>");
		Matcher matcher = imgSrcPattern.matcher(contents);

		while (matcher.find()) {
			String imgSrc = matcher.group();

			// src 경로 가져오기
			Pattern srcPattern = Pattern.compile("src\\s*=\\s*[\\\"']?([^>\\\"']+)[\\\"']?[^>]*(.gif|.jpg|.png|.jpeg)");
			Matcher srcMatcher = srcPattern.matcher(imgSrc);

			while (srcMatcher.find()) {
				String src = srcMatcher.group();
				src = src.substring(22);

				FileDto file = new FileDto();
				file.setBno(bno);
				file.setFimage(src);

				fileDao.addOne(file);
			}
		}
	}

	public void update(BoardDto dto) {

		int mno = 1;

		dto.setMno(mno);
		boardDao.updateOne(dto);

		int bno = dto.getBno();

		// 1. 기존 bno의 image데이터 File 테이블에서 지우기
		fileDao.deleteBno(bno);

		// 2. contents내용에서 파일명 추출한 후 재등록
		String contents = dto.getBcontents();

		Pattern imgSrcPattern = Pattern.compile("<img[^>]*src=[\\”‘]?([^>\\”‘]+)[\\”‘]?[^>]*>");
		Matcher matcher = imgSrcPattern.matcher(contents);

		while (matcher.find()) {
			String imgSrc = matcher.group();

			// src 경로 가져오기
			Pattern srcPattern = Pattern.compile("src\\s*=\\s*[\\\"']?([^>\\\"']+)[\\\"']?[^>]*(.gif|.jpg|.png|.jpeg)");
			Matcher srcMatcher = srcPattern.matcher(imgSrc);

			while (srcMatcher.find()) {
				String src = srcMatcher.group();
				src = src.substring(22);

				FileDto file = new FileDto();
				file.setBno(bno);
				file.setFimage(src);

				fileDao.addOne(file);
			}
		}
	}

	// 일정시간이 되면 File테이블에 저장된 파일목록들과 uploadImg폴더 내에 존재하는 파일들을 비교하여 기존에 삭제된 데이터들을
	// upload폴더에서 지워주기
	@Scheduled(cron = "0 0 10 * * *")
	public void run() throws IOException {

		String path = System.getProperty("user.dir") + "\\src\\main\\webapp\\WEB-INF\\uploadImg\\";
		System.out.println(path);

		String uploadPath = path;

		List<String> list = fileDao.selectAll();

		File dir = new File(uploadPath);

		String[] fileNames = dir.list();

		for (String x : fileNames) {
			if (!list.contains(x)) {
				File file = new File(uploadPath + File.separator + x);
				if (file.exists()) {
					file.delete();
				}
			}
		}
		System.out.println("uploadImg 폴더 정리 완료");
	}

	public String uploadPathReturn(HttpServletRequest req) {
		return req.getSession().getServletContext().getRealPath("/WEB-INF/uploadImg");

	}

	public int getTotal(String category) {
		if (category.equals("all")) {
			return boardDao.getTotal();
		} else {
			return boardDao.getCategoryTotal(category);
		}
	}

	public List<BoardWriter> getMemberList(String category, int startNo, int countPerPage) {
		if (category.equals("all")) {
			return boardDao.selectBoardWriterAll(category, startNo, countPerPage);
		}else if(category.equals("best")) {	
			return boardDao.selectBoardWriterBest();
		}else {
			return boardDao.selectBoardWriter(category, startNo, countPerPage);
		}
	}
	
	public List<BoardDto> findMyboard(int mno){
		return boardDao.findMyboard(mno);
	}
	
	public void deleteOne(int bno) {
		fileDao.deleteBno(bno);
		boardDao.deleteOne(bno);
	}
	
	public List<BoardDto> boardSearch(String category, String btitle, int startNo, int countPerPage){
		if(category.equals("all")) {
			return boardDao.searchBoardAll(category, btitle, startNo, countPerPage);
		}else {
			return boardDao.searchBoard(category, btitle, startNo, countPerPage);
		}		
	}
	
	public int getSearchTotal(String btitle) {
		return boardDao.getSearchTotal(btitle);
	}
	
	public List<BoardWriter> getMemberList(String category, String btitle, int startNo, int countPerPage){
		if (category.equals("all")) {	
			return boardDao.searchBoardWriterAll(category, btitle, startNo, countPerPage);
		} else {
			return boardDao.searchBoardWriter(category, btitle, startNo, countPerPage);
		}
	}
	
	public List<BoardDto> selectTopicBest(){
		return boardDao.selectTopicBest();
	}

	public List<BoardDto> selectByCategory(String category){
		return boardDao.selectByCategory(category);
	}
	
	public void raiseHits(int bno) {
		boardDao.boardRaise(bno);
	}
	
	public BoardWriter getMember(int bno) {
		return boardDao.getMember(bno);
	}
	
	public void addReply(ReplyDto rdto) {
		if(rdto.getStatus()==0) {
			//ref 최대값 가져오기
			int ref = replyDao.getMaxRef(rdto.getBno());
			if(ref == 0) {//초기에 1
				rdto.setRef(1);
				rdto.setRefOrder(0);
			}else {//+1씩 증가
				rdto.setRef(ref+1);
				rdto.setRefOrder(0);
			}
			replyDao.addReply(rdto);			
		}else if(rdto.getStatus() == 1) {		
			replyDao.addReply(rdto);			
		}
	}
	
	// 대댓글용 insert 메서드
	public void addReply(ReplyDto rdto, int replyno) {
		// 부모댓글과 같은 ref로 설정
		int ref = replyDao.getReplyOne(replyno).getRef();
		rdto.setRef(ref);
		
		int reforder = replyDao.getMaxRefOrder(ref, rdto.getBno());
		rdto.setRefOrder(reforder+1);
		
		replyDao.addReply(rdto);
	}
	
	public List<ReplyMemberDto> getReply(int bno){
		return replyDao.getReplyAll(bno);
	}
	
	public int getBoardLike(int bno) {
		return boardDao.getBoardLike(bno);
	}
	public int getBoardReply(int bno) {
		return boardDao.getBoardReply(bno);
	}
	public void deleteReplyOne(int bno, int replyNo) {
		ReplyDto rdto = replyDao.getReplyOne(replyNo);
		if(replyDao.isReplyChild(bno, rdto.getRef()) == 1) {
			replyDao.deleteOne(replyNo);
		}else if(rdto.getStatus() == 1) {// 자식댓글인경우
			if(replyDao.isReplyChild(bno, rdto.getRef()) == 2) {//댓글이 2개남았을 경우
				//부모글선택 삭제	bno에 ref가 같고 refoder가 0이면 부모댓임.
				replyDao.deleteOne(replyDao.getReplyDeletedOne(rdto.getRef(), bno)); 
				replyDao.deleteOne(replyNo);
			}
			replyDao.deleteOne(replyNo);
		}else {
			replyDao.deleteUpdate(replyNo);
		}
		// select count(*) from REPLY where ref = 1 and bno = 33;
		// 로 대댓글 있는지 체크 1이면 삭제 아니면 삭제된 댓글입니다 update satatus = 2 
		
		// 자식댓 삭제할때 2개면 부모댓도 삭제 ref이용해서 삭제
	}
	public GoodDto getLike(int bno, int mno) {	
		return replyDao.getLike(bno, mno);
	}
	public boolean isExistGood(int bno, int mno) {
		if(replyDao.getLike(bno, mno) == null) {
			return false;
		}else {
			return true;
		}
	}
	public void updateLike(GoodDto gdto) {
		// 이미 좋아요일경우 > 취소 아닐경우 dislike = 0으로 설정 
		if(gdto.getLike() == 0) {// 아닐경우
			gdto.setDisLike(0);// 싫어요 취소
			gdto.setLike(1); // 좋아요 
		}else if(gdto.getLike() == 1) { // 이미 눌렀을경우
			gdto.setLike(0); // 싫어요 취소
		}
		replyDao.updateLike(gdto);
	}	
	public void updateDisLike(GoodDto gdto) {
		// 이미 싫어요일경우 > 취소 아닐경우 like = 0으로 설정 
		if(gdto.getDisLike() == 1) {//이미 누른경우
			gdto.setDisLike(0);// 싫어요 취소 
		}else if(gdto.getDisLike() == 0) { //새로 싫어요 누를경우
			gdto.setDisLike(1);
			gdto.setLike(0); // 싫어요 취소
		}
		replyDao.updateLike(gdto);
	}
	public void insertGoodOne(int bno, int mno) {
		replyDao.insertGoodOne(bno, mno);
	}
	public void deleteGood(int bno) {
		replyDao.deleteGood(bno);
	}
	public void modfiyReply(ReplyDto rdto) {
		replyDao.modifyReply(rdto);
	}
}
