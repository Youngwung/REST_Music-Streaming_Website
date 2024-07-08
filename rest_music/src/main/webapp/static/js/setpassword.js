document.addEventListener('DOMContentLoaded', () => {
    let passwordChecked = false;
    let confirmPasswordChecked = false;

    const inputPassword = document.querySelector('input#password');
    const inputConfirmPassword = document.querySelector('input#confirmPassword');
    const checkPasswordResult = document.querySelector('div#checkPasswordResult');
    const btnSave = document.querySelector('input#btnSave');

    inputPassword.addEventListener('input', checkPassword);
    inputConfirmPassword.addEventListener('input', checkConfirmPassword);

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

    function changeButtonState() {
        if (passwordChecked && confirmPasswordChecked) {
            btnSave.classList.remove('disabled');
            btnSave.disabled = false;
        } else {
            btnSave.classList.add('disabled');
            btnSave.disabled = true;
        }
    }
});
