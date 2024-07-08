package com.itwill.rest.service;

import com.itwill.rest.dto.user.UserCreateDto;
import com.itwill.rest.dto.user.UserLikeDto;
import com.itwill.rest.dto.user.UserSignInDto;
import com.itwill.rest.repository.User;
import com.itwill.rest.repository.UserDao;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserService {
    private final UserDao userDao;

    private final ServletContext servletContext;

    // 아이디 중복 체크: true - 중복되지 않은 아이디(사용 가능한 아이디), false - 중복된 아이디.
    public boolean checkUserId(String userId) {
        log.debug("checkUserId(userId={})", userId);

        User user = userDao.selectByUserId(userId);
        return user == null;
    }

    // 이메일 중복 체크: true - 중복되지 않은 이메일(사용 가능한 이메일), false - 중복된 이메일.
    public boolean checkEmail(String email) {
        log.debug("checkEmail(email={})", email);

        User user = userDao.selectByEmail(email);
        return user == null;
    }
    
    // 닉네임 중복 체크
    public boolean checkNickname(String nickname) {
        log.debug("checkNickname(nickname={})", nickname);
        
        User user = userDao.selectByNickname(nickname);
        return user == null;
    }

    // 회원 가입 서비스
    public int create(UserCreateDto dto, HttpServletRequest request) {
        log.debug("create({})", dto);

        // 파일 업로드 제거

        return userDao.insert(dto.toEntity());
    }

    // 로그인 서비스
    public User read(UserSignInDto dto) {
        log.debug("read({})", dto);
        return userDao.selectByUserIdAndPassword(dto);
    }

    public User readInfo(String userId) {
        return userDao.selectByUserid(userId);
    }

    public List<UserLikeDto> selectLikesByUserid(String userId) {
        List<UserLikeDto> list = userDao.selectLikesByUserid(userId);

        return list;
    }

    public User findUserId(User user) {
        return userDao.findUserId(user);
    }

    public User findpassword(User user) {
        return userDao.findpassword(user);
    }

    public void setpassword(User user) {
        userDao.setpassword(user);
    }

}
