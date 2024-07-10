<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <!-- 년, 월, 일만 출력하기 위한 JSTL의 태그 라이브러리 선언 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Rest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
        rel="stylesheet" 
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
        crossorigin="anonymous" />
        
    <style>
    img:hover {
        filter: brightness(80%);
    }
    </style>
</head>
<body>
    <header>
        <div class="container-fluid">
            <c:set var="pageTitle" value="Rest" scope="page" />
            <%@ include file="../fragments/header.jspf" %>
        </div>
    </header>
    
    <div class="container-fluid" style="padding: 30px;">
        <div class="m-5 ">
            <div class="p-3">
                <c:url var="artistCover" value="/artist/image/${artist.artistImage}" />
                <c:url var="songPage" value="/artist/songs?artistId=${artist.artistId}" /> <!-- 아티스트의 곡 페이지 이동 주소 지정 -->
                <c:url var="albumPage" value="/album/detail?albumId=${artist.artistId}" /> <!-- 아티스트의 앨범 상세 페이지 이동 주소 지정 -->
                <img alt="artistCover" src="${artistCover}" class="rounded-circle"
                    style="display: inline-block; vertical-align: middle; left: 400px; width: 240px; height: 240px; object-fit: cover;">
                <div class="ms-3" style="display: inline-block; vertical-align: middle;">
                    <h2 class="mt-2" style="font-weight: bold;">${artist.artistName}</h2>
                    <div class="mt-3">
                        <button data-id="${data.songId}" id="songButton" class="btn ms-1" onclick="window.location.href = '${songPage}';"
                            onmouseover="this.style.color='#0056b3'" onmouseout="this.style.color='black'">곡</button>
                        <button id="albumButton" class="btn ms-1" 
                            style="border-radius: 5px; background-color: #007bff; color: white;">앨범</button>
                    </div>
                </div>
            </div>
            <div class="mt-4">
                <h4 style="font-weight: bold;">상세 정보</h4>
            </div>

            <div class="mt-3 p-2">
                <p id="artistDescription">
                    <c:catch var="error">
                        <%-- 파일 읽기를 시도하고 에러가 발생할 경우 처리 --%>
                        <c:set var="filePath"
                            value="/static/artist/description/${artist.artistDescription}" />
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
            <!-- Artist가 참여한 앨범 출력 -->
            <div class="card">
                <div class="card-body">
                    <div class="row row-cols-1 row-cols-md-2 g-3"> <!-- 2열 유지 -->
                        <c:forEach items="${albums}" var="a">
                            <div class="col">
                                <div class="card h-100" style="max-width: 400px;"> <!-- 카드 최대 너비 조정 -->
                                    <div class="row g-0">
                                        <div class="col-5"> <!-- 이미지 열 너비 조정 -->
                                            <c:url var="albumPage" value="/album/detail?albumId=${a.albumId}" />
                                            <c:url var="albumImage" value="/images/albumcover/${a.albumImage}" />
                                            <a href="${albumPage}">
                                                <img src="${albumImage}" class="img-fluid rounded-start" alt="Album Cover"
                                                    style="width: 100%; height: 100%; object-fit: cover;">
                                            </a>
                                        </div>
                                        <div class="col-7"> <!-- 텍스트 열 너비 조정 -->
                                            <div class="card-body"> <!-- 상하 패딩 줄임 -->
                                                <h6 class="card-title mb-1">
                                                    <a href="${albumPage}" style="color: black; text-decoration: none; font-weight: bold; font-size: 0.9rem;"
                                                        onmouseover="this.style.color='blue';" onmouseout="this.style.color='black';">${a.albumName}</a>
                                                </h6>
                                                <p class="card-text mb-1" style="font-size: 0.8rem;">
                                                    <a href="${songPage}"  
                                                        style="color: black; text-decoration: none;"
                                                        onmouseover="this.style.color='blue';" onmouseout="this.style.color='black';">${a.artistName}</a>
                                                </p>
                                                <br/>
                                                <p class="card-text mb-1" style="font-size: 0.75rem;">${a.albumType}</p>
                                                <p class="card-text" style="color:gray; font-size: 0.75rem;">
                                                    <fmt:formatDate value="${a.albumReleaseDate}" pattern="yyyy-MM-dd" />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
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
    </div>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
