<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rest music</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #f8f9fa;
            padding: 1rem;
            text-align: center;
        }
        main {
            padding: 2rem;
            margin: 0 15%;
        }
        footer {
            background-color: #f8f9fa;
            padding: 1rem;
            text-align: center;
        }
        .carousel-item img {
            height: 400px;
            object-fit: cover;
        }
        .hot-new-item img, .genre-item img {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }
        .item-title {
            font-size: 0.9rem;
            font-weight: bold;
        }
        .item-artist {
            font-size: 0.8rem;
            color: gray;
        }
        .music-video-item iframe {
            width: 100%;
            height: 150px;
        }
        .music-video-container {
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }
    </style>
</head>
<body>
    <header>
        <%@ include file="./fragments/header.jspf"%>
    </header>
    
    <main>

        <div class="slideshow-container">

            <div class="mySlides fade">
                <div class="numbertext">1 / 3</div>
                <img src="./images/home/image1.jpg" style="width: 100%">
                <div class="text">Caption Text</div>
            </div>

            <div class="mySlides fade">
                <div class="numbertext">2 / 3</div>
                    <c:url var="albumCover"
                        value="./images/home/${data.albumImage}"></c:url>
                <div class="text">Caption Two</div>
            </div>

            <div class="mySlides fade">
                <div class="numbertext">3 / 3</div>
                <img src="./images/home/image3.jpg" style="width: 100%">
                <div class="text">Caption Three</div>
            </div>

            <a id="prev" class="prev">❮</a>
            <a id="next" class="next">❯</a>

        </div>
        <br>

        <div style="text-align: center">
            <span class="dot" onclick="currentSlide(1)"></span> <span
                class="dot" onclick="currentSlide(2)"></span> <span
                class="dot" onclick="currentSlide(3)"></span>
        </div>

        <!--Rest 차트 -->
        <c:url var="popularSongs" value="/song/popularChart" />
        <a class="dropdown-item" href="${popularSongs}">Rest 차트</a>

        <div id="top5Carousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <!-- Top 5 음악 항목들이 여기에 추가됩니다 -->
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#top5Carousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#top5Carousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
        
        <!-- 최신 음악 -->
        <c:url var="NewestSongs" value="/song/newest" />
        <a class="dropdown-item mt-5" href="${NewestSongs}">최신 음악</a>

        <div class="row hot-new-items">
            <!-- 최신 음악 항목들이 여기에 추가됩니다 -->
        </div>

         <!-- 장르별 음악 -->
        <c:url var="GenreSongs" value="/song/genreChart" />
        <a class="dropdown-item mt-5" href="${GenreSongs}">장르별 음악</a>
        
        <div class="row genre-items">
            <!-- 장르별 음악 항목들이 여기에 추가됩니다 -->
        </div>

        <h5 class="mt-5">뮤직 비디오</h5>
        <div class="music-video-container">
            <!-- 뮤직 비디오 항목들이 여기에 추가됩니다 -->
            <div class="music-video-item">
                <iframe src="https://www.youtube.com/embed/A4S8zl50AdM?si=Nc7iF09hFPY5nd_G" 
                title="YouTube video player" frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="music-video-item">
                <iframe src="https://www.youtube.com/embed/vnS_jn2uibs?si=oFTTqTsRplOwnqeg" 
                title="YouTube video player" frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="music-video-item">
                <iframe src="https://www.youtube.com/embed/lSD_L-xic9o?si=Pml36hgvZTYR-tgL" 
                title="YouTube video player" frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="music-video-item">
                <iframe src="https://www.youtube.com/embed/4n-9nb4obPY?si=c2-Qe_5ADnKJYpTj" 
                title="YouTube video player" frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="music-video-item">
                <iframe src="https://www.youtube.com/embed/rFg57EGXNOc?si=5hxZFnIdMVKcMwhl" 
                title="YouTube video player" frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
        </div>
    </main>
    
    <footer>
        <div class="container">
            <%@ include file="./fragments/footer.jspf" %>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="<c:url value='/js/home.js' />"></script>
</body>
</html>
