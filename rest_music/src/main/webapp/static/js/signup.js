document.addEventListener('DOMContentLoaded', () => {
    let useridChecked = false;
    let userNameChecked = false;
    let passwordChecked = false;
    let confirmPasswordChecked = false;
    let emailChecked = false;
    let nicknameChecked = false;
    let hintQuestionChecked = false;
    let hintAnswerChecked = false;
    let authNumberChecked = false;
    let authNumber;

    const inputUserid = document.querySelector('input#userid');
    inputUserid.addEventListener('change', checkUserid);

    const btnCheckId = document.querySelector('button#checkIdBtn');
    btnCheckId.addEventListener('click', checkUserid);

    const inputPassword = document.querySelector('input#password');
    inputPassword.addEventListener('change', checkPassword);
    inputPassword.addEventListener('input', checkPassword);

    const inputConfirmPassword = document.querySelector('input#confirmPassword');
    inputConfirmPassword.addEventListener('change', checkConfirmPassword);
    inputConfirmPassword.addEventListener('input', checkConfirmPassword);

    const inputEmail = document.querySelector('input#email');
    inputEmail.addEventListener('change', checkEmail);

    const btnMailCheck = document.querySelector('button#mailCheckBtn');
    btnMailCheck.addEventListener('click', sendEmailAuth);

    const btnVerifyCode = document.querySelector('button#verifyCodeBtn');
    btnVerifyCode.addEventListener('click', checkAuthNumber);

    const inputUserName = document.querySelector('input#username');
    inputUserName.addEventListener('change', checkUserName);

    /*const inputNickname = document.querySelector('input#nickname');
    inputNickname.addEventListener('change', function() {
        nicknameChecked = false;
        document.querySelector('div#checkNicknameResult').innerHTML = '';
    });*/
    
    
    
    const inputNickname = document.querySelector('input#nickname');
    inputNickname.addEventListener('change', checkNickname);
    
    
    

    /*const btnCheckNickname = document.querySelector('button#checkNicknameBtn');
    btnCheckNickname.addEventListener('click', checkNickname);*/

    const inputHintQuestion = document.querySelector('select#hintQuestionSelect');
    inputHintQuestion.addEventListener('change', checkHintQuestion);

    const inputHintAnswer = document.querySelector('input#hintAnswer');
    inputHintAnswer.addEventListener('change', checkHintAnswer);

    const emailVerificationCode = document.querySelector('input#emailVerificationCode');
    emailVerificationCode.addEventListener('change', checkVerificationcode);

    /* -------------------- 함수 선언 -------------------- */
    
    // 회원 가입 버튼 활성화/비활성화
    function changeButtonState() {
        const btnSignUp = document.querySelector('button#btnSignUp');
        if (useridChecked && passwordChecked && confirmPasswordChecked && emailChecked && nicknameChecked && hintQuestionChecked && hintAnswerChecked && authNumberChecked) {
            btnSignUp.classList.remove('disabled');
            btnSignUp.disabled = false;
        } else {
            btnSignUp.classList.add('disabled');
            btnSignUp.disabled = true;
        }
    }

    // userid 입력 필드의 change 이벤트 리스너:
    // 중복 아이디 체크 Ajax 요청을 보내고, 응답을 받았을 때 처리.
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

    // 사용자이름 입력 필드의 change 이벤트 리스너
    function checkUserName(event) {
        if (event.target.value === '') {
            userNameChecked = false;
        } else {
            userNameChecked = true;
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 비밀번호 입력 필드의 change 이벤트 리스너
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

    // 비밀번호 확인 입력 필드의 change 이벤트 리스너
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

    // 이메일 입력 필드의 change 이벤트 리스너
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

        const uri = `/Rest/user/checkemail?email=${email}`;
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
                changeButtonState();
            })
            .catch((error) => console.log(error));
    }

    // 이메일 인증번호 발송
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
    
        // 난수로 생성한 인증번호를 알맞게 쓰는 지 검사하는 코드
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

    // 닉네임 입력 필드의 change 이벤트 리스너
    function checkNickname(event) {
        const nickname = event.target.value;
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

    // 힌트 질문 입력 필드의 change 이벤트 리스너
    // input#hintQuestion 비어 있는 지를 체크
    function checkHintQuestion(event) {
        if (event.target.value === '') {
            hintQuestionChecked = false;
        } else {
            const selectedText = document.querySelector('select[name="hintQuestionSelect"] > option:checked').innerText;
            document.getElementById("hintQuestion").value = selectedText;
            hintQuestionChecked = true;
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

    // 힌트 답변 입력 필드의 change 이벤트 리스너
    // input#hintAnswer 비어 있는 지를 체크
    function checkHintAnswer(event) {
        if (event.target.value === '') {
            hintAnswerChecked = false;
        } else {
            hintAnswerChecked = true;
        }
        changeButtonState(); // 버튼의 활성화/비활성화 상태를 변경
    }

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

    loginBtn.addEventListener('click', () => {
        location.href = 'signin';
    });

    function checkVerificationcode() {
        btnVerifyCode.removeAttribute('disabled');
    }
});
