/**
 * currentPlayList.jsp에 포함
 * detail.jsp에 포함
 */
document.addEventListener('DOMContentLoaded', () => {
    if (!sessionStorage.getItem('isAdded')) {
        sessionStorage.setItem('isAdded', 'N');
    }

    // 음원 다음 곡으로 재생 기능
    const addCPList = document.querySelectorAll('#addCPList');
    for (let a of addCPList) {
        a.addEventListener('click', addToCPList);
    }
    function addToCPList(event) {
        const id = event.target.getAttribute('data-id');
        const url = `../song/addCurrentPlayList?songId=${id}`
        console.log(url);
        axios.
            get(url).
            then((response) => {
                console.log(response);
                if (sessionStorage.getItem('isAdded') === 'N') {
                    sessionStorage.setItem('index', 0);
                    sessionStorage.setItem('isAdded', 'Y');
                    parent.songFrame.location.reload();
                }
                document.location.reload();
            }).
            catch((error) => { console.log(error); });
    }

    // 음원 듣기 기능
    const listenBtn = document.querySelectorAll('#listenBtn');
    for (let l of listenBtn) {
        l.addEventListener('click', clickListenBtn)
    }
    function clickListenBtn(event) {
        const id = event.target.getAttribute('data-id');
        const url = `../song/listen?songId=${id}`
        console.log(url);
        axios
            .get(url)
            .then((response) => {
                console.log("성공");
                sessionStorage.setItem('index', 0);
                sessionStorage.setItem('isAdded', 'Y');
                document.location.reload();
                parent.songFrame.location.reload();
            })
            .catch((error) => { });
    }

    // 앨범 듣기 기능
    const btnListenAlbum = document.querySelector('#btnListenAlbum');
    btnListenAlbum.addEventListener('click', listenAlbum);
    function listenAlbum(event) {
        const albumId = event.target.getAttribute('data-id');
        // console.log(id); // 정상작동: 1
        const url1 = `../api/album?albumId=${albumId}`;
        axios.
            get(url1).
            then((response) => {
                console.log(response);
                // 앨범의 음원 리스트를 가져옴
                let listSong = response.data;
                console.log(listSong);
                let songId2 = listSong[0].songId;
                let url2 = `../song/listen?songId=${songId2}`
                console.log(url2);
                // 첫 곡은 바로듣기 메서드를 호출, 그 이후는 재생목록에 추가 메서드를 호출
                // 바로듣기 레스트컨트롤러 호출 일단 바로듣기 버튼 복붙해서 씀.s
                axios
                    .get(url2)
                    .then((response) => {
                        console.log("성공");
                        sessionStorage.setItem('index', 0);
                        sessionStorage.setItem('isAdded', 'Y');
                        document.location.reload();
                        parent.songFrame.location.reload();
                        // 두번째 곡 이후부터는 재생목록에 추가.
                        for (let i = 1; i < listSong.length; i++) {
                            let id3 = listSong[i].songId;
                            let url3 = `../song/addCurrentPlayList?songId=${id3}`
                            console.log(url3);
                            axios.
                                get(url3).
                                then((response) => {
                                    console.log(response);
                                    if (sessionStorage.getItem('isAdded') === 'N') {
                                        sessionStorage.setItem('index', 0);
                                        sessionStorage.setItem('isAdded', 'Y');
                                        parent.songFrame.location.reload();
                                    }
                                }).
                                catch((error) => { console.log(error); });
                        }
                    })
                    .catch((error) => console.log(error));
            }).
            catch((error) => console.log(error));
    }


    // 앨범을 다음 곡으로 추가 기능
    const btnAddCPListAlbum = document.querySelector('#btnAddCPListAlbum');
    btnAddCPListAlbum.addEventListener('click', addCPListAlbum)

    function addCPListAlbum(event) {
        const albumId = event.target.getAttribute('data-id');
        // console.log(id); // 정상작동: 1
        let url = `../api/album?albumId=${albumId}`;
        axios.
            get(url).
            then((response) => {
                console.log(response);
                // 앨범의 음원 리스트를 가져옴
                let listSong = response.data;
                console.log(listSong);

                // 앨범의 모든 곡을 다음 재생 목록에 추가.
                for (let i = 0; i < listSong.length; i++) {
                    let id = listSong[i].songId;
                    url = `../song/addCurrentPlayList?songId=${id}`
                    console.log(url);
                    axios.
                        get(url).
                        then((response) => {
                            console.log(response);
                            if (sessionStorage.getItem('isAdded') === 'N') {
                                sessionStorage.setItem('index', 0);
                                sessionStorage.setItem('isAdded', 'Y');
                                parent.songFrame.location.reload();
                            }
                        }).
                        catch((error) => { console.log(error); });
                }
            }).
            catch((error) => console.log(error));


    }

    // 플리에 추가 기능
    const btnAddUPList = document.querySelector('#btnAddUPList');
    const playListModal = new bootstrap.Modal(document.querySelector('div#staticBackdrop'), { backdrop: 'static' });
    let currentPage = 1;
    const itemsPerPage = 5;
    let playlistsData = [];
    btnAddUPList.addEventListener('click', getPlayLists);
    function getPlayLists(event) {
        const uri = `../getPlayList/${id}`;
        songId = event.target.getAttribute('data-id');
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
            const defaultImage = '../images/default.png';

            // ${playlist.albumImage}가 null이면 기본 이미지 사용
            const albumImageSrc = playlist.albumImage ? `../images/${playlist.albumImage}` : defaultImage;


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



    // 아래는 다른 페이지에서도 사용하는 함수

    let isModalOpen = false;

    function showModal() {
        if (isModalOpen) {
            console.log('Modal is already open.');
            return;
        }
        console.log('mainFrame showModal 호출성공');
        let myModal = document.querySelector('#sessionListModal');
        console.log(myModal);
        let modal = new bootstrap.Modal(myModal);
        console.log(modal);
        getCPList();
        // Ajax요청을 보내고 모달에 태그를 작성하는 album_detail.js의 함수를 호출
        modal.show();

        // 모달이 열릴 때 상태 업데이트
        isModalOpen = true;

        myModal.addEventListener('hidden.bs.modal', () => {
            isModalOpen = false;
        });
    }
    // 다른 프레임에서 호출할 수 있도록 함수 노출
    window.showModal = showModal;
    // 챗지피티코드
    // 모달 버튼 클릭 시
    let openModalBtn = document.querySelectorAll('.openModalBtn');
    /*              for (let mo of openModalBtn) {
                        console.log(mo);
                        mo.addEventListener('click', getCPList());
                    } */
    openModalBtn.forEach((mo) => {
        mo.addEventListener('click', getCPList);

    });

    function getCPList() {
        const url = "../api/playList/cPList";
        // Ajax 요청을 보냄.
        axios
            .get(url)
            .then((response) => {
                console.log(response.data);
                // 재생 목록을 HTML로 작성 -> div#comments 영역에 출력.
                makeCPListElements(response.data);
            })
            .catch((error) => {
                console.log(error);
            });
    }
    // 외부에서 실행할 수 있도록 함수 노출
    window.getCPList = getCPList;

    function makeCPListElements(data) {
        // 모달 창에 리스트 출력하기
        let modalBody = document.getElementById('sessionListBody');
        let modal = document.querySelector('.modal');
        let modalCloseBtn = document.querySelectorAll('#modalCloseBtn');
        // modal.style.display = "none";
        modalBody.innerHTML = ''; // 모달 바디 초기화

        // 재생목록 관리를 위한 인덱스 선언
        if (!sessionStorage.getItem('index')) {
            sessionStorage.setItem('index', 0);
        }
        index = parseInt(sessionStorage.getItem('index'));
        console.log(index);
        if (data && data.length > 0) {
            // 리스트가 있을 경우 출력
            let ul = document.createElement('ul');
            ul.className = 'list-group';
            console.log(ul);

            for (let i = 0; i < data.length; i++) {
                let li = document.createElement('li');
                li.className = 'list-group-item';
                li.textContent = data[i].title;
                if (i == index) { // 현재 재생중인 곡인 지 검사
                    // 볼드체로 변경
                    li.classList.add('fw-bold');
                }
                ul.appendChild(li);
                console.log(li);
            }
            modalBody.appendChild(ul); // 모달에 작성.
            // if (modal.style.display !== 'block') {
            //  modal.style.display = 'block'; // 모달창 활성화
            // }
            // for (let m of modalCloseBtn) {
            //  // 닫기 버튼 활성화
            //  m.addEventListener('click', () => {
            //      modal.style.display = "none";
            //      // 포커스를 메인 프레임의 body로 이동하여 이벤트 리스너가 정상적으로 작동하도록 함
            //  });
            // }

            // window.onclick = function (event) {
            //  if (event.target == modal) {
            //      modal.style.display = "none";
            //      // 포커스를 메인 프레임의 body로 이동하여 이벤트 리스너가 정상적으로 작동하도록 함
            //  }
            // }

        } else {
            let li = document.createElement('li');
            li.textContent = '현재 재생목록이 없습니다.';
        }

        const cPList = document.querySelectorAll('.list-group-item');
        for (let i = 0; i < cPList.length; i++) {
            cPList[i].addEventListener('click', (event) => {
                sessionStorage.setItem('index', i);
                getCPList();
                // let modal = bootstrap.Modal.getInstance(document.querySelector('#sessionListModal'));
                // modal.hide();
                // modal.show();
                parent.songFrame.location.reload();
            });
        }

    }





});