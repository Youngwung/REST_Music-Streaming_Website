<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
    crossorigin="anonymous">
<title>Rest</title>

</head>
<body>
    <%@ include file="../fragments/header.jspf"%>

    <div class="container-fluid" style="padding: 80px;">

        <div class="m-5 ">
            <div class="p-3">
                <div class="">
                    <c:url var="albumCover"
                        value="/images/albumcover/${data.albumImage}"></c:url>
                    <img alt="albumCover" src="${albumCover}"
                        class="rounded "
                        style="display: inline-block; vertical-align: middle; left: 400px; width: 220px; height: 220px;">
                    <div class="ms-2"
                        style="display: inline-block; vertical-align: middle;">
                        <h2 class="mt-2">${data.songTitle}</h2>
                        <p class="mt-4">
                            가수<span class="ms-3">${data.singerName}</span>
                        </p>
                        <p class="mt-2">
                            앨범<span class="ms-3">${data.albumName}</span>
                        </p>
                        <p class="mt-2">
                            장르<span class="ms-3">${data.genre}</span>
                        </p>
                        <div class="mt-3">
                            <button id="btnLike" class="btn fs-3"></button>
                            <button data-id="${data.songId}"
                                id="listenBtn" title="재생" class="btn" style="background-image: url('../images/icon/play.png'); 
                                width: 45px; height: 45px; background-size: cover; background-repeat: no-repeat;"></button>
                                
                            <button data-id="${data.songId}"
                                id="" title="재생목록에 추가" class="btn ms-1" style="background-image: url('../images/icon/playList.png'); 
                                width: 60px; height: 60px; background-size: cover; background-repeat: no-repeat;"></button>
                                
                            <button id="btnAddPlayList"
                                class="btn ms-1" title="내 리스트에 담기" style="background-image: url('../images/icon/myPlayList.png'); 
                                width: 50px; height: 50px; background-size: cover; background-repeat: no-repeat;"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mt-4">
                <h4>상세 정보</h4>
                <p>
                    <span class="mt-3 fw-bold">곡명</span><span
                        class="ms-3">${data.songTitle}</span>
                </p>
                <p>
                    <span class="mt-3 fw-bold">작사</span><span
                        class="ms-3">${data.writers}</span>
                </p>
                <p>
                    <span class="mt-3 fw-bold">작곡</span><span
                        class="ms-3">${data.composers}</span>
                </p>
                <p>
                    <span class="mt-3 fw-bold">편곡</span><span
                        class="ms-3">${data.arrangers}</span>
                </p>
            </div>

            <div class="mt-3 p-2">
                <p id="lyrics">
                    <c:catch var="error">
                        <%-- 파일 읽기를 시도하고 에러가 발생할 경우 처리 --%>
                        <c:set var="filePath"
                            value="/static/lyrics/${data.lyrics}" />
                        <%
                        ServletContext context = request.getServletContext();
                        String realPath = context.getRealPath((String) pageContext.getAttribute("filePath"));
                        File file = new File(realPath);
                        BufferedReader reader = null;
                        try {
                        	reader = new BufferedReader(new FileReader(file));
                        	String line;
                        	while ((line = reader.readLine()) != null) {
                        		out.println(line + "<br>");
                        	}
                        } catch (FileNotFoundException e) {
                        	out.println("파일을 찾을 수 없습니다.");
                        } catch (IOException e) {
                        	out.println("파일을 읽을 수 없습니다.");
                        } finally {
                        	if (reader != null) {
                        		try {
                        	reader.close();
                        		} catch (IOException e) {
                        	out.println("파일 리더를 닫는 도중 오류가 발생했습니다.");
                        		}
                        	}
                        }
                        %>
                    </c:catch>
                    <c:if test="${error ne null}">
                        <p>파일을 읽는 도중 오류가 발생했습니다.</p>
                    </c:if>
                </p>
            </div>

            <section>
                <div class="mt-2 card">
                    <div class="card-header d-inline-flex gap-1">
                        <!-- 댓글 접기/펼치기 기능 버튼 -->
                        <button class="btn btn-secondary"
                            id="btnToggleComment">댓글 보기</button>
                    </div>

                    <!-- 댓글 토글 버튼에 의해서 접기/펼치기를 할 영역 -->
                    <div class="card-body collapse"
                        id="collapseComments">
                        <!-- 댓글 등록 -->
                        
                            <div class="mt-2 card card-body" id="commnetRegistForm">
                                <div class="mt-2 row">
                                    <div class="col-10">
                                        <!-- 댓글 입력 -->
                                        
                                        <textarea class="form-control"
                                            rows="3" id="ctext"
                                            placeholder="댓글 내용"></textarea>
                                        <!-- 댓글 작성자 아이디를 로그인한 사용자의 아이디로 설정 -->
                                        <input class="d-none" id="username"
                                            value="${signedInUser}" />
                                    </div>
                                    <div class="col-2">
                                        <button
                                            class="btn btn-outline-success"
                                            id="btnRegisterComment">등록</button>
                                    </div>
                                </div>
                            </div>  
                      

                        <!-- 포스트에 달려 있는 댓글 목록을 보여줄 영역 -->
                        <div class="my-2" id="comments"></div>

                        <!-- 페이징 버튼들이 여기에 추가될 예정 -->
                        <ul id="pagination2"
                            class="pagination pagination-sm justify-content-center "></ul>


                        <!-- 댓글 업데이트 모달(다이얼로그) -->
                        <div id="commentModal" class="modal fade"
                            tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">댓글
                                            업데이트</h5>
                                        <button type="button"
                                            class="btn-close"
                                            data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- 수정할 댓글 아이디(번호) -->
                                        <input class="d-none"
                                            id="modalCommentId" />
                                        <!-- 수정할 댓글 내용 -->
                                        <textarea class="form-control"
                                            id="modalCommentText"></textarea>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button"
                                            class="btn btn-outline-secondary"
                                            data-bs-dismiss="modal">취소</button>
                                        <button type="button"
                                            class="btn btn-outline-primary"
                                            id="btnUpdateComment">저장</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="modal fade" id="staticBackdrop"
            data-bs-backdrop="static" data-bs-keyboard="false"
            tabindex="-1" aria-labelledby="staticBackdropLabel"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">추가할 플레이리스트</h5>
                        <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div id="playLists" class="modal-body"
                        style="height: 393px;">
                        <!--  플리가 추가 될 부분 -->
                    </div>
                    <nav aria-label="Playlist navigation">
                        <ul id="pagination"
                            class="pagination pagination-sm justify-content-center">
                            <!-- 페이징이 추가될 부분 -->
                        </ul>
                    </nav>
                    <div class="modal-footer">
                        <button type="button"
                            class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer>
        <!-- 모달 요소들을 footer로 사용. 모든 페이지에 사용되기 때문 -->
        <%@ include file="../fragments/footer.jspf"%>
    </footer>


    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    <script
        src="https://unpkg.com/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <script>
		const songId = ${songId};
		let loginUserId ='${loginUserId}';
	</script>

    <c:url var="commentsJS" value="/js/comments.js" />
    <script src="${commentsJS}"></script>
    <c:url var="detailJS" value="/js/detail.js" />
    <script src="${detailJS}"></script>
    <c:url var="addCurrentPlayList" value="/js/addCurrentPlayList.js" />
    <script src="${addCurrentPlayList}"></script>
</body>
</html>