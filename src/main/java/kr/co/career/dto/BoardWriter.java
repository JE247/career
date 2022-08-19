package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BoardWriter {
	private int bno;
	private int mno;
	private String nickName;
	private String company;
	
}