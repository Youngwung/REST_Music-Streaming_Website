<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rest Music Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-content {
            margin-top: 20px;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .chart-item, .hot-new-item, .genre-item, .music-video-item {
            margin-bottom: 15px;
        }
        .chart-item img, .hot-new-item img, .genre-item img, .music-video-item img {
            width: 100%;
            border-radius: 10px;
        }
        .item-title {
            font-size: 1rem;
            font-weight: bold;
            margin-top: 10px;
        }
        .item-artist {
            font-size: 0.9rem;
            color: #666;
        }
    </style>
</head>
<body>

<header>
    <div class="container-fluid">
        <%@ include file="./fragments/header.jspf" %>
    </div>
</header>

<div class="container main-content">
    <!-- 지금 SNS에서 뜨는 음악 -->
    <section>
        <div class="section-title">지금 SNS에서 뜨는 음악 (Top 5)</div>
        <div class="row chart-items">
            <!-- 동적으로 로드될 내용 -->
        </div>
    </section>

    <!-- 최신 음악 -->
    <section class="mt-5">
        <div class="section-title">최신 음악</div>
        <div class="row hot-new-items">
            <!-- 동적으로 로드될 내용 -->
        </div>
    </section>

    <!-- 장르별 음악 -->
    <section class="mt-5">
        <div class="section-title">장르별 음악</div>
        <div class="row genre-items">
            <!-- 동적으로 로드될 내용 -->
        </div>
    </section>
    
    <!-- 뮤직 비디오 -->
    <section class="mt-5">
        <div class="section-title">뮤직 비디오</div>
        <div class="row music-video-items">
            <!-- 동적으로 로드될 내용 -->
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        fetchTop5Music();
        fetchLatestMusic();
        fetchGenreMusic();
        fetchMusicVideos();

        /* -------------------- 함수 선언 -------------------- */
        
        // 현재 뜨는 음악 (Top 5) 가져오기
        function fetchTop5Music() {
            fetch('/api/top5')
                .then(response => response.json())
                .then(data => {
                    const container = document.querySelector('.chart-items');
                    container.innerHTML = data.map(item => `
                        <div class="col-md-3 chart-item">
                            <img src="${item.image}" alt="음악 이미지">
                            <div class="item-title">${item.title}</div>
                            <div class="item-artist">${item.artist}</div>
                        </div>
                    `).join('');
                })
                .catch(error => console.error('Error fetching top 5 music:', error));
        }

        // 최신 음악 가져오기
        function fetchLatestMusic() {
            fetch('/api/latest')
                .then(response => response.json())
                .then(data => {
                    const container = document.querySelector('.hot-new-items');
                    container.innerHTML = data.map(item => `
                        <div class="col-md-3 hot-new-item">
                            <img src="${item.image}" alt="음악 이미지">
                            <div class="item-title">${item.title}</div>
                            <div class="item-artist">${item.artist}</div>
                        </div>
                    `).join('');
                })
                .catch(error => console.error('Error fetching latest music:', error));
        }

        // 장르별 음악 가져오기
        function fetchGenreMusic() {
            fetch('/api/genres')
                .then(response => response.json())
                .then(data => {
                    const container = document.querySelector('.genre-items');
                    container.innerHTML = data.map(item => `
                        <div class="col-md-3 genre-item">
                            <img src="${item.image}" alt="음악 이미지">
                            <div class="item-title">${item.title}</div>
                            <div class="item-artist">${item.artist}</div>
                        </div>
                    `).join('');
                })
                .catch(error => console.error('Error fetching genre music:', error));
        }

        // 뮤직 비디오 가져오기
        function fetchMusicVideos() {
            fetch('/api/musicvideos')
                .then(response => response.json())
                .then(data => {
                    const container = document.querySelector('.music-video-items');
                    container.innerHTML = data.map(item => `
                        <div class="col-md-3 music-video-item">
                            <img src="${item.image}" alt="뮤직 비디오 이미지">
                            <div class="item-title">${item.title}</div>
                            <div class="item-artist">${item.artist}</div>
                        </div>
                    `).join('');
                })
                .catch(error => console.error('Error fetching music videos:', error));
        }
    });
</script>
</body>
</html>
