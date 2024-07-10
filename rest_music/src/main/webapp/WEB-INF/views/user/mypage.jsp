<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>MyPage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
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

    <div class="container-fluid">
        <div class="m-5">
            <h2 style="font-weight: bold;">마이페이지</h2><hr>
            <div class="d-flex align-items-center">
                <div class="p-3">
                     <c:url var="profileImg" value="/images/profileimage/profile.jpg" />
                    <c:url var="userProfile" value="/images/profileimage/${user.userProfile}" />
                    <img alt="profileImg" src="${user.userProfile == null ? profileImg : userProfile}"
                        width="200px" height="200px" />
                </div>
                <div class="p-3">
                	<h3 id="id" class="d-none">${user.id}</h3>
                    <h3 id="userId" class="d-none">${user.userId}</h3>
                    <h3 style="font-weight: bold; font-size: 1.2rem;">닉네임: ${user.nickname}</h3>                
                    <!-- 비밀번호 확인 모달을 여는 버튼 -->
                    <c:url var="userUpdate" value="/user/update">
                        <c:param name="userId" value="${user.userId}" />
                    </c:url>
                    <a class="btn btn-outline-primary" id="updateInfoBtn"
                        href="${userUpdate}">ID/PW 변경 (내정보 관리)
                    </a>
                </div>
            </div>
            <br>
            <h2 style="font-size: 1.2rem; text-align : center;">플레이리스트</h2><hr>
            <!-- 추가할 박스 (카드) -->
            <div class="card">
                <div class="card-body" id="playLists">
                
                </div>
            </div>
            <div class="my-2">
                <button class="btn btn-primary border border-gray"
                    style="background-color: gray; color: white;"
                    data-bs-toggle="modal"
                    data-bs-target="#addPlaylistModal">플레이리스트 추가</button>
            </div>
            <br>
            <h2 id="userLikesSection" style="font-size: 1.2rem; text-align : center;">좋아요 누른 곡</h2><hr>
            <!-- 추가할 박스 (카드) -->
            <div class="card">
                <div class="card-body" id="likeCardBody">
                    <table class="table table-striped" style="border: 1px solid #ddd;">
                        <thead>
                            <tr>
                                <th style="text-align: left; vertical-align: middle;">커버</th>
                                <th style="text-align: left; vertical-align: middle;">노래 제목</th>
                                <th style="text-align: left; vertical-align: middle;">아티스트</th>
                                <th style="text-align: center; vertical-align: middle;">듣기</th>
                            </tr>
                        </thead>
                        <tbody id="likeTableBody">
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- 페이지네이션 컨트롤 -->
            <nav>
                <ul class="pagination justify-content-center mt-4"
                    id="pagination"></ul>
            </nav>
        </div>
    </div>
    
    <!-- 플레이 리스트 추가 모달 -->
    <div class="modal fade" id="addPlaylistModal" tabindex="-1" aria-labelledby="addPlaylistModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPlaylistModalLabel">플레이 리스트 추가</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="playlistForm">
                        <div class="mb-3">
                            <label for="playlistName" class="form-label">플레이 리스트 제목</label>
                            <input type="text" class="form-control" id="playlistName" name="playlistName" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" id="btnAddPlaylist">확인</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
    
	<!-- 비밀번호 확인 모달 추가 -->
	<div class="modal fade" id="passwordConfirmModal" tabindex="-1" aria-labelledby="passwordConfirmModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="passwordConfirmModalLabel">비밀번호 확인</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <form id="passwordConfirmForm">
	          <div class="mb-3">
	            <label for="password" class="form-label">비밀번호를 입력하세요</label>
	            <input type="password" class="form-control" id="password" required>
	            <input type="hidden" id="userPassword" value="${user.password}">
	          </div>
	        </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button type="button" class="btn btn-primary" id="confirmPasswordBtn">확인</button>
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
    <c:url var="mypageJS" value="/js/mypage.js" />
    <script src="${mypageJS}"></script>
</body>
</html>