/*
 * signup.jsp에 포함된 JavaScript 코드
 * 이 스크립트는 회원 가입 페이지의 유효성 검사 및 사용자 입력 처리를 담당합니다.
 */

document.addEventListener('DOMContentLoaded', () => {
    // 초기 상태 설정
    let useridChecked = false;      // 아이디 중복 검사 상태
    let userNameChecked = false;   // 사용자 이름 입력 확인 상태
    let passwordChecked = false;   // 비밀번호 유효성 검사 상태
    let confirmPasswordChecked = false;  // 비밀번호 확인 상태
    let emailChecked = false;      // 이메일 유효성 검사 상태
    let nicknameChecked = false;   // 닉네임 중복 검사 상태
    let authNumberChecked = false; // 이메일 인증번호 확인 상태
    let authNumber;                // 이메일 인증번호 저장 변수

    // 아이디 입력 필드와 관련된 이벤트 리스너
    const inputUserid = document.querySelector('input#userid');
    inputUserid.addEventListener('change', checkUserid); // 아이디 변경 시 유효성 검사 함수 호출
    
    // 비밀번호 입력 필드와 관련된 이벤트 리스너
    const inputPassword = document.querySelector('input#password');
    inputPassword.addEventListener('change', checkPassword); // 비밀번호 변경 시 유효성 검사 함수 호출
    inputPassword.addEventListener('input', checkPassword);  // 비밀번호 입력 시 실시간 유효성 검사
    
    // 비밀번호 확인 입력 필드와 관련된 이벤트 리스너
    const inputConfirmPassword = document.querySelector('input#confirmPassword');
    inputConfirmPassword.addEventListener('change', checkConfirmPassword); // 비밀번호 확인 시 유효성 검사 함수 호출
    inputConfirmPassword.addEventListener('input', checkConfirmPassword);  // 비밀번호 확인 입력 시 실시간 유효성 검사
    
    // 이메일 입력 필드와 관련된 이벤트 리스너
    const inputEmail = document.querySelector('input#email');
    inputEmail.addEventListener('change', checkEmail);  // 이메일 변경 시 유효성 검사 함수 호출
    
    // 이메일 인증번호 발송 버튼과 관련된 이벤트 리스너
    const btnMailCheck = document.querySelector('button#mailCheckBtn');
    btnMailCheck.addEventListener('click', sendEmailAuth);  // 이메일 인증번호 발송 함수 호출
    
    // 이메일 인증번호 확인 버튼과 관련된 이벤트 리스너
    const btnVerifyCode = document.querySelector('button#verifyCodeBtn');
    btnVerifyCode.addEventListener('click', checkAuthNumber);  // 인증번호 확인 함수 호출
    
    // 사용자 이름 입력 필드와 관련된 이벤트 리스너
    const inputUserName = document.querySelector('input#username');
    inputUserName.addEventListener('change', checkUserName);  // 사용자 이름 입력 시 유효성 검사 함수 호출
    
    // 닉네임 입력 필드와 관련된 이벤트 리스너
    const inputNickname = document.querySelector('input#nickname');
    inputNickname.addEventListener('change', checkNickname);  // 닉네임 변경 시 유효성 검사 함수 호출
    
    // 힌트 질문 관련 DOM 요소
    const hintQuestionInput = document.getElementById('hintQuestion');
    const hintQuestionSelect = document.getElementById('hintQuestionSelect');
    const hintAnswerInput = document.getElementById('hintAnswer');
    
    // 힌트 질문 선택 시 입력 필드 업데이트
    hintQuestionSelect.addEventListener('change', checkHintQuestion);
    
    // 힌트 답변 입력 필드와 관련된 이벤트 리스너
    hintAnswerInput.addEventListener('change', checkHintAnswer);
    
    // 이메일 인증번호 입력 필드와 관련된 이벤트 리스너
    const emailVerificationCode = document.querySelector('input#emailVerificationCode');
    emailVerificationCode.addEventListener('change', checkVerificationcode);  // 이메일 인증번호 입력 시 활성화
    
    /* -------------------- 함수 선언 -------------------- */
    
    // 회원 가입 버튼 활성화/비활성화 함수
    function changeButtonState() {
        const btnSignUp = document.querySelector('button#btnSignUp');
        // 모든 검사가 완료된 경우 버튼을 활성화
        if (useridChecked && passwordChecked && confirmPasswordChecked && emailChecked && nicknameChecked && authNumberChecked) {
            btnSignUp.classList.remove('disabled');
            btnSignUp.disabled = false;
        } else {
            btnSignUp.classList.add('disabled');
            btnSignUp.disabled = true;
        }
    }

    // 아이디 유효성 검사 및 중복 체크 함수
    function checkUserid(event) {
        const userid = inputUserid.value;
        const checkUseridResult = document.querySelector('div#checkUseridResult');

        if (userid === '') {
            useridChecked = false;
            checkUseridResult.innerHTML = '아이디를 입력해주세요.';
            checkUseridResult.classList.add('text-danger');
            checkUseridResult.classList.remove('text-success');
            return;
        }

        if (!/^[a-z0-9]{5,20}$/.test(userid)) {
            useridChecked = false;
            checkUseridResult.innerHTML = '아이디는 5~20자의 영문 소문자와 숫자만 사용 가능합니다.';
            checkUseridResult.classList.add('text-danger');
            checkUseridResult.classList.remove('text-success');
            return;
        }

        const uri = `/Rest/user/checkid?userid=${userid}`; // 아이디 중복 체크 REST API URI
        axios
            .get(uri)
            .then((response) => {
                if (response.data === 'Y') {
                    useridChecked = true;
                    checkUseridResult.innerHTML = '사용 가능한 아이디입니다.';
                    checkUseridResult.classList.add('text-success');
                    checkUseridResult.classList.remove('text-danger');
                } else {
                    useridChecked = false;
                    checkUseridResult.innerHTML = '사용할 수 없는 아이디입니다.';
                    checkUseridResult.classList.add('text-danger');
                    checkUseridResult.classList.remove('text-success');
                }
                changeButtonState(); // 버튼 활성화 여부를 변경
            })
            .catch((error) => console.log(error));
    }

    // 사용자 이름 유효성 검사 함수
    function checkUserName(event) {
        // 사용자 이름이 입력된 경우 유효성 검사 상태를 true로 설정
        if (event.target.value === '') {
            userNameChecked = false;
        } else {
            userNameChecked = true;
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 비밀번호 유효성 검사 함수
    function checkPassword(event) {
        const password = event.target.value;
        const checkPasswordResult = document.querySelector('div#checkPasswordResult');
        const passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;

        if (!passwordPattern.test(password)) {
            passwordChecked = false;
            checkPasswordResult.innerHTML = '8자 이상의 영문 대/소문자와 숫자만 사용 가능합니다.';
            checkPasswordResult.classList.add('text-danger');
            checkPasswordResult.classList.remove('text-success');
        } else {
            passwordChecked = true;
            checkPasswordResult.innerHTML = '';
            checkPasswordResult.classList.remove('text-danger');
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 비밀번호 확인 유효성 검사 함수
    function checkConfirmPassword(event) {
        const password = document.querySelector('input#password').value;
        const confirmPassword = event.target.value;
        const checkPasswordResult = document.querySelector('div#checkPasswordResult');

        if (password !== confirmPassword) {
            confirmPasswordChecked = false;
            checkPasswordResult.innerHTML = '비밀번호가 일치하지 않습니다.';
            checkPasswordResult.classList.add('text-danger');
            checkPasswordResult.classList.remove('text-success');
        } else {
            confirmPasswordChecked = true;
            checkPasswordResult.innerHTML = '비밀번호가 일치합니다.';
            checkPasswordResult.classList.add('text-success');
            checkPasswordResult.classList.remove('text-danger');
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 이메일 유효성 검사 함수
    function checkEmail(event) {
        const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
        const email = event.target.value;
        const checkEmailResult = document.querySelector('div#checkEmailResult');

        if (email === '') {
            emailChecked = false;
            checkEmailResult.innerHTML = '이메일을 입력해주세요.';
            checkEmailResult.classList.add('text-danger');
            checkEmailResult.classList.remove('text-success');
            return;
        }

        if (!emailPattern.test(email)) {
            emailChecked = false;
            checkEmailResult.innerHTML = '이메일 형식이 올바르지 않습니다.';
            checkEmailResult.classList.add('text-danger');
            checkEmailResult.classList.remove('text-success');
            return;
        }

        const uri = `/Rest/user/checkemail?email=${email}`; // 이메일 중복 체크 REST API URI
        axios.get(uri)
            .then((response) => {
                if (response.data === 'Y') {
                    emailChecked = true;
                    checkEmailResult.innerHTML = '사용 가능한 이메일입니다.';
                    checkEmailResult.classList.add('text-success');
                    checkEmailResult.classList.remove('text-danger');
                } else {
                    emailChecked = false;
                    checkEmailResult.innerHTML = '사용할 수 없는 이메일입니다.';
                    checkEmailResult.classList.add('text-danger');
                    checkEmailResult.classList.remove('text-success');
                }
                changeButtonState(); // 버튼 활성화 여부를 변경
            })
            .catch((error) => console.log(error));
    }

    // 이메일 인증번호 발송 함수
    function sendEmailAuth(event) {
        const email = inputEmail.value;
        if (email) {
            axios.get('/Rest/user/sendEmailAuth', {
                params: { email: email }
            })
            .then(function(response) {
                if (response.data) {
                    document.getElementById('emailVerificationCode').disabled = false;
                    authNumber = response.data; // 서버에서 받은 인증번호를 전역 변수에 저장
                    alert('인증번호가 이메일로 발송되었습니다.');
                } else {
                    alert('이메일 발송에 실패했습니다.');
                }
            })
            .catch(function(error) {
                console.error(error);
                alert('이메일 발송 중 오류가 발생했습니다.');
            });
        } else {
            alert('이메일을 입력해주세요.');
        }
    }
    
    // 이메일 인증번호 확인 함수
    function checkAuthNumber(event) {
        const inputAuthNumber = document.querySelector('input#emailVerificationCode').value;
        const checkEmailVerificationResult = document.querySelector('span#emailVerificationResult');

        if (inputAuthNumber == authNumber) {  // 전역 변수와 비교
            authNumberChecked = true;
            checkEmailVerificationResult.innerHTML = '인증번호가 일치합니다.';
            checkEmailVerificationResult.classList.add('text-success');
            checkEmailVerificationResult.classList.remove('text-danger');
        } else {
            authNumberChecked = false;
            checkEmailVerificationResult.innerHTML = '인증번호가 일치하지 않습니다.';
            checkEmailVerificationResult.classList.add('text-danger');
            checkEmailVerificationResult.classList.remove('text-success');
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 닉네임 유효성 검사 및 중복 체크 함수
    function checkNickname(event) {
        const nickname = inputNickname.value;
        const checkNicknameResult = document.querySelector('div#checkNicknameResult');

        if (nickname === '') {
            nicknameChecked = false;
            checkNicknameResult.innerHTML = '닉네임을 입력해주세요.';
            checkNicknameResult.classList.add('text-danger');
            checkNicknameResult.classList.remove('text-success');
            return;
        }

        if (!/^[a-zA-Z0-9가-힣]{2,20}$/.test(nickname)) {
            nicknameChecked = false;
            checkNicknameResult.innerHTML = '닉네임은 2~20자의 영문, 숫자, 한글만 사용 가능합니다.';
            checkNicknameResult.classList.add('text-danger');
            checkNicknameResult.classList.remove('text-success');
            return;
        }

        const uri = `/Rest/user/checknickname?nickname=${nickname}`; // 닉네임 중복 체크 REST API URI
        axios
            .get(uri)
            .then((response) => {
                if (response.data === 'Y') {
                    nicknameChecked = true;
                    checkNicknameResult.innerHTML = '사용 가능한 닉네임입니다.';
                    checkNicknameResult.classList.add('text-success');
                    checkNicknameResult.classList.remove('text-danger');
                } else {
                    nicknameChecked = false;
                    checkNicknameResult.innerHTML = '사용할 수 없는 닉네임입니다.';
                    checkNicknameResult.classList.add('text-danger');
                    checkNicknameResult.classList.remove('text-success');
                }
                changeButtonState(); // 버튼 활성화 여부를 변경
            })
            .catch((error) => console.log(error));
    }

    // 힌트 질문 선택 시 입력 필드 업데이트 함수
    function checkHintQuestion(event) {
        if (event.target.value === '') {
            hintQuestionInput.value = 'null'; // 기본값 설정
        } else {
            const selectedText = hintQuestionSelect.options[hintQuestionSelect.selectedIndex].text;
            hintQuestionInput.value = selectedText;
        }
    }

    // 힌트 답변 입력 필드의 유효성 검사 함수
    function checkHintAnswer(event) {
        if (event.target.value.trim() === '') {
            hintAnswerInput.value = 'null'; // 기본값 설정
        }
    }

    // 회원 가입 버튼 클릭 시 폼 제출 처리
    const btnSignUp = document.querySelector('#btnSignUp');
    const signupform = document.querySelector('#signupForm');
    const loginBtn = document.querySelector('#loginBtn');
    btnSignUp.addEventListener('click', (event) => {
        event.preventDefault();
        const result = confirm('이 정보로 회원가입을 하시겠습니까?');
        if (result) {
            signupform.action = 'signup';
            signupform.method = 'POST';
            signupform.submit();
            alert("회원 가입이 완료되었습니다.");
        }
    });

    // 로그인 페이지로 이동
    loginBtn.addEventListener('click', () => {
        location.href = 'signin';
    });

    // 이메일 인증번호 입력 시 버튼 활성화
    function checkVerificationcode() {
        btnVerifyCode.removeAttribute('disabled');
    }
});
