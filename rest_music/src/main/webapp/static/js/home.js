/**
 * home.jsp에 포함
 */

document.addEventListener('DOMContentLoaded', () => {
//    fetchMainSlider();
//    fetchTop5Music();
//    fetchLatestMusic();
//    fetchGenreMusic();
//    fetchMusicVideos();
    
    const prev = document.querySelector('#prev');
    const next = document.querySelector('#next');
    
    prev.addEventListener('click', plusSlides(-1));
    next.addEventListener('click', plusSlides(1));
    /* -------------------- 함수 선언 -------------------- */
    
    let slideIndex = 1;
    showSlides(slideIndex);

    // Next/previous controls
    function plusSlides(n) {
        showSlides(slideIndex += n);
    }

    // Thumbnail image controls
    function currentSlide(n) {
        showSlides(slideIndex = n);
    }

    function showSlides(n) {
        let i;
        let slides = document.getElementsByClassName("mySlides");
        let dots = document.getElementsByClassName("dot");
        if (n > slides.length) { slideIndex = 1 }
        if (n < 1) { slideIndex = slides.length }
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" active", "");
        }
        slides[slideIndex - 1].style.display = "block";
        dots[slideIndex - 1].className += " active";
    }
//
//    // 현재 뜨는 음악 (Top 5) 가져오기
//    function fetchTop5Music() {
//        fetch('/song/top5')
//            .then(response => response.json())
//            .then(data => {
//                const container = document.querySelector('#top5Carousel .carousel-inner');
//                container.innerHTML = data.map((item, index) => `
//                    <div class="carousel-item ${index === 0 ? 'active' : ''}">
//                        <img src="/static/data/${item.albumImage}" class="d-block w-100" alt="음악 이미지">
//                        <div class="carousel-caption d-none d-md-block">
//                            <h5>${item.title}</h5>
//                            <p>${item.artistName}</p>
//                        </div>
//                    </div>
//                `).join('');
//            })
//            .catch(error => console.error('Top 5 음악 가져오기 오류:', error));
//    }
//
//    // 최신 음악 가져오기
//    function fetchLatestMusic() {
//        fetch('/song/latest')
//            .then(response => response.json())
//            .then(data => {
//                const container = document.querySelector('.hot-new-items');
//                container.innerHTML = data.map(item => `
//                    <div class="col-md-3 hot-new-item">
//                        <img src="/static/data/${item.albumImage}" alt="음악 이미지">
//                        <div class="item-title">${item.title}</div>
//                        <div class="item-artist">${item.artistName}</div>
//                    </div>
//                `).join('');
//            })
//            .catch(error => console.error('최신 음악 가져오기 오류:', error));
//    }
//
//    // 장르별 음악 가져오기
//    function fetchGenreMusic() {
//        fetch('/song/genres')
//            .then(response => response.json())
//            .then(data => {
//                const container = document.querySelector('.genre-items');
//                container.innerHTML = data.map(item => `
//                    <div class="col-md-3 genre-item">
//                        <img src="/static/data/${item.albumImage}" alt="음악 이미지">
//                        <div class="item-title">${item.title}</div>
//                        <div class="item-artist">${item.artistName}</div>
//                    </div>
//                `).join('');
//            })
//            .catch(error => console.error('장르별 음악 가져오기 오류:', error));
//    }

    // 뮤직 비디오 가져오기
    function fetchMusicVideos() {
        fetch('/song/musicvideos')
            .then(response => response.json())
            .then(data => {
                const container = document.querySelector('.music-video-container');
                container.innerHTML = data.map(item => `
                    <div class="music-video-item">
                        <iframe src="${item.videoLink}" title="YouTube video player" frameborder="0" 
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                        allowfullscreen></iframe>
                    </div>
                `).join('');
            })
            .catch(error => console.error('뮤직 비디오 가져오기 오류:', error));
    }
});
