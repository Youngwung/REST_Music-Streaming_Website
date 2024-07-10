<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>정보 수정</title>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
    crossorigin="anonymous" />
</head>
<body>
    <header>
        <div class="container-fluid">
            <c:set var="pageTitle" value="Rest" scope="page" />
            <%@ include file="../fragments/header.jspf"%>
        </div>
    </header>

    <div class="container my-5">
        <h2>회원 정보 변경</h2>
        
        <c:url var="userUpdatePage" value="/user/update" />
        <form method="post" action="${userUpdatePage}" id="updateUserForm" enctype="multipart/form-data">
        
            <!-- 프로필 이미지와 버튼 -->
            <div class="row mb-4">
                <div class="col-md-4 d-flex flex-column align-items-center">
                    <c:url var="profileImg" value="/images/profileimage/profile.jpg" />
                    <c:url var="userProfile" value="/images/profileimage/${user.userProfile}" />
                    <img id="profileImagePreview" alt="profileImg" src="${empty userProfile ? profileImg : userProfile}"
                        width="200px" height="200px" class="rounded-circle mb-3" />
                        
                    <!-- 프로필 변경 버튼 -->
                    <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#changeProfileModal">프로필 변경</button>
                </div>
            </div>
                  
            <div class="mb-3">
                <label for="userName" class="form-label">이름</label>
                <input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" readonly autofocus>
            </div>
            <div class="mb-3">
                <label for="userId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="userId" name="userId" value="${user.userId}" readonly>
            </div>
            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname}" required>
                </div>
                <div id="checkNicknameResult" class="form-text"></div>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <div class="input-group">
                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-primary" id="mailCheckBtn">인증번호 받기</button>
                    </div>
                </div>
                <div id="checkEmailResult" class="form-text text-danger"></div>
            </div>
            <div class="input-group mb-3">
                <input type="text" id="emailVerificationCode" name="emailAuthNumber" class="form-control"
                       placeholder="인증번호를 입력해주세요" maxlength="6" disabled>
                <div class="input-group-append">
                    <button type="button" class="btn btn-primary" id="verifyCodeBtn">인증번호 확인</button>
                </div>
            </div>
            <div id="emailVerificationResult" class="form-text text-danger"></div>
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="새 비밀번호 ">
                <div id="checkPasswordResult"></div>
            </div>
            <div class="mb-3">
                <label for="hintQuestion" class="form-label">힌트 질문</label>
                <select class="form-control" id="hintQuestionSelect" name="hintQuestionSelect">
                    <option value="" selected>힌트 질문 선택</option>
                    <option value="좋아하는 색깔은?">좋아하는 색깔은?</option>
                    <option value="핸드폰번호 뒷자리는?">핸드폰번호 뒷자리는?</option>
                    <option value="내 성별은?">내 성별은?</option>
                </select>
                <input type="text" class="form-control mt-2 d-none" id="hintQuestion" name="hintQuestion" value="${user.hintQuestion}" readonly>
            </div>
            <div class="mb-3">
                <label for="hintAnswer" class="form-label">힌트 답변</label>
                <input type="text" class="form-control" id="hintAnswer" name="hintAnswer" value="${user.hintAnswer}">
            </div>     
            <button type="submit" class="btn btn-primary">변경 사항 저장</button>
        </form>
        
        <hr>
        <h3>회원 탈퇴</h3>
        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">회원 탈퇴</button>
    </div>
    
    <!-- 프로필 변경 모달 -->
    <div class="modal fade" id="changeProfileModal" tabindex="-1" aria-labelledby="changeProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="changeProfileModalLabel">프로필 이미지 변경</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body">
                    <!-- 프로필 이미지 파일 업로드 폼 -->
                    <form id="changeProfileForm" enctype="multipart/form-data">
                        <input type="hidden" id="hiddenUserId" name="userId" value="${user.userId}">
                        <div class="mb-3">
                            <label for="profileImage" class="form-label">새 프로필 이미지 선택</label>
                            <input type="file" class="form-control" id="profileImageInput" name="profileImage" accept="image/*" required>
                        </div>
                        <div class="text-center">
                            <button type="button" class="btn btn-primary" id="btnChangeProfile">변경</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 회원 탈퇴 모달 -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteAccountModalLabel">회원 탈퇴</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 회원 탈퇴를 하시겠습니까? 탈퇴 후에는 모든 데이터가 삭제되며 복구할 수 없습니다.</p>
                </div>
                <div class="modal-footer">
                    <form method="post" action="/user/delete">
                        <input type="hidden" name="userId" value="${user.userId}">
                        <button type="submit" class="btn btn-danger">탈퇴</button>
                    </form>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
        
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
        
    <!-- JS 파일 지정 -->
    <c:url var="updateJS" value="/js/update.js" />
    <script src="${updateJS}"></script> 
    
</body>
</html>
