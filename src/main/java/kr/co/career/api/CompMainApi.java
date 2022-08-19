package kr.co.career.api;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

@RestController
public class CompMainApi {

//	String serviceKey = "0WnZ1X3AirbLGnm8J8sAvdROFtGQRpq1gvCaM4u2T9ecDb9dOI1nIW5l8vX3TUzbyRTG3CBC9Oqx7AluOQJV6w%3D%3D";
	String serviceKey = "GZcWZfpsVUSB%2FeQJYL93SjNNvtQqRG%2B6OjkPTXud8HaOWvGLQ5T2JvlRpcscgsOonUp4cbhUZnU7kIBhl6R5xg%3D%3D";

	private static String getTagValue(String tag, Element eElement) {
		NodeList nlList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
		Node nValue = (Node) nlList.item(0);
		if (nValue == null)
			return null;
		return nValue.getNodeValue();
	}

	public String productDetail(@RequestParam(value = "name", required = false) String name,
			@RequestParam(value = "bizno", required = false) String bizno)
			throws IOException, ParserConfigurationException, SAXException {

//		HashMap<String, String> map = new HashMap<>();
//		ModelAndView mav = new ModelAndView();

		String seq = "";
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document document = builder
				.parse("http://apis.data.go.kr/B552015/NpsBplcInfoInqireService/getBassInfoSearch?serviceKey="
						+ serviceKey + "&wkpl_nm=" + URLEncoder.encode(name, "UTF-8") + "&bzowr_rgst_no="
						+ URLEncoder.encode(bizno, "UTF-8") + "&numOfRows=30");
		document.getDocumentElement().normalize();
//    		System.out.println("Root element: " + document.getDocumentElement().getNodeName());
		NodeList nList = document.getElementsByTagName("item");
//    		System.out.println("파싱할 리스트 수 : "+ nList.getLength());
		System.out.println(nList);
		int dataCrtYm = 0;
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {

				Element eElement = (Element) nNode;

				if (Integer.parseInt(getTagValue("dataCrtYm", eElement)) > dataCrtYm) {
					dataCrtYm = Integer.parseInt(getTagValue("dataCrtYm", eElement));
//    				System.out.println(dataCrtYm);
//					map.put("bizNo", getTagValue("bzowrRgstNo", eElement));
//					map.put("dataCrtYm", getTagValue("dataCrtYm", eElement).substring(0, 4) + "."
//							+ getTagValue("dataCrtYm", eElement).substring(4));
//					map.put("siDo", getTagValue("ldongAddrMgplDgCd", eElement));
//					map.put("siGunGu", getTagValue("ldongAddrMgplSgguCd", eElement));
//					map.put("eupMueonDong", getTagValue("ldongAddrMgplSgguEmdCd", eElement));
					seq = getTagValue("seq", eElement);
//					map.put("seq", );
//					map.put("subStatus", getTagValue("wkplJnngStcd", eElement));
//					map.put("compName", getTagValue("wkplNm", eElement));
//					map.put("addr", getTagValue("wkplRoadNmDtlAddr", eElement));
//					map.put("sectorCode", getTagValue("wkplStylDvcd", eElement));
				}
			}
		}

//		mav.addObject("seq", productDetail(map.get("seq")));
//		mav.addObject("period", productByPeriod(map.get("seq")));
//		mav.addObject("map", map);
		return seq;
	}

	public long productDetail(String seq) throws IOException, ParserConfigurationException, SAXException {

		//HashMap<String, String> map = new HashMap<>();
		long totalSal = 0;
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document document = builder
				.parse("http://apis.data.go.kr/B552015/NpsBplcInfoInqireService/getDetailInfoSearch?serviceKey="
						+ serviceKey + "&seq=" + seq);
		document.getDocumentElement().normalize();
		NodeList nList = document.getElementsByTagName("body");
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {

				Element eElement = (Element) nNode;
				int adpDt = Integer.parseInt(getTagValue("adptDt", eElement).substring(0, 4));

				LocalDate now = LocalDate.now();
				int year = now.getYear();
				int diffYear = year - adpDt;
//				map.put("adptDt", String.valueOf(adpDt));
//				map.put("diffYear", String.valueOf(diffYear));
//				map.put("totalmem",
//						String.valueOf(getTagValue("jnngpCnt", eElement)).replaceAll("\\B(?=(\\d{3})+(?!\\d))", ","));
//				map.put("monthPay", getTagValue("crrmmNtcAmt", eElement));
				
				System.out.println("고지금액 : " + getTagValue("crrmmNtcAmt", eElement));
				System.out.println("명수 : " + Double.parseDouble(getTagValue("jnngpCnt", eElement)));
				double sal = (Double.parseDouble(getTagValue("crrmmNtcAmt", eElement))
						/ Double.parseDouble(getTagValue("jnngpCnt", eElement))) * 12 * 100 / 9;
				int intsal = (int) sal;
				String stringSal = String.valueOf(intsal).substring(0, String.valueOf(intsal).length()-4);
				//String finalSal = stringSal.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",");
				totalSal = Long.parseLong(stringSal);
			}
		}
//		ModelAndView mav = new ModelAndView();
//		mav.addObject("seq", map);
		return totalSal;
	}

	public ModelAndView productByPeriod(@RequestParam(value = "seq", required = false) String seq) throws ParserConfigurationException, SAXException, IOException {

		HashMap<String, String> map = new HashMap<>();

		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document document = builder
				.parse("http://apis.data.go.kr/B552015/NpsBplcInfoInqireService/getPdAcctoSttusInfoSearch?serviceKey="
						+ serviceKey + "&seq=" + seq);
		document.getDocumentElement().normalize();
		NodeList nList = document.getElementsByTagName("body");
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {

				Element eElement = (Element) nNode;
				map.put("inMem", String.valueOf(Integer.parseInt(getTagValue("nwAcqzrCnt", eElement))).replaceAll("\\B(?=(\\d{3})+(?!\\d))", ","));
				map.put("outMem", String.valueOf(Integer.parseInt(getTagValue("lssJnngpCnt", eElement))).replaceAll("\\B(?=(\\d{3})+(?!\\d))", ","));
			}
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("period", map);

		return mav;
	}
}