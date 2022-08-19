package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CompDetailDto {
	private int cno;
	private String cname;
	private int cnum;
	private String caddrs;
	private int sido;
	private int sigungu;
	private int ccode;
	private String ccodename;
	private String cbirth;
	private int totalmem;
	private long csal;
	private int newmem;
	private int leavemem;
	private int chits;
	private String cphoto;
	private int lno;
}
