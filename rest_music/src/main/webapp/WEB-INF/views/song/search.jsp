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
<style>
   #resultTable tr{
        min-width:1100px;
    }
</style>
</head>
<body>
    <header>
        <div class="container-fluid">
            <c:set var="pageTitle" value="Rest" scope="page" />
            <%@ include file="../fragments/header.jspf"%>
        </div>
    </header>

    <main>
        <div class="container mt-5"
            style="max-width: 1440px; min-width: 1000px">

            <c:url var="songSearchPage" value="/song/search" />
            <form id="searchForm" class="mt-5" method="get"
                action="${songSearchPage}">
                <div class="row d-flex justify-content-center">
                    <div class="col-2">
                        <select id="category" class="form-control"
                            name="category">
                            <option value="t" >제목</option>
                            <option value="s" ${param.category == 's' ? 'selected' : ''}>가수</option>
                            <option value="ts" ${param.category == 'ts' ? 'selected' : ''}>제목+가수</option>
                            <option value="a" ${param.category == 'a' ? 'selected' : ''}>앨범명</option>
                        </select>
                    </div>
                    <div class="col-6">
                        <input class="form-control" type="text"
                            id="keyword" name="keyword"
                            placeholder="검색어" required value="${param.keyword}"/>
                    </div>
                    <input name="sortType" value="accuracy" class="d-none">
                    <div class="col-1">
                        <input type="submit"
                            class="btn btn-outline-secondary" value="검색">
                    </div>
                </div>
            </form>
            
                
            
            
            <div class="card-body mt-5">
            
                <div class="d-flex">
                    <div class="p-2 flex-grow-1"></div>
                    <div class="p-2">
                        <button id="accuracy" type="button" class="btn"> 정확도순 </button>
                        <button id="recency" type="button" class="btn"> 최신순 </button>
                        <button id="alphabet" type="button" class="btn"> 가나다순 </button>
                    </div>
                </div>
            
                <table id="resultTable" class="table table-hover mt-3">
                    <thead>
                        <tr>
                            <th colspan="2">앨범/곡</th>
                            <th>가수</th>
                            <th class="text-center">듣기</th>
                            <th class="text-center" style="min-width: 81px;">재생목록</th>
                            <th class="text-center" style="min-width: 87px;">내 리스트</th>
                        </tr>
                    </thead>
                    <tbody id="searchResult">
                        <c:if test="${empty result}">
                            <tr>
                                <td colspan="5" class="text-center">검색
                                    결과가 없습니다</td>
                            </tr>
                        </c:if>
                        <c:forEach var="r" items="${result}">
                            <c:url var="songDetailsPage"
                                value="/song/detail">
                                <c:param name="songId"
                                    value="${r.songId}"></c:param>
                            </c:url>
                            <tr style="cursor: pointer;"
                                data-song-id="${r.songId}"
                                onclick="location.href='${songDetailsPage}'">
                                <td style="width: 118px;"><img
                                    alt="albumcover"
                                    src="../images/albumcover/${r.albumImage}"
                                    class="img-thumbnail" width="120px"
                                    height="120px" /></td>
                                <td style="width: 60%;"><span
                                    class="fs-4">${r.title}</span> <br />
                                    <br /> ${r.albumName}</td>
                                <td><br /> <span
                                    class="text-center fw-bold">${r.singerName}</span></td>
                                <td style="text-align: center;"><button
                                        style="background-image: url('../images/icon/play.png'); width: 50px; height: 50px; background-size: cover; background-repeat: no-repeat;"
                                        data-id="${r.songId}"
                                        class="btnListen btn mt-3"
                                        id="listenBtn"></button></td>
                                <td style="text-align: center;"><button
                                        style="background-image: url('../images/icon/playList.png'); width: 60px; height: 60px; background-size: cover; background-repeat: no-repeat;"
                                        class="btn addNextPlay mt-3"></button></td>
                                <td style="text-align: center;"><button
                                        style="background-image: url('../images/icon/myPlayList.png'); width: 55px; height: 55px; background-size: cover; background-repeat: no-repeat;"
                                        class="btn addPlayList mt-3"></button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
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
    </main>

    <footer>
        <!-- 모달 요소들을 footer로 사용. 모든 페이지에 사용되기 때문 -->
        <%@ include file="../fragments/footer.jspf"%>
    </footer>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <c:url var="searchJS" value="/js/search.js" />
    <script src="${searchJS}"></script>
    
    <script>
    let loginUserId ='${loginUserId}';
	</script>
    
    <c:url var="addCurrentPlayList" value="/js/addCurrentPlayList.js" />
    <script src="${addCurrentPlayList}"></script>

</body>
</html>