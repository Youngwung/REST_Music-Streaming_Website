<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Top 30</title>
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous" />
    
    <link rel="stylesheet" href="<c:url value='/css/chart.css' />"> <!-- 외부 CSS 파일 링크 -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
        rel="stylesheet" />
</head>
<body>
    <header>
        <div class="container-fluid">
            <c:set var="pageTitle" value="Rest" scope="page" />
            <%@ include file="../fragments/header.jspf"%>
        </div>
    </header>
    
    <main>
    <div class="container my-3">
        <div class="d-flex justify-content-start mb-3 d-none">
            <button type="button" class="btn btn-outline-primary me-2 active">TOP 30</button>
            <button type="button" class="btn btn-outline-primary me-2">OST</button>
            <button type="button" class="btn btn-outline-primary me-2">댄스</button>
            <button type="button" class="btn btn-outline-primary me-2">발라드</button>
            <button type="button" class="btn btn-outline-primary me-2">팝</button>
            <button type="button" class="btn btn-outline-primary">힙합</button>
        </div>
    </div>

    <div class="container">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAllCheckbox" /></th>
                    <th>순위</th>
                    <th>곡 정보</th>
                    <th>앨범</th>
                    <th>좋아요</th>
                    <th>듣기</th> <%-- TODO: 로그인 세션 --%>
                    <th>재생목록</th> <%-- TODO: 로그인 세션 --%>
                    <th>담기</th>
                    <th>뮤비</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="top" items="${topSongs}" varStatus="status">
                    <tr>
                        <td><input type="checkbox" class="songCheckbox" /></td>
                        <td>${status.index + 1}</td>
                        <td class="song-info"> 
                            <%-- TODO: 앨범 상세 매핑 주소로 수정 --%>
                            <c:url var="albumDetailUrl" value="/album/detail"> 
                                <c:param name="albumId" value="${top.albumId}" />
                            </c:url>
                            <a href="${albumDetailUrl}" class="album-link">
                                <img alt="앨범표지" src="<c:url value='/data/${top.albumImage}' />" class="img-fluid" />
                            </a>    
                            <%-- TODO: 음원 상세 매핑 주소로 수정 --%>
	                        <c:url var="songDetailUrl" value="/song/detail">
						        <c:param name="songId" value="${top.songId}" />
						    </c:url>   
						    <%-- TODO: 아티스트 상세 매핑 주소로 수정 --%>
                            <c:url var="artistDetailUrl" value="/artist/detail">
                                <c:param name="artistId" value="${top.artistId}" />
                            </c:url>
                            <div>
                                <a href="${songDetailUrl}" style="font: inherit; color: inherit; text-decoration: none;">
						            <span>${top.title}</span><br>
						        </a>
						        <a href="${artistDetailUrl}" style="font: inherit; color: gray; text-decoration: none;">
                                    <span>${top.artistName}</span>
                                </a>
                            </div>                  
                        </td>
                        <td>${top.albumName}</td>
                        <td>
                            <i class="fas fa-heart ${top.likes != null && top.likes > 0 ? 'liked' : ''} heart-icon"
                                data-song-id="${top.songId}"
                                data-id="${loginUserId}">
						    </i>
						    <span class="likes-count">${top.likes != null ? top.likes : 0}</span>
						</td>
                        <td>
						    <c:url var="songPath" value="/data/${top.songPath}" />
						    <a href="#" class="btn btn-primary btn-sm play-btn"
						        data-song-path="${songPath}"
						        data-song-id="${top.songId}"
						        data-id="${loginUserId}">
						        <i class="fas fa-play"></i>
						    </a>
						</td>
						<td>			
                            <button type="button" class="btn btn-secondary btn-sm" id="addCPList"
                                data-id="${top.songId}">
                                <i class="fa-solid fa-list"></i>
                            </button>
                        </td>
                        <td>
						    <button type="button" class="btn btn-secondary btn-sm add-to-playlist-btn"
						      data-song-id="${top.songId}"
						      data-id="${loginUserId}">
						      <i class="fas fa-plus"></i>
						    </button>
						</td>
                        <td>
                            <a href="${top.videoLink}" target="_blank" class="btn btn-secondary btn-sm">
                                <i class="fas fa-video"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </main>
    
    <!-- 재생할 MP3 오디오 태그 -->
    <audio id="audioPlayer" controls>
        <!-- MP3 파일 경로를 동적으로 설정할 수 있도록 스크립트로 처리 -->
        <source id="audioSource" src="" type="audio/mpeg">
        Your browser does not support the audio element.
        <span id="currentTime">0:00</span> / <span id="totalTime">1:00</span>
    </audio>
    
    <!-- 세션 리스트 모달 -->
    <div class="modal fade" id="sessionListModal" tabindex="-1" aria-labelledby="sessionListModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="sessionListModalLabel">현재 재생 목록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" id="modalCloseBtn"></button>
                </div>
                <div class="modal-body" id="sessionListBody">
                    <!-- 여기에 재생 목록이 동적으로 추가됩니다 -->
                </div>
            </div>
        </div>
    </div>
    
    <!-- 플레이리스트 모달 -->
    <div class="modal fade" id="selectPlayList" tabindex="-1" aria-labelledby="selectPlayListLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
           <div class="modal-content">
               <div class="modal-header">
                   <h5 class="modal-title" id="selectPlayListLabel">플레이리스트 선택</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>
               <div class="modal-body">
                   <!-- 플레이리스트 체크박스 목록이 여기에 동적으로 추가됩니다 -->
                   <div id="playLists"></div>
               </div>
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                   <button type="button" id="btnAddSong" class="btn btn-primary">곡 추가</button>
               </div>
           </div>
        </div>
    </div>
    
    <!-- 전체 담기 모달--> <%-- TODO: 미완성 --%>
	<div id="selectAllModal" class="modal" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-body text-center p-4">
	                <button type="button" class="btn btn-secondary m-2" data-bs-dismiss="modal">
	                    <i class="fas fa-times fa-3x"></i> 취소
	                </button>
	                <button type="button" class="btn btn-primary m-2" id="addAllToPlaylist">
	                    <i class="fas fa-play fa-3x"></i> 전체 듣기
	                </button>
	                <button type="button" class="btn btn-primary m-2" id="addAllToCollection">
	                    <i class="fas fa-plus fa-3x"></i> 전체 담기
	                </button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 로그인 모달 -->
	<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="loginModalLabel">로그인 페이지로 이동</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                로그인이 필요합니다. 로그인 하시겠습니까?
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="loginCancelButton">취소</button>
	                <button type="button" class="btn btn-primary" id="loginConfirmButton">확인</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	
	<footer>
        <div class="container">
            <%@ include file="../fragments/footer.jspf" %>
        </div>
    </footer>
     
	<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    
    <!-- Axios JS 라이브러리 (JS 파일보다 위에 있어야 함) -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    
    <script>
        const id = ${loginUserId}; //id   
    </script>
    
    <!-- 우리가 만든 JS 파일 -->
    <c:url var="songsPopularJS" value="/js/songsPopular.js" />
    <script src="${songsPopularJS}"></script>
    
    <c:url var="playerPageJS" value="/js/playerPage.js" />
    <script src="${playerPageJS}"></script>
    
    <c:url var="addCurrentPlayList" value="/js/addCurrentPlayList.js" />
    <script src="${addCurrentPlayList}"></script>
    
</body>
</html>

