<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script> <!-- Kakao JavaScript SDK 로드 -->
<style>
  /* 커스텀 스타일 */
  .custom-container {
    padding-right: 15px;
    padding-left: 15px;
  }

  /* 화면 크기에 따라 여백 조정 */
  @media (max-width: 768px) {
    .custom-container {
      padding-right: 5px;
      padding-left: 5px;
    }
  }

  /* 기타 스타일은 동일하게 유지 */
  .card {
    background-color: #f8f9fa;
    border: none;
  }
  .card-header, .card-footer {
    background-color: #007bff;
    color: #ffffff;
  }
  .btn-primary {
    background-color: #28a745;
  }
  .btn-secondary {
    background-color: #6c757d;
  }
  .dotted-line {
    border-bottom: 1px dotted #000;
    padding-bottom: 10px;
    margin-bottom: 10px;
  }
  .badge-secondary {
    background-color: #17a2b8;
  }

  /* 배경색 추가 */
  .login-col {
    background-color: #f0f0f0; /* 밝은 회색 */
  }
  .calendar-col {
    background-color: #e9ecef; /* 조금 더 진한 회색 */
  }
  .reflection-col {
    background-color: #dee2e6; /* 더 진한 회색 */
  }
  </style>
</head>
<body>

<div class="container-fluid mt-5 custom-container">
  <h2>오늘의 QT</h2>
  <div class="card">
    <div class="card-header">QT(말씀 묵상)</div>
    <div class="card-body">
      <!-- 그리드 시스템을 시작하는 행 -->
      <div class="row">
        <!-- 첫 번째 열, 12개 중 2개 열 차지 -->
      <div class="col-12 col-md-2 mb-3 login-col d-flex flex-column">
        <!-- 로그인 폼 -->
        <form>
          <div class="form-group">
            <label for="userId">아이디:</label>
            <input type="text" class="form-control" id="userId" placeholder="아이디 입력" name="userId">
          </div>
          <div class="form-group">
            <label for="password">패스워드:</label>
            <input type="password" class="form-control" id="password" placeholder="패스워드 입력" name="password">
          </div>
          <button type="submit" class="form-control btn btn-primary">로그인</button>
        </form>
      </div>

   <!-- 두 번째 열, 12개 중 7개 열 차지 -->
    <div class="col-12 col-md-7 mb-3 calendar-col d-flex flex-column">
       <!-- 달력 입력 필드 -->
      <label for="calendarInput">날짜 (YYYY-MM-DD):</label>
      <input type="date" id="calendarInput" class="form-control">
       <!-- 선택된 날짜를 표시하는 Card -->
    <div class="card mt-3" id="dateDisplayCard" style="display: none;">
    <div class="card-body">
        <h5 class="card-title" id="selectedDate">선택된 날짜:</h5>
        <h6 id="title">제목: </h6>
        <p id="text">본문: </p>
        <div id="detailList"></div>
    </div>
  </div>
 </div>

<script>
// 페이지 로드 시 오늘 날짜로 초기화
document.addEventListener('DOMContentLoaded', function() {

   var today = new Date();
    var year = today.getFullYear();
    var month = (today.getMonth() + 1).toString().padStart(2, '0');
    var day = today.getDate().toString().padStart(2, '0');
    var formattedDate = year + '-' + month + '-' + day;

    document.getElementById('calendarInput').value = formattedDate;
    goBible(formattedDate);

});

document.getElementById('calendarInput').addEventListener('change', function() {
   var selectedDate = this.value;
   goBible(selectedDate);
});

