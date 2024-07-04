<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
        rel="stylesheet" 
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
        crossorigin="anonymous" />
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .login-header h2 {
            font-weight: bold;
        }
        .btn-primary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-primary:hover,
        .btn-primary:focus,
        .btn-primary:active {
            background-color: #5a6268;
            border-color: #5a6268;
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
        .form-check-label {
            font-size: 0.9em;
            color: #6c757d;
            margin-left: 5px; /* 아이디 저장 체크박스의 마진 조정 */
        }
        .form-check {
            margin-bottom: 10px; /* 체크박스의 마진 조정 */
        }
    </style>
</head>
<body>
    <header>
        <div class="container-fluid">
            <%@ include file="../fragments/header.jspf" %>
        </div>
    </header>
    <div class="container">
        <div class="login-container">
            <div class="login-header">
                <h2>로그인</h2>
            </div>
            <form method="post" id="loginForm">
                <c:if test="${not empty param.result and param.result eq 'f'}">
                    <div class="text-danger text-center">아이디와 비밀번호를 확인하세요.</div>
                </c:if>
                <div class="mb-3">
                    <input class="form-control" 
                        type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요" required />
                </div>
                <div class="mb-3">
                    <input class="form-control" 
                        type="password" name="password" placeholder="비밀번호를 입력해주세요" required />
                </div>
                <div class="form-check mb-1">
                    <input class="form-check-input" type="checkbox" id="saveIdYn">
                    <label class="form-check-label" for="saveIdYn">아이디 저장</label>
                </div>
                <div class="mb-3 text-end">
                    <a href="/Rest/user/findUserId" class="form-text">아이디 찾기</a> | <a href="/Rest/user/findpassword" class="form-text">비밀번호 찾기</a>
                </div>
                <div class="d-grid mb-3">
                    <button class="btn btn-primary" type="submit">로그인</button>
                </div>
                <div class="d-grid mb-3">
                    <button class="btn btn-outline-primary" type="button" onClick="location.href='/Rest/user/signup'">회원가입</button>
                </div>
            </form>
        </div>
    </div>

    <c:url var="sign_in_js" value="/js/signin.js" />
    <script src="${sign_in_js}"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
        crossorigin="anonymous"></script>
</body>

</html>
