/**
 * home.jsp에 포함
 */

 document.addEventListener('DOMContentLoaded', () => {
    fetchTop5Music();
    fetchLatestMusic();
    fetchGenreMusic();

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
});
