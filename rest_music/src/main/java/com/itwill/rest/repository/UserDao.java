package com.itwill.rest.repository;

import java.util.List;

import com.itwill.rest.dto.user.UserLikeDto;
import com.itwill.rest.dto.user.UserSignInDto;

public interface UserDao {
    User selectByUserId(String userId);
    User selectByEmail(String email);
    User selectByNickname(String nickname);
    int insert(User user);
    User selectByUserIdAndPassword(UserSignInDto dto);
	User selectByUserid(String userid);
	List<UserLikeDto> selectLikesByUserid(String userId);
    User findUserId(User user);
    User findpassword(User user);
    void setpassword(User user);
}