/**
 * popular.jsp
 */

document.addEventListener("DOMContentLoaded", function() {
    // 좋아요 아이콘 클릭 이벤트 핸들러
    const heartIcons = document.querySelectorAll('.heart-icon');
    
    heartIcons.forEach(icon => {
        const songId = icon.dataset.songId;
        const id = parseInt(icon.dataset.id);
        let likesCountElement = icon.nextElementSibling; // 좋아요 개수를 표시하는 요소를 가져옴
        
        // 특정 사용자가 특정 노래를 좋아요 했는지 여부를 서버에 요청
        const data = { songId, id }; 
        axios.post('../api/isLiked', data)
            .then(response => {
                // 서버 응답에 따라 좋아요 상태를 설정
                if (response.data) {
                    icon.classList.add('liked'); // liked 클래스를 추가
                    icon.classList.remove('far'); // 비어있는 하트 아이콘 클래스를 제거
                    icon.classList.add('fas'); // 채워진 하트 아이콘 클래스를 추가
                    icon.style.color = 'red'; // 아이콘 색상을 빨간색으로 설정
                } else {
                    icon.classList.remove('liked'); // liked 클래스를 제거
                    icon.classList.remove('fas'); // 채워진 하트 아이콘을 제거
                    icon.classList.add('far'); // 비어있는 하트 아이콘을 추가
                    icon.style.color = 'black'; // 아이콘 색상을 검은색으로 설정
                }

                // 아이콘 클릭 이벤트 리스너 추가
                icon.addEventListener('click', function() {
                    if (id === 0) { // 로그인하지 않은 경우
                        const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                        loginModal.show();
                        return;
                    }
                
                    let likesCount = parseInt(likesCountElement.textContent); // 현재 좋아요 개수를 가져옴

                    if (icon.classList.contains('liked')) { // 이미 좋아요 상태인 경우
                        // 좋아요 취소 요청을 서버로 보냄
                        axios.delete(`../api/cancelLike/${songId}/${id}`)
                            .then(response => {
                                if (response.status === 200) { // 서버 응답이 성공적인 경우
                                    icon.classList.remove('liked'); // liked 클래스를 제거
                                    icon.classList.remove('fas'); // 채워진 하트 아이콘을 제거
                                    icon.classList.add('far'); // 비어있는 하트 아이콘을 추가
                                    icon.style.color = 'black'; // 아이콘 색상을 검은색으로 설정
                                    likesCount -= 1; // 좋아요 개수를 1 감소
                                    likesCountElement.textContent = response.data; // 최신 좋아요 개수로 업데이트
                                }
                            })
                            .catch(error => {
                                console.error('좋아요 제거 중 오류:', error); // 오류 처리
                            });
                    } else { // 좋아요 상태가 아닌 경우
                        const data = { songId, id }; // 서버로 보낼 데이터 생성
                        // 좋아요 추가 요청을 서버로 보냄
                        axios.post('../api/addLike', data)
                            .then(response => {
                                if (response.status === 200) { // 서버 응답이 성공적인 경우
                                    icon.classList.add('liked'); // liked 클래스를 추가
                                    icon.classList.remove('far'); // 비어있는 하트 아이콘을 제거
                                    icon.classList.add('fas'); // 채워진 하트 아이콘을 추가
                                    icon.style.color = 'red'; // 아이콘 색상을 빨간색으로 설정
                                    likesCount += 1; // 좋아요 개수를 1 증가
                                    likesCountElement.textContent = response.data; // 최신 좋아요 개수로 업데이트
                                }
                            })
                            .catch(error => {
                                console.error('좋아요 추가 중 오류:', error); // 오류 처리
                            });
                    }
                });
            })
            .catch(error => {
                console.error('좋아요 상태 가져오는 중 오류:', error); // 오류 처리
                icon.classList.remove('liked'); // 오류 발생 시 기본 상태 설정
                icon.classList.remove('fas');
                icon.classList.add('far');
                icon.style.color = 'black';
            });
    });
    
    // 곡 재생 버튼 클릭 이벤트 핸들러
    const playButtons = document.querySelectorAll('.play-btn');
    const audioPlayer = document.getElementById('audioPlayer');
    const audioSource = document.getElementById('audioSource');
    const currentTimeSpan = document.getElementById('currentTime');
    const totalTimeSpan = document.getElementById('totalTime');
    
    playButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const songPath = button.dataset.songPath;
            const id = parseInt(button.dataset.id);
    
            // 로그인 상태 확인
            if (!id) {
                // 로그인하지 않은 상태일 경우
                alert("1분 미리듣기가 제공됩니다.");
                audioSource.src = songPath;
                audioPlayer.load();
                audioPlayer.play();
    
                // 총 재생 시간을 60초로 설정하고, 오디오의 duration을 60초로 설정합니다.
                audioPlayer.addEventListener('loadedmetadata', function() {
                    audioPlayer.currentTime = 0;  // 현재 시간 초기화
                    audioPlayer.duration = 60;   // 60초로 설정
                    totalTimeSpan.textContent = "1:00"; // 총 재생 시간 표시 (1:00)
                });
    
                // 현재 재생 시간을 업데이트하는 함수
                const updateCurrentTime = () => {
                    const seconds = Math.floor(audioPlayer.currentTime);
                    currentTimeSpan.textContent = `0:${seconds.toString().padStart(2, '0')}`; // 현재 시간 표시
                };
    
                // `timeupdate` 이벤트를 사용하여 현재 시간 출력
                audioPlayer.addEventListener('timeupdate', updateCurrentTime);
    
                // 1분 후 로그인 모달을 표시하고 오디오를 멈추고 초기화합니다.
                setTimeout(function() {
                    audioPlayer.pause();
                    audioPlayer.currentTime = 0;  // 현재 시간 초기화
                    alert("로그인 후 전체 곡을 들을 수 있습니다.");
                    // 로그인 모달을 띄우기 위한 코드
                    const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                    loginModal.show();
                    // `timeupdate` 이벤트 리스너를 제거합니다.
                    audioPlayer.removeEventListener('timeupdate', updateCurrentTime);
                }, 60000);  // 60,000ms = 1분
                
                // 마우스로 재생 시간을 스크롤할 때의 동작을 제어
                audioPlayer.addEventListener('seeking', function(event) {
                    // 만약 스크롤한 시간이 1분을 초과하면 1분으로 강제로 제한
                    if (audioPlayer.currentTime > 60) {
                        audioPlayer.currentTime = 60;
                    }
                });
    
                audioPlayer.addEventListener('timeupdate', function() {
                    // 현재 시간이 1분을 초과하면 1분으로 강제로 제한
                    if (audioPlayer.currentTime >= 60) {
                        audioPlayer.currentTime = 60;
                    }
                });
    
            } else {
                // 로그인한 상태일 경우
                audioSource.src = songPath;
                audioPlayer.load();
                audioPlayer.play();
    
                // 총 재생 시간을 실제 오디오 파일의 길이로 설정합니다.
                audioPlayer.addEventListener('loadedmetadata', function() {
                    const totalDuration = Math.floor(audioPlayer.duration);
                    const minutes = Math.floor(totalDuration / 60);
                    const seconds = Math.floor(totalDuration % 60);
                    totalTimeSpan.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`; // 총 재생 시간 표시
                });
    
                // 현재 재생 시간을 업데이트하는 함수
                const updateCurrentTime = () => {
                    const minutes = Math.floor(audioPlayer.currentTime / 60);
                    const seconds = Math.floor(audioPlayer.currentTime % 60);
                    currentTimeSpan.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`; // 현재 시간 표시
                };
    
                // `timeupdate` 이벤트를 사용하여 현재 시간 출력
                audioPlayer.addEventListener('timeupdate', updateCurrentTime);
                
                // 오디오의 currentTime을 0초에서 끝까지 이동 가능하게 설정
                audioPlayer.removeEventListener('seeking', function(event) {
                    // 아무 것도 하지 않음
                });
                audioPlayer.removeEventListener('timeupdate', function() {
                    // 아무 것도 하지 않음
                });
            }
        });
    });

    // 전체 선택 체크박스 이벤트 핸들러
    const selectAllCheckbox = document.getElementById('selectAllCheckbox');
    const songCheckboxes = document.querySelectorAll('.songCheckbox');
    const selectAllModal = new bootstrap.Modal(document.getElementById('selectAllModal'), {});

    // 전체 선택 체크박스 이벤트 핸들러
    selectAllCheckbox.addEventListener('change', function() {
        const isChecked = selectAllCheckbox.checked;
        songCheckboxes.forEach(checkbox => {
            checkbox.checked = isChecked;
        });
        if (isChecked) {
            selectAllModal.show();
        }
    });

    // 각 곡 체크박스 이벤트 핸들러
    songCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (!this.checked) {
                selectAllCheckbox.checked = false;
            }
        });
    });

    // "전체 듣기" 버튼 클릭 이벤트 핸들러
    document.getElementById('addAllToPlaylist').addEventListener('click', function() {
        // 전체 듣기 기능 구현
        alert('전체 듣기 버튼 클릭');
        selectAllModal.hide();
    });

    // 플레이리스트 불러오기 및 모달 표시 함수
    function showPlayListModal(id) {
        axios.get(`../getPlayList/${id}`)
            .then(response => {
                if (response.status === 200) {
                    const playLists = response.data;
                    const playListsContainer = document.getElementById('playLists');
                    playListsContainer.innerHTML = ''; // 기존 내용을 지움.

                    playLists.forEach(list => {
                        const listElement = document.createElement('div');
                        listElement.classList.add('form-check');
                        listElement.innerHTML = `
                            <input class="form-check-input songCheckbox" type="checkbox" value="${list.plistId}" id="playlist-${list.plistId}" data-playlist-id="${list.plistId}" />
                            <label class="form-check-label" for="playlist-${list.plistId}">${list.plistName}</label>
                        `;
                        playListsContainer.appendChild(listElement);
                    });

                    const selectPlayListModal = new bootstrap.Modal(document.getElementById('selectPlayList'));
                    selectPlayListModal.show();
                }
            })
            .catch(error => {
                console.error('플레이리스트를 불러오는 중 오류가 발생했습니다:', error);
            });
    }

    // 곡 추가 함수
    function addSongToPlaylists() {
        const selectedPlaylists = document.querySelectorAll('#playLists .form-check-input:checked');
        const selectedPlaylistIds = Array.from(selectedPlaylists).map(checkbox => checkbox.dataset.playlistId);

        // add-to-playlist-btn 클래스를 가진 버튼 중 현재 선택된 노래의 songId를 가져옵니다.
        const songIdElements = document.querySelectorAll('.add-to-playlist-btn.active');
        const songIds = Array.from(songIdElements).map(btn => btn.dataset.songId); // 현재 선택된 곡의 songId 배열 생성

        if (selectedPlaylistIds.length === 0) {
            alert('플레이리스트를 선택하세요.');
            return;
        }

        if (songIds.length === 0) { // 수정된 부분: songId 배열이 비어있는지 확인
            alert('곡을 선택하세요.');
            return;
        }

        const alreadyAdded = {};
        const promises = [];

        selectedPlaylistIds.forEach(plistId => {
            alreadyAdded[plistId] = false;

            songIds.forEach(songId => {
                console.log(`플레이리스트 ${plistId}에 곡 ${songId} 확인 중`);
                // 각 플레이리스트에 곡이 이미 추가되어 있는지 확인
                const checkPromise = axios.post(`../checkSongInPlayList`, {
                    plistId: plistId,
                    songId: songId
                }).then(response => {
                    console.log(`플레이리스트 ${plistId} 응답:`, response.data);
                    if (response.data === false) { // 곡이 이미 있는 경우
                        alreadyAdded[plistId] = true;
                    }
                }).catch(error => {
                    console.error('플레이리스트에서 곡 확인 중 오류가 발생했습니다:', error);
                });
                promises.push(checkPromise);
            });
        });

        Promise.all(promises).then(() => {
            const addedPlaylists = selectedPlaylistIds.filter(plistId => alreadyAdded[plistId]);
            if (addedPlaylists.length > 0) {
                alert('플레이리스트에 이미 추가된 곡입니다.');
                return;
            }

            // 곡이 추가되지 않은 플레이리스트에 추가
            const addPromises = selectedPlaylistIds.flatMap(plistId => {
                return songIds.map(songId => {
                    if (!alreadyAdded[plistId]) {
                        return axios.post(`../addSongToPlayList`, {
                            plistId: plistId,
                            songId: songId
                        });
                    }
                }).filter(Boolean);
            }).flat();

            Promise.all(addPromises).then(responses => {
                const allSuccessful = responses.every(response => response && response.status === 200);
                if (allSuccessful) {
                    alert('플레이리스트에 곡이 추가되었습니다.');
                    const selectPlayListModal = bootstrap.Modal.getInstance(document.getElementById('selectPlayList'));
                    selectPlayListModal.hide();
                }
            }).catch(error => {
                console.error('플레이리스트에 곡 추가 중 오류가 발생했습니다:', error);
                alert('플레이리스트에 곡을 추가하는 중 오류가 발생했습니다.');
            });
        });
    }

    // "전체 담기" 버튼 클릭 이벤트 핸들러
    document.getElementById('addAllToCollection').addEventListener('click', function() {
        const id = parseInt(document.querySelector('.add-to-playlist-btn').dataset.id);
        if (id === 0) { // 로그인하지 않은 경우
            const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
            loginModal.show();
            return;
        }
        // 기존의 전체 선택 모달을 숨깁니다.
        selectAllModal.hide();

        // "곡 추가" 버튼이 있는 모달 창을 열게 됩니다.
        showPlayListModal(id);  // "곡 추가" 모달 창을 엽니다.
    });

    // 플레이리스트에 곡 추가 버튼 클릭 이벤트 핸들러
    const saveButton = document.getElementById('btnAddSong');
    saveButton.addEventListener('click', addSongToPlaylists);
    
    // 플레이리스트 추가 버튼 클릭 이벤트 핸들러
    const addToPlaylistButtons = document.querySelectorAll('.add-to-playlist-btn');
    addToPlaylistButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            const id = parseInt(this.dataset.id);
            if (id === 0) { // 로그인하지 않은 경우
                const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                loginModal.show();
                return;
            }
            addToPlaylistButtons.forEach(btn => btn.classList.remove('active')); // 모든 버튼의 active 클래스 제거
            this.classList.add('active'); // 현재 클릭한 버튼에 active 클래스 추가
            showPlayListModal(id);
        });
    });

    // 모달 창이 나와도 다른 버튼들을 클릭할 수 있게 설정
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
        backdrop.style.pointerEvents = 'none';
    });

    // 로그인 모달
    const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
    const loginConfirmButton = document.getElementById('loginConfirmButton');
    const loginCancelButton = document.getElementById('loginCancelButton');

    loginConfirmButton.addEventListener('click', function() {
        const currentPath = location.pathname.replace('/Rest', '');
        location.href = '../user/signin?target=' + encodeURIComponent(currentPath);
    });

    loginCancelButton.addEventListener('click', function() {
        loginModal.hide();
    });

});
