<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
	<button%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
			<title>Album Detail</title>
			<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
				integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
			<style>
				.intro {
					position: relative;
					left: 20px;
				}

				a {
					text-decoration-line: none;
					color: black;
				}

				a:hover {
					text-decoration: underline;
					font-weight: bold;
				}

				table {
					border-collapse: separate;
					border-spacing: 0 5px;
					width: 100%;
				}

				#like {
					position: relative;
					top: 40px;
					left: 30px;
				}

				.submenu {
					width: 7%;
				}

				#content {
					padding: 20px;
				}

				/* 너는 챗지피티를 믿어?  */
				#songPlayerContainer {
					display: none;
					position: fixed;
					bottom: 0;
					width: 100%;
					background: #f1f1f1;
					padding: 10px;
					box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.2);
					z-index: 1000;
				}

				#songPlayerContainer iframe {
					width: 100%;
					height: 60px;
					border: none;
				}

				/* 너는 챗지피티를 믿어?  */
			</style>
		</head>

		<body>
			<header>
				<%@ include file="../fragments/header.jspf" %>
			</header>
			<main>
				<div class="mt-2 card">
					<div class="card-header">
						<section>
							<div class="fw-bold">"${album.albumName}" 앨범정보</div>
							<hr />
							<div style="float:left" class="mouseScale-up">
								<img src="../data/${album.albumImage}.jpg" alt="앨범 커버" width="250" height="250" />
							</div>
							<div style="float: left">
								<table class="table-borderless intro">
									<tr>
										<td class="m-2">[${album.albumType}]</td>
									</tr>
									<tr>
										<td>앨범 명</td>
										<td class="intro">${album.albumName}</td>
									</tr>
									<tr>
										<td>아티스트</td>
										<td class="intro">${album.singerName}</td>
									</tr>
									<tr>
										<td>발매일</td>
										<td class="intro" id="date">${album.albumReleaseDate}</td>
									</tr>
									<tr>
										<td>장르</td>
										<td class="intro">${album.genre}</td>
									</tr>
									<tr style="text-align: left;">
										<td>타이틀 곡</td>
										<td class="intro"><a href="/song/detail?sondId=${album.songId}">${album.title}</a></td>
									</tr>
								</table>
								<div id="like">
									<span>좋아요개수</span>
									<span class="intro">뭐쓰지</span>
								</div>
							</div>
						</section>
					</div>
					<div class="card-body table-responsive">
						<h3>수록곡 (${songsCount})</h3>
						<table class="table table-striped table-hover">
							<thead class="font-size-sm">
								<th class="submenu">#</th>
								<th class="submenu"></th>
								<th style="width: 26%;">음원</th>
								<th style="width: 25%;">아티스트</th>
								<th class="submenu">좋아요</th>
								<th class="submenu">듣기</th>
								<th class="submenu">재생목록</th>
								<th class="submenu">리스트</th>
								<th class="submenu">더보기</th>
							</thead>
							<tbody class="table-group-divider font-size-sm">
								<c:forEach var="s" items="${albumSongs}" varStatus="status">
									<tr>
										<td>${status.index + 1}</td>
										<td>
											<c:if test="${s.titleSong != null}">
												<span class="fw-bold">Title</span>
											</c:if>
										</td>
										<td class="fw-bold">
											<a href="/song/details?songId=${s.songId}">
												${s.title}</a>
										</td>
										<td>${s.singerName}</td>
										<td>
											<img id="likebtn" height="50px" width="50px" src="../imgs/likeOff.png" />${s.likesCount}
											<!-- TODO: axios로 DB insert 해야됨 -->
										</td>
										<td>
											<button id="listenBtn" class="btn btn-success" data-id="${s.songId}">바로듣기</button>
										</td>
										<td>
											<button id="addCPList" class="btn btn-success" data-id="${s.songId}">
												재생목록
											</button>
											<!-- <button id="openModalBtn" type="button" class="btn btn-primary openModalBtn"
												data-bs-toggle="modal" data-bs-target="#sessionListModal">
												재생목록
											</button> -->
										</td>
										<td>플리추가</td>
										<td>더보기</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</main>
			<!-- 모달 창 -->
			<div class="modal fade" id="sessionListModal" tabindex="-1" role="dialog" aria-labelledby="sessionListModalLabel"
				aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="sessionListModalLabel">세션에 저장된 리스트</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body" id="sessionListBody">
							<!-- 여기에 세션에서 가져온 리스트가 들어갈 자리 -->
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
						</div>
					</div>
				</div>
			</div>


			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
				integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
				crossorigin="anonymous"></script>

			<script src="https://unpkg.com/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
				integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
				crossorigin="anonymous"></script>
			<!-- Axios JS 라이브러리 -->
			<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
			<c:url var="album_detail" value="/js/album_detail.js" />
			<script src="${album_detail}"></script>
			<c:url var="addCurrentPlayList" value="/js/addCurrentPlayList.js" />
			<script src="${addCurrentPlayList}"></script>
			<script>
				document.addEventListener('DOMContentLoaded', () => {
					function showModal() {
						console.log('mainFrame showModal 호출성공');
						let myModal = document.querySelector('#sessionListModal');
						console.log(myModal);
						let modal = new bootstrap.Modal(myModal);
						console.log(modal);
						getCPList();
						// Ajax요청을 보내고 모달에 태그를 작성하는 album_detail.js의 함수를 호출
						modal.show();
					}
					// 다른 프레임에서 호출할 수 있도록 함수 노출
					window.showModal = showModal;
				});

			</script>

		</body>

		</html>