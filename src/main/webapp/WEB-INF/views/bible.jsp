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
  <script src="https://uicdn.toast.com/chart/latest/toastui-chart.min.js"></script> <!-- Toast UI Chart JavaScript SDK 로드 -->

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

  /* 차트 표시 스타일 */
  #chart-area {
    display: none;
    margin-top: 20px;
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
        <c:if test="${empty cus}">
        <form action="${cpath}/login" method="post">
          <div class="form-group">
            <label for="userId">아이디:</label>
            <input type="text" class="form-control" id="customer_id" placeholder="아이디 입력" name="customer_id">
          </div>
          <div class="form-group">
            <label for="password">패스워드:</label>
            <input type="password" class="form-control" id="password" placeholder="패스워드 입력" name="password">
          </div>
          <button type="submit" class="form-control btn btn-primary">로그인</button>
        </form>
        </c:if>
        <c:if test="${!empty cus}">
                <form action="${cpath}/logout" method="post">
                  <div class="form-group">
                    <label>${cus.customer_name}님 Welcome!!</label>
                  </div>
                  <button type="submit" class="form-control btn btn-primary">로그아웃</button>
                </form>
        </c:if>
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
  <!-- 차트를 표시할 영역 -->
  <div id="chart-area"></div>
  <!-- 차트 표시 버튼 -->
 <c:if test="${!empty cus}">
     <button type="button" class="btn btn-info mt-3" onclick="showChart()">Show Chart</button>
 </c:if>
 </div>

<script>
// 페이지 로드 시 오늘 날짜로 초기화
document.addEventListener('DOMContentLoaded', function() {

   var today = new Date();
    var year = today.getFullYear(); // 2024
    var month = (today.getMonth() + 1).toString().padStart(2, '0'); // 07
    var day = today.getDate().toString().padStart(2, '0'); // 18
    var formattedDate = year + '-' + month + '-' + day; // 2024-07-18

    document.getElementById('calendarInput').value = formattedDate;
    goBible(formattedDate);

});

document.getElementById('calendarInput').addEventListener('change', function() {
   var selectedDate = this.value;
   goBible(selectedDate);
});

function goBible(selectedDate){
    document.getElementById('dateDisplayCard').style.display = 'block';
    document.getElementById('selectedDate').textContent = "선택된 날짜: " + selectedDate;
    console.log(JSON.stringify({date: selectedDate}));
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

        }
    });
}

// 카카오톡 SDK 초기화
Kakao.init('db161ca250d8f49e2fdd7fb57f7bd127'); // 여기에 발급받은 JavaScript 키를 입력하세요.

// 차트를 표시하는 함수
function showChart() {
    document.getElementById('chart-area').innerHTML="";
    // 차트 데이터를 서버에서 가져오기
    const customerId = '${cus.customer_id}'; // 실제 고객 ID로 교체
    fetch('${cpath}/proxy/monthly-data?customerId='+customerId)
        .then(response => response.json())
        .then(data => {
            console.log(data); // ?
            // 데이터 가공
            const categories = data.map(item => item.month);
            const seriesData = data.map(item => item.count);
            console.log(categories);
            console.log(seriesData);
            // 차트 영역을 보이도록 설정
            document.getElementById('chart-area').style.display = 'block';

            // Toast UI Chart 생성
            const chart = toastui.Chart.barChart({
                el: document.getElementById('chart-area'),
                data: {
                    categories: categories,
                    series: [
                        {
                            name: 'Count',
                            data: seriesData
                        }
                    ]
                },
                options: {
                    chart: {
                        title: 'Monthly Data Count in Bible Table',
                        width: 900,
                        height: 400
                    },
                    xAxis: {
                        title: 'Count'
                    },
                    yAxis: {
                        title: 'Month'
                    }
                }
            });
        })
        .catch(error => console.error('Error:', error));
}
</script>

<!-- 세 번째 열, 12개 중 3개 열 차지 -->
<div class="col-12 col-md-3 reflection-col d-flex flex-column">
  <form id="reflectionForm">
    <div class="form-group">
      <label for="godReflection">나의 하나님:</label>
      <input type="text" class="form-control" id="bible_word" name="bible_word">
    </div>
    <div class="form-group">
      <label for="repentance">회개:</label>
      <textarea class="form-control" id="bible_repent" name="bible_repent" rows="2"></textarea>
    </div>
    <div class="form-group">
      <label for="insight">깨달음:</label>
      <textarea class="form-control" id="bible_things" name="bible_things" rows="2"></textarea>
    </div>
    <div class="form-group">
      <label for="action">실천:</label>
      <textarea class="form-control" id="bible_implement" name="bible_implement" rows="2"></textarea>
    </div>
    <c:if test="${!empty cus}">
      <button type="button" class="btn btn-primary" onclick="goBibleInsert()">등록</button>
    </c:if>
     <c:if test="${empty cus}">
          <button type="button" class="btn btn-primary" onclick="goBibleInsert()" disabled>등록</button>
     </c:if>
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

function goBibleInsert(){
    // 로그인정보
    const customer_id="${cus.customer_id}";
    const bibleWord = document.getElementById('bible_word').value;
    const bibleRepent = document.getElementById('bible_repent').value;
    const bibleThings = document.getElementById('bible_things').value;
    const bibleImplement = document.getElementById('bible_implement').value;
    // {   } : Object -> JSON(String)
    const data = {
        customer_id:customer_id,
        bible_word: bibleWord,
        bible_repent: bibleRepent,
        bible_things: bibleThings,
        bible_implement: bibleImplement
    };

    fetch('${cpath}/proxy/insertBible', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('데이터가 성공적으로 전송되었습니다.');
            resetForm(); // 전송 후 폼 초기화
        } else {
            alert('데이터 전송에 실패했습니다.');
        }
    })
    .catch(error => console.error('Error:', error));
}
</script>

      </div>
  </div>

    <div class="card-footer text-center">Java Spring Full Stack Developer(박매일)</div>
  </div>
</div>

</body>
</html>
