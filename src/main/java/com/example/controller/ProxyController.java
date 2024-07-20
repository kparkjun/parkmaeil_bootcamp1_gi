package com.example.controller;

import com.example.entity.Bible;
import com.example.repository.BookMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@RestController
public class ProxyController {

    @Autowired
    private BookMapper mapper;

    @PostMapping("/proxy/date")
    public ResponseEntity<String> getDateData(@RequestBody Map<String, String> dateData) {
        String url = "https://sum.su.or.kr:8888/bible/today/Ajax/Bible/BosyMatter";

        // HTTP 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // 폼 데이터 구성
        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("qt_ty", "QT1");
        map.add("Base_de", dateData.get("date"));
        map.add("bibleType", "1");

        // HTTP 요청 엔티티 생성
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(map, headers);

        // RestTemplate을 사용하여 POST 요청 전송
        RestTemplate restTemplate = new RestTemplate();
        
        // UTF-8 인코딩을 사용하는 StringHttpMessageConverter 추가
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        // 요청 및 응답 처리
        byte[] responseBytes = restTemplate.postForObject(url, requestEntity, byte[].class);
        String response = new String(responseBytes, StandardCharsets.UTF_8);

        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.setContentType(new MediaType("text", "html", StandardCharsets.UTF_8));

        return new ResponseEntity<>(response, responseHeaders, HttpStatus.OK);
    }

    @PostMapping("/proxy/insertBible")
    public ResponseEntity<?> insertBible(@RequestBody Bible bible) {
        try {
            //bibleReflectionService.saveReflection(bibleReflection);\
            mapper.bibleInsert(bible);
            return ResponseEntity.ok().body("{\"success\": true}");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("{\"success\": false}");
        }
    }
    // 추가
    @GetMapping("/proxy/monthly-data")
    public ResponseEntity<?> getMonthlyData(@RequestParam("customerId") String customerId) {
        List<Map<String, Object>> data = mapper.getMonthlyData(customerId);
        return ResponseEntity.ok(data);
    }
}
