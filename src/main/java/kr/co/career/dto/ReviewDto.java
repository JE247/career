package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReviewDto {
	private int reviewno;
	private int cno;
	private int mno;
	private int score;
	private String rcontents;
	private String title;
	private String date;
	
}
