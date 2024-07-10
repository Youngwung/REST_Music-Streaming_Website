<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"><!--initial-scale=1는 브라우저 기본 비율 이용 -->
    <title>Rest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous" />
    <style>
        .result-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .result-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .result-header h2 {
            font-weight: bold;
        }
        .btn-primary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-outline-primary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .btn-outline-primary:hover {
            background-color: #6c757d;
            color: #fff;
        }
        .form-text {
            color: #6c757d;
            font-size: 0.9em;
        }
    </style>
</head>

<body>
<header>
    <div class="container-fluid">
        <%@ include file="../fragments/header.jspf"%>
    </div>
</header>

<div class="container">
    <div class="result-container">
        <div class="result-header">
            <h2>아이디 찾기 결과</h2>
        </div>
        <form method="post" id="findIdForm" action="<%=request.getContextPath()%>/user/findUserId">
            <div class="mb-3">
                아이디 : <%= request.getAttribute("userId") != null ? request.getAttribute("userId") : "" %>
            </div>
            <div class="d-grid mb-3">
                <input class="form-control btn btn-primary"
                       type="button" value="로그인" onClick="location.href='<%=request.getContextPath()%>/user/signin'"/>
            </div>
            <div class="d-grid mb-3">
                <input class="form-control btn btn-outline-primary"
                       type="button" value="비밀번호 찾기" onClick="location.href='<%=request.getContextPath()%>/user/findpassword'"/>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous">
</script>
</body>
</html>
