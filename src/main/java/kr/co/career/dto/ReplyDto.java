package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReplyDto {
	private int replyNo;
	private int mno;
	private int bno;
	private String rregdate;
	private String comment;
	private int status;
	private int ref;
	private int refOrder;
}
