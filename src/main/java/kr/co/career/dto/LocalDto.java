package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LocalDto {
	private int lno;
	private int sido;
	private int sigungu;
	private String sidoname;
	private String sigunguname;
}
