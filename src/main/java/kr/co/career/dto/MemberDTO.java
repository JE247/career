package kr.co.career.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemberDTO {
	
	private int mno;
	private String username;
	private String password;
	private String originpw;
	private String nickname;
	private String email;
	private String role;
	private String company;
	private String provider;
	private String providerId;
	
	@Builder
	public MemberDTO(String username, String password, String originpw, String email, String role, String provider,
			String providerId) {
		this.username = username;
		this.password = password;
		this.originpw = originpw;
		this.email = email;
		this.role = role;
		this.provider = provider;
		this.providerId = providerId;
	}
	
}