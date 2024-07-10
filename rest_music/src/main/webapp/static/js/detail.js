/**
 *  detail.jsp 포함
 */
document.addEventListener('DOMContentLoaded', () => {

    const btnAddPlayList = document.querySelector('button#btnAddPlayList');

    const btnLike = document.querySelector('button#btnLike');

     const playListModal = new bootstrap.Modal(document.querySelector('div#staticBackdrop'), { backdrop: 'static' });
    btnAddPlayList.addEventListener('click', getPlayLists);
    
    if(loginUserId == ''){
        const commnetRegistForm = document.querySelector('div#commnetRegistForm')
        commnetRegistForm.classList.add('d-none');
    }
    
    const data = { songId, loginUserId };
    let currentPage = 1;
    const itemsPerPage = 5;
    let playlistsData = [];
    if(loginUserId != ''){
    axios
        .post('./like', data)
        .then((response) => {
            if (response.data) {
                btnLike.textContent = '♡';
            } else {
                btnLike.textContent = '♥';
            }
        }
        )
        .catch((error) => {
            console.log(error);
        });
    } else {
        btnLike.textContent = '♡';
    }


    btnLike.addEventListener('click', () => {
    if(loginUserId == '') {
        alert('로그인이 필요합니다');
        return
        }
        axios
            .put('./like', data)
            .then((response) => {
                if (response.data) {
                    btnLike.textContent = '♥';
                } else {
                    btnLike.textContent = '♡';
                }
            }
            )
            .catch((error) => {
                console.log(error);
            });

    });

    function getPlayLists() {
        if(loginUserId == '' ) {
        alert('로그인이 필요합니다');
        return
        }
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

