package kr.co.career.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.yaml.snakeyaml.util.UriEncoder;

import kr.co.career.dao.ScrapDao;
import kr.co.career.dto.ScrapDto;

@RestController
public class SaraminApi {

	@Autowired
	ScrapDao dao;

	public Map<String, Object> list(String keyword, String category, String page, int mno) {

		Map<String, Object> map = new HashMap<String, Object>();

//		String accessKey = "YykQ2dYrMXNCem5bg034ekklZTRLjhTGK77Q0RoVoNFhxFVDdzm"; // 발급받은 accessKey";
		String accessKey="iuIag2Etf9G4AKsPX8NeAeuNAvVNfJLUMqbJF5FqSx6UnG86UBccK"; // 발급받은 accessKey";

		try {
			String text = URLEncoder.encode(keyword, "UTF-8");
			String jobcode = URLEncoder.encode(category, "UTF-8");
			String pageNum = URLEncoder.encode(page, "UTF-8");
			String sort = URLEncoder.encode("ac", "UTF-8");

			StringBuffer apiURL = new StringBuffer();

			apiURL.append("https://oapi.saramin.co.kr/job-search?access-key=" + accessKey);
			apiURL.append("&keywords=" + text);
			apiURL.append("&job_mid_cd=" + jobcode);
			apiURL.append("&start=" + pageNum);
			apiURL.append("&fields=expiration-date+count");
			apiURL.append("&sort=" + sort);
			
			URL url = new URL(apiURL.toString());
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Accept", "application/json");

			int responseCode = con.getResponseCode();
			BufferedReader br;

			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}

			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();

			// 필요한 결과 추출

			JSONArray newList = new JSONArray();

			JSONParser jsonParse = new JSONParser();

			JSONObject result = (JSONObject) jsonParse.parse(response.toString());

			JSONObject jobs = (JSONObject) result.get("jobs");
			JSONArray jobArray = (JSONArray) jobs.get("job");

			map.put("totalResult", jobs.get("total"));

			for (int i = 0; i < jobArray.size(); i++) {

				JSONObject job = (JSONObject) jobArray.get(i);

				JSONObject company = (JSONObject) job.get("company");
				JSONObject detail = (JSONObject) company.get("detail");

				JSONObject position = (JSONObject) job.get("position");
				JSONObject experienceLevel = (JSONObject) position.get("experience-level");
				JSONObject requiredEducationLevel = (JSONObject) position.get("required-education-level");
				JSONObject location = (JSONObject) position.get("location");

				String jobId = job.get("id").toString();
				String jobUrl = job.get("url").toString();
				String jobRead = (String) job.get("read-cnt");
				String jobExpir = (String) job.get("expiration-date");
				jobExpir = jobExpir.substring(0, 10);
				String jobTitle = (String) position.get("title");
				String jobCompany = (String) detail.get("name");
				String jobLocation =  ((String) location.get("name")).replace(" &gt;", "");
				
				if(jobLocation.length() > 50) {
					
					jobLocation = jobLocation.substring(0,50) + "...";
				}
				
				String jobExperienceLevel = (String) experienceLevel.get("name");
				String jobRequiredEducationLevel = (String) requiredEducationLevel.get("name");

				// String jobImage = imageCrawling(jobCompany);

				JSONObject listItem = new JSONObject();

				listItem.put("id", jobId);
				listItem.put("url", jobUrl);
				listItem.put("read", jobRead);
				listItem.put("expir", jobExpir);
				listItem.put("title", jobTitle);
				listItem.put("company", jobCompany);
				// listItem.put("image", jobImage);
				listItem.put("location", jobLocation);
				listItem.put("experience", jobExperienceLevel);
				listItem.put("education", jobRequiredEducationLevel);

				boolean isBookmark = false;

				if (mno != 0) {
					ScrapDto dto = new ScrapDto();
					dto.setMno(mno);
					dto.setApplynum(Integer.parseInt(jobId));

					List<ScrapDto> scrapList = dao.findScrap(dto);

					if (scrapList.size() != 0) {
						isBookmark = true;
					}
				}

				listItem.put("isBookmark", isBookmark);
				newList.add(listItem);
			}

			map.put("list", newList);

		} catch (Exception e) {
			System.out.println(e);
		}

		return map;
	}

	public Map<String, Object> myList(int mno, int applynum) {

		Map<String, Object> map = new HashMap<String, Object>();

//		String accessKey = "YykQ2dYrMXNCem5bg034ekklZTRLjhTGK77Q0RoVoNFhxFVDdzm"; // 발급받은 accessKey";
		String accessKey="iuIag2Etf9G4AKsPX8NeAeuNAvVNfJLUMqbJF5FqSx6UnG86UBccK"; // 발급받은 accessKey";

		try {
			String applyId = URLEncoder.encode(applynum + "", "UTF-8");

			StringBuffer apiURL = new StringBuffer();

			apiURL.append("https://oapi.saramin.co.kr/job-search?access-key=" + accessKey);
			apiURL.append("&id=" + applyId);
			apiURL.append("&fields=expiration-date+count");

			URL url = new URL(apiURL.toString());
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Accept", "application/json");

			int responseCode = con.getResponseCode();
			BufferedReader br;

			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}

			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();

			// 필요한 결과 추출
			JSONParser jsonParse = new JSONParser();

			JSONObject result = (JSONObject) jsonParse.parse(response.toString());

			JSONObject jobs = (JSONObject) result.get("jobs");
			JSONArray jobArray = (JSONArray) jobs.get("job");

			if (jobArray.size() != 0) {
				JSONObject job = (JSONObject) jobArray.get(0);
				JSONObject company = (JSONObject) job.get("company");
				JSONObject detail = (JSONObject) company.get("detail");

				JSONObject position = (JSONObject) job.get("position");
				JSONObject experienceLevel = (JSONObject) position.get("experience-level");
				JSONObject requiredEducationLevel = (JSONObject) position.get("required-education-level");
				JSONObject location = (JSONObject) position.get("location");

				String jobId = job.get("id").toString();
				String jobUrl = job.get("url").toString();
				String jobRead = (String) job.get("read-cnt");
				String jobExpir = (String) job.get("expiration-date");
				jobExpir = jobExpir.substring(0, 10);
				String jobTitle = (String) position.get("title");
				String jobCompany = (String) detail.get("name");
				String jobLocation = ((String) location.get("name")).replace(" &gt;", "").split(",")[0];
				String jobExperienceLevel = (String) experienceLevel.get("name");
				String jobRequiredEducationLevel = (String) requiredEducationLevel.get("name");

				map.put("id", jobId);
				map.put("url", jobUrl);
				map.put("read", jobRead);
				map.put("expir", jobExpir);
				map.put("title", jobTitle);
				map.put("company", jobCompany);
				map.put("location", jobLocation);
				map.put("experience", jobExperienceLevel);
				map.put("education", jobRequiredEducationLevel);

				map.put("isBookmark", true);
			} else {
				ScrapDto dto = new ScrapDto();
				dto.setMno(mno);
				dto.setApplynum(applynum);
				
				dao.deleteScrap(dto);
			}

		} catch (Exception e) {
			System.out.println(e);
		}

		return map;
	}

	public String imageCrawling(String companyName) {

		String url = "https://www.saramin.co.kr/zf_user/company-search?page=1&searchWord="
				+ UriEncoder.encode(companyName);

		String imgSrc = "https://www.saraminimage.co.kr/sri/company/ico/ico_ci_empty.png";
		Connection conn = Jsoup.connect(url);
		try {
			Document doc = conn.get();

			Elements imageUrlElements = doc.select(
					"#content > div.wrap_company_search > div > div.list_company_search > div.wrap_list > div:nth-child(1) > a > span > img");

			if (imageUrlElements.size() != 0) {
				Element element = imageUrlElements.get(0);
				imgSrc = element.attr("abs:src");
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return imgSrc;
	}
}
