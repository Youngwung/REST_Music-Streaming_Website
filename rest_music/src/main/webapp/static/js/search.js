/**
 *  search.jsp에 포함
 */
document.addEventListener('DOMContentLoaded', () => {
    const btnAddPlayLists = document.querySelectorAll('button.addPlayList');

    const playListModal = new bootstrap.Modal(document.querySelector('div#staticBackdrop'), { backdrop: 'static' });
    
    
    // 현재 페이지의 URL 가져오기
    const currentUrl = window.location.href;
    
    // URL에서 쿼리 문자열 파싱
    const url = new URL(currentUrl);
    const params = new URLSearchParams(url.search);
    
    
    const btnAccuracy = document.querySelector('button#accuracy');
    btnAccuracy.addEventListener('click', ()=> {
        sort('accuracy');
    })
    const btnRecency = document.querySelector('button#recency');
    btnRecency.addEventListener('click', ()=> {
         sort('recency');
    })
    const btnAlphabet = document.querySelector('button#alphabet');
    btnAlphabet.addEventListener('click', ()=>{
         sort('alphabet');
    })
    
    let songId;

    let currentPage = 1;
    const itemsPerPage = 5;
    let playlistsData = [];
    let startRow = 11;
    let endRow = 20;

    const urlParams = new URLSearchParams(window.location.search);
    const restKeyword = urlParams.get('keyword');
    const category = urlParams.get('category');

    const keyword = document.querySelector('input#keyword');
    const tbody = document.querySelector('tbody#searchResult');
    const form = document.querySelector('form#searchForm');

    let debounceTimer;

    form.addEventListener('keydown', () => {
        if (keyword.value.trim() === '') {
            keyword.value = '';
            return;
        }
    });

    const addPlayButton = document.querySelectorAll('button#listenBtn');
    for(let e of addPlayButton){
        e.addEventListener('click', (event) => {
            event.stopPropagation(); // 이벤트 버블링 방지
        });
    }
    
    const addNextPlayButton = document.querySelectorAll('button.addNextPlay');
    for(let e of addNextPlayButton){
        e.addEventListener('click', (event) => {
            event.stopPropagation(); // 이벤트 버블링 방지
        });
    }

    window.onscroll = function() {
        // 이전에 설정된 디바운스 타이머를 제거
        clearTimeout(debounceTimer);

        // 100ms 후에 스크롤 이벤트가 반응하도록 디바운스 타이머 설정
        debounceTimer = setTimeout(function() {
            if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
                loadMoreData();
            }
        }, 100); // 100ms 후에 다시 호출되지 않으면 추가 로딩 실행
    };
    
    function sort(newest) {
        
    // 새로운 sortType 값 설정 (예시: 'newest'로 변경)
    let newSortType = newest;
    
    // 기존 sortType 값과 새로운 값 비교하여 변경
    params.set('sortType', newSortType);  // 새로운 값으로 변경
    
    // 변경된 쿼리 문자열을 적용한 새로운 URL 생성
    url.search = params.toString();
    const newUrl = url.toString();
    
    // 변경된 URL로 리다이렉트
    window.location.href = newUrl;
    }
    
    // url에서 쿼리문의 마지막 파라미터 가져오기
    let lastQueryParamValue;
    for (let value of urlParams.values()) {
        lastQueryParamValue = value;
    }

    // lastQueryParamValue에 따라 버튼 색 변경
    if(lastQueryParamValue === 'accuracy'){
        btnAccuracy.style.color = 'blue';  
    } else if (lastQueryParamValue === 'recency'){
        btnRecency.style.color = 'blue';
    } else if (lastQueryParamValue === 'alphabet'){
        btnAlphabet.style.color = 'blue';
    };
    
    function loadMoreData() {
        axios.get('./rest/search', {
            params: {
                category: category,
                keyword: restKeyword,
                sortType: lastQueryParamValue,
                startRow: startRow,
                endRow: endRow
            }
        })
            .then(function(response) {
                // Handle success
                const data = response.data;
                if (data.length === 0) {
                    window.onscroll = null;
                    return;
                }

                if (data.length > 0) {
                    console.log(startRow);
                    console.log(endRow);
                    data.forEach(function(item) {
                        const songDetailsPage = `../song/detail?songId=${item.songId}`;
                        const newRow = document.createElement('tr');
                        newRow.style.cursor = 'pointer';
                        newRow.setAttribute('data-song-id', item.songId);
                        newRow.onclick = function() { location.href = songDetailsPage; };

                        newRow.innerHTML = `
                            <td style="width: 118px;"><img alt="albumcover" src="../images/albumcover/${item.albumImage}" 
                             class="img-thumbnail" width="120px" height="120px"/></td>
                            <td style="width:60%;"><span class="fs-4">${item.title}</span> <br/> <br/> ${item.albumName}</td>
                            <td><br/><span class="text-center fw-bold">${item.singerName}</span></td>
                            <td style="text-align: center;"><button data-id="${item.songId}" style="background-image: url('../images/icon/play.png'); width:50px; height:50px;
                             background-size: cover; background-repeat: no-repeat;" id="listenBtn" class="btnListen btn mt-3"></button></td>
                             <td style="text-align: center;"><button style="background-image: url('../images/icon/playList.png'); width: 60px; height: 60px; background-size: cover; 
                             background-repeat: no-repeat;" class="btn addNextPlay mt-3"></button></td>
                            <td style="text-align: center;"><button style="background-image: url('../images/icon/myPlayList.png'); width:55px; height:55px;
                            background-size: cover; background-repeat: no-repeat;" class="btn addPlayList mt-3"></button></td>
                        `;

                        // 새로운 행에 이벤트 리스너 추가
                        const addPlayListButton = newRow.querySelector('button.addPlayList');
                        addPlayListButton.addEventListener('click', function(e) {
                            e.stopPropagation(); // 이벤트 버블링 방지
                            getPlayLists(e);
                        });

                        const addPlayButton = newRow.querySelector('button#listenBtn'); // 바로듣기
                        addPlayButton.addEventListener('click', function(e) {
                            e.stopPropagation(); // 이벤트 버블링 방지
                        });
                        
                        const addNextPlayButton = newRow.querySelector('button.addNextPlay');
                            addNextPlayButton.addEventListener('click', (event) => {
                                event.stopPropagation(); // 이벤트 버블링 방지
                        });
                        

                        // tbody에 새로운 행 추가
                        tbody.appendChild(newRow);
                    });

                    // 다음 조회를 위해 행 범위 업데이트
                    startRow = endRow + 1;
                    endRow += 10;
                }
            })
            .catch(function(error) {
                // Handle error
                console.error(error);
            });
    }



    for (let a of btnAddPlayLists) {
        a.addEventListener('click', getPlayLists);
    }

    function getPlayLists(event) {
        event.stopPropagation();
        if (loginUserId == '') { // 유저아이디
            alert('로그인이 필요합니다');
            return;
        }
        songId = event.target.closest('tr').getAttribute('data-song-id');

        const uri = `../getPlayList/${loginUserId}`;
        axios
            .get(uri)
            .then((response) => {

                playlistsData = response.data;

                displayPlayLists(currentPage);

                setupPagination();

                playListModal.show();
            })
            .catch((error) => {
                console.log(error);
            });

    }

    function makePlayListElements(data) {
        // 플리 목록 HTML이 삽입될 div
        const divPlayLists = document.querySelector('div#playLists');

        // 플리 목록 HTML 코드
        let htmlStr = '';
        for (let playlist of data) {
            // 기본 이미지 URL 정의
            const defaultImage = '../images/icon/default.png';

            // ${playlist.albumImage}가 null이면 기본 이미지 사용
            const albumImageSrc = playlist.albumImage ? `../images/albumcover/${playlist.albumImage}` : defaultImage;


            htmlStr += `
            <a class="playList btn btn-outline-success form-control mt-2" data-id="${playlist.plistId}" >
            <div class="d-flex align-items-center">
                <div class="flex-shrink-0">
                    <img src="${albumImageSrc}" alt="..." width="50px" height="50px">
                  </div>
                    <div class="flex-grow-1 ms-3">
                    ${playlist.plistName}
                  </div>
                </div>
            </a>`;
        }

        // 작성된 HTML 코드를 div 영역에 삽입.
        divPlayLists.innerHTML = htmlStr;

        const aPlayLists = document.querySelectorAll('a.playList');
        for (let a of aPlayLists) {
            a.addEventListener('click', addSongPlayList);
        }


    }

    function addSongPlayList(event) {

        const plistId = event.currentTarget.getAttribute('data-id');


        const data = { plistId, songId };

        axios.post('../checkSongInPlayList', data)
            .then((response) => {
                if (!response.data) {
                    if (confirm('이미 추가된 곡입니다. 그래도 추가하시겠습니까?')) {
                        // 사용자가 확인을 눌렀을 때 추가 요청 보냄
                        addToPlayList(data);
                    }
                } else {
                    // 데이터가 없으면 바로 추가 요청 보냄
                    addToPlayList(data);
                }
            })
            .catch((error) => {
                console.log(error);
            });

        function addToPlayList(data) {
            axios
                .post('../addSongToPlayList', data)
                .then((response) => {
                    alert(`추가 성공`);
                    playListModal.hide();
                })
                .catch((error) => {
                    console.log(error);
                });
        }

    }

    function displayPlayLists(page) {
        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const paginatedPlaylists = playlistsData.slice(startIndex, endIndex);
        makePlayListElements(paginatedPlaylists);
    }

    function setupPagination() {
        const totalPages = Math.ceil(playlistsData.length / itemsPerPage);
        const paginationElement = document.getElementById('pagination');
        let paginationHtml = '';

        for (let i = 1; i <= totalPages; i++) {
            if (i === currentPage) {
                paginationHtml += `
                    <li class="page-item active" aria-current="page">
                        <span class="page-link">${i}</span>
                    </li>
                `;
            } else {
                paginationHtml += `
                    <li class="page-item">
                        <a class="page-link" href="#" data-page="${i}">${i}</a>
                    </li>
                `;
            }
        }

        paginationElement.innerHTML = paginationHtml;

        // 기존 이벤트 리스너 제거
        paginationElement.removeEventListener('click', handlePaginationClick);

        // 이벤트 리스너 등록
        paginationElement.addEventListener('click', handlePaginationClick);
    }

    function handlePaginationClick(event) {
        event.preventDefault(); // 기본 동작 방지
        if (event.target.tagName === 'A') {
            const page = parseInt(event.target.getAttribute('data-page'));
            changePage(page);
        }
    }

    function changePage(page) {
        currentPage = page;
        displayPlayLists(currentPage);
        setupPagination(); // 이 부분에서 이벤트 리스너를 다시 등록하지 않아도 됨
    }

});