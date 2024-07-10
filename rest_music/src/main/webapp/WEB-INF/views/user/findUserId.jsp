<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>아이디 찾기</title>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
    crossorigin="anonymous" />

<style>
.form-find-id {
    max-width: 400px;
    padding: 15px;
    margin: 50px auto;
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.form-find-id .form-find-id-heading {
    text-align: center;
    margin-bottom: 20px;
    font-weight: bold;
}

.form-find-id .form-control {
    position: relative;
    box-sizing: border-box;
    height: auto;
    padding: 10px;
    font-size: 14px;
    border: 1px solid #ccc; /* input 창 테두리 회색 */
}

.form-find-id .form-control:focus {
    z-index: 2;
    border-color: #6c757d; /* input 창 테두리 포커스 색상 회색 */
}

.form-find-id .text-danger {
    margin-top: 5px;
    font-size: 12px;
}

.btn-primary {
    background-color: #6c757d;
    border-color: #6c757d;
}

.btn-primary:hover {
    background-color: #5a6268;
    border-color: #5a6268;
}

.btn-outline-secondary {
    color: #6c757d;
    border-color: #6c757d;
}

.btn-outline-secondary:hover {
    background-color: #6c757d;
    color: #fff;
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
        <form class="form-find-id" method="post"
            action="<%=request.getContextPath()%>/user/findUserId">
            <h2 class="form-find-id-heading">아이디 찾기</h2>
            <c:if
                test="${not empty param.result and param.result eq 'f'}">
                <div class="text-danger">일치하는 정보가 없습니다.</div>
            </c:if>
            <div class="mb-3">
                <input class="form-control" type="text" name="userName"
                    id="userName" placeholder="이름" required />
            </div>
            <div class="mb-3">
                <input class="form-control" type="text" id="email"
                    name="email" placeholder="이메일" required />
                <div id="checkEmailResult" class="text-danger"></div>
            </div>
            <div class="d-grid mb-3">
                <input class="form-control btn btn-primary"
                    type="submit" value="조회" />
            </div>
            <div class="d-grid mb-3">
                <input class="form-control btn btn-outline-secondary"
                    type="button" value="비밀번호 찾기"
                    onClick="location.href='<%=request.getContextPath()%>/user/findpassword'" />
            </div>
        </form>
    </div>

    <script src="<%=request.getContextPath()%>/js/findUserId.js"></script>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous">
					
				</script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</body>
</html>