function goBible(selectedDate){
    document.getElementById('selectedDate').textContent = "선택된 날짜: " + selectedDate;
    document.getElementById('dateDisplayCard').style.display = 'block';
      fetch('${cpath}/proxy/date', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({date: selectedDate})
        })
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');

            const titleElement = document.getElementById('title');
            const textElement = document.getElementById('text');
            const detailList = document.getElementById('detailList');

            // 제목과 본문을 채움
            const bibleTextElement = doc.getElementById('bible_text');
            titleElement.textContent = bibleTextElement ? "제목: " + bibleTextElement.textContent.trim() : "제목: 정보를 찾을 수 없습니다.";

            const bibleInfoElement = doc.getElementById('bibleinfo_box');
            textElement.textContent = bibleInfoElement ? bibleInfoElement.textContent.trim() : "본문: 정보를 찾을 수 없습니다.";

            // 세부 목록을 채움
          detailList.innerHTML = ''; // 기존 내용 초기화
          const bodyListElement = doc.getElementById('body_list');
          if (bodyListElement) {
              const listItems = bodyListElement.querySelectorAll('li');
              listItems.forEach((item, index) => {
                  const num = item.querySelector('.num').textContent.trim();
                  const info = item.querySelector('.info').textContent.trim();

                  const detailItem = document.createElement('div');
                  // 마지막 항목에는 점선을 추가하지 않음
                  if (index < listItems.length - 1) {
                      detailItem.className = 'dotted-line'; // CSS 클래스 적용
                  }
                   // 복사 버튼 추가
                   detailItem.innerHTML = "<span class='badge badge-secondary'>" + num + "</span> " + info +
                   "<button class='btn btn-sm btn-secondary copy-btn' data-info='" + info + "'>C</button>";
                  detailList.appendChild(detailItem);
              });

              // 모든 복사 버튼에 클릭 이벤트 추가
              const copyButtons = detailList.querySelectorAll('.copy-btn');
              copyButtons.forEach(button => {
                  button.addEventListener('click', function() {
                      const info = this.getAttribute('data-info');
                      goCopy(info);
                  });
              });
          }
        })
        .catch(error => console.error('Error:', error));
}

function goCopy(info){
   document.getElementById("kakaoMessage").value = info;
}

// 카카오톡 메시지 전송
function sendKakaoMessage() {
    var message = document.getElementById("kakaoMessage").value;

    if (message === '') {
        alert('카카오톡으로 전송할 메시지를 입력하세요.');
        return;
    }

    Kakao.Link.sendDefault({
        objectType: 'text',
        text: message,
        link: {
            mobileWebUrl: window.location.href,
            webUrl: window.location.href
        }
    });
}

// 카카오톡 SDK 초기화
Kakao.init('f10d309a88d5dce235090b66392a59f0'); // 여기에 발급받은 JavaScript 키를 입력하세요.
</script>

<!-- 세 번째 열, 12개 중 3개 열 차지 -->
<div class="col-12 col-md-3 reflection-col d-flex flex-column">
  <form id="reflectionForm">
    <div class="form-group">
      <label for="godReflection">나의 하나님:</label>
      <input type="text" class="form-control" id="godReflection" name="godReflection">
    </div>
    <div class="form-group">
      <label for="repentance">회개:</label>
      <textarea class="form-control" id="repentance" name="repentance" rows="2"></textarea>
    </div>
    <div class="form-group">
      <label for="insight">깨달음:</label>
      <textarea class="form-control" id="insight" name="insight" rows="2"></textarea>
    </div>
    <div class="form-group">
      <label for="action">실천:</label>
      <textarea class="form-control" id="action" name="action" rows="2"></textarea>
    </div>
    <button type="submit" class="btn btn-primary">등록</button>
    <button type="button" class="btn btn-secondary" onclick="resetForm()">취소</button>
  </form>

  <div class="mt-3">
      <label for="kakaoMessage">카카오톡 메시지:</label>
      <textarea class="form-control mb-2" id="kakaoMessage" rows="7" placeholder="카카오톡으로 전송할 메시지를 입력하세요."></textarea>
      <button type="button" class="btn btn-warning" onclick="sendKakaoMessage()">카카오톡 전송</button>
    </div>

</div>

<script>
// 폼 데이터 초기화 함수
function resetForm() {
    document.getElementById("reflectionForm").reset();
}
</script>

      </div>
  </div>

    <div class="card-footer text-center">Java Spring Full Stack Developer(박매일)</div>
  </div>
</div>

</body>
</html>
