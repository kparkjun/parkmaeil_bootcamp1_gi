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
  <link rel="stylesheet" href="https://uicdn.toast.com/tui.grid/latest/tui-grid.css" />
  <script src="https://uicdn.toast.com/tui.grid/latest/tui-grid.js"></script>
 <script>
    // Ajax 회원정보를 가져와서 Toast UI(Grid) 출력
// Fetch the data from Spring Controller
    fetch('${cpath}/api/customers')
        .then(response => response.json())
        .then(data => {
            // Create the grid with the fetched data
            const grid = new tui.Grid({
                el: document.getElementById('grid'),
                data: data,
                columns: [
                    { header: 'Customer ID', name: 'customer_id' },
                    { header: 'Password', name: 'password' },
                    { header: 'Customer Name', name: 'customer_name' },
                    { header: 'Age', name: 'age' },
                    { header: 'Rating', name: 'rating' },
                    { header: 'Occupation', name: 'occupation' },
                    { header: 'Reserves', name: 'reserves' },
                     {
                                header: 'Actions',
                                name: 'actions',
                                formatter: function() {
                                    return '<button class="btn-delete">Delete</button>';
                                }
                      }
                ],
                pageOptions: {
                    perPage: 5
                }
            });
        });
 </script>
</head>
<body>

<div class="container-fluid mt-3">
  <h1>Java Spring Full Stack Developer</h1>
  <p>Resize the browser window to see the effect.</p>
  <p>The first, second and third row will automatically stack on top of each other when the screen is less than 576px wide.</p>

  <div class="container-fluid">

     <div class="card">
        <div class="card-header">Java Spring Framework</div>
        <div class="card-body">
            <div class="row">
              <div class="col-sm-2 mb-2">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Left</h4>
                    <p class="card-text">Some example text. Some example text.</p>
                    <a href="#" class="card-link">Card link</a>
                    <a href="#" class="card-link">Another link</a>
                  </div>
                </div>
              </div>
              <div class="col-sm-7 mb-2">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Main</h4>
                    <p class="card-text">Some example text. Some example text.</p>
                    <a href="#" class="card-link">Card link</a>
                    <a href="#" class="card-link">Another link</a>
                    <div id="grid">여기에 회원 목록 출력</div>
                  </div>
                </div>
              </div>
              <div class="col-sm-3">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Right</h4>
                    <p class="card-text">Some example text. Some example text.</p>
                    <a href="#" class="card-link">Card link</a>
                    <a href="#" class="card-link">Another link</a>
                  </div>
                </div>
              </div>
            </div>
        </div>
        <div class="card-footer text-center">Java Spring Full Stack Developer(박매일)</div>
     </div>

  </div>
</div>

</body>
</html>