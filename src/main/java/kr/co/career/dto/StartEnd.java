package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StartEnd {
	private String category;
	private String btitle;
	private int cno;
	private int startNo;
	private int countPerPage;
	private String id;
}
