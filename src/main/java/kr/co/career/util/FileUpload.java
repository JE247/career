package kr.co.career.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import kr.co.career.dao.FileDao;
import kr.co.career.dto.FileDto;
import kr.co.career.service.BoardService;

@Controller
public class FileUpload {

	private String uploadPath;
	
	@PostMapping("talk/upload")
	public void fileUpload(MultipartFile upload,  HttpServletRequest req, HttpServletResponse resp) {

		uploadPath = req.getSession().getServletContext().getRealPath("/WEB-INF/uploadImg");

		OutputStream out = null;
		PrintWriter pw = null;

		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html;charset=utf-8");

		// 난수 생성
		UUID uuid = UUID.randomUUID();
		// 확장자명
		String extension = FilenameUtils.getExtension(upload.getOriginalFilename());

		// 업로드 파일 경로
		String imgUploadPath = uploadPath + File.separator + uuid + "." + extension;

		try {

			// 파일 업로드 구현하기
			byte[] bytes = upload.getBytes();

			out = new FileOutputStream(new File(imgUploadPath));
			out.write(bytes);
			out.flush();

			// ckEditor로 전송
			pw = resp.getWriter();
			String callback = req.getParameter("CKEditorFuncNum");
			String url = "/talk/upload/img/" + uuid + "." + extension;

			pw.println("{\"uploaded\" : true, \"url\" : \"" + url + "\" }");
			pw.flush();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
			if(out != null) {out.close();}
			if(pw != null) {pw.close();}
			}catch(IOException e) {
				e.printStackTrace();
			}
		}
	}
}
