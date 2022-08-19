package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BoardDto {
	private int bno;
	private String btitle;
	private int mno;
	private String bcontents;
	private String bregdate;
	private String category;
	private int bhits;
}
