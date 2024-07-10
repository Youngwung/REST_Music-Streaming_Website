package com.itwill.rest.service;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.itwill.rest.dto.user.UserCreateDto;
import com.itwill.rest.dto.user.UserLikeDto;
import com.itwill.rest.dto.user.UserSignInDto;
import com.itwill.rest.dto.user.UserUpdateDto;
import com.itwill.rest.repository.User;
import com.itwill.rest.repository.UserDao;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

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
	
	public List<UserLikeDto> selectLikesByUserid(Integer id) {
		List<UserLikeDto> list = userDao.selectLikesByUserid(id);
		
		return list;
	}
	
    public User findUserId(User user) {
        return userDao.findUserId(user);
    }

    public User findpassword(User user) {
    	if ((user.getHintQuestion() == null || user.getHintQuestion().isEmpty()) &&
                (user.getHintAnswer() == null || user.getHintAnswer().isEmpty())) {
                user.setHintQuestion("null");
                user.setHintAnswer("null");
            }
    	log.debug("findpassword({})", user );
        return userDao.findpassword(user);
    }

    public void setpassword(User user) {
        userDao.setpassword(user);
    }
	
	// 프로필 변경
    public boolean updateProfileImage(String userId, MultipartFile profileImage, HttpServletRequest request) {
        try {
            // userId로 User 객체를 조회합니다. 만약 User가 존재하지 않으면 예외를 발생시킵니다.
            User user = userDao.selectByUserId(userId);
            if (user == null) {
                throw new RuntimeException("User with ID " + userId + " not found");
            }

            // 파일 타입 검증: 업로드된 파일이 이미지인지 확인합니다.
            if (!profileImage.getContentType().startsWith("image/")) {
                throw new RuntimeException("Uploaded file is not an image");
            }

            // 파일 사이즈 제한: 업로드된 파일의 크기가 10MB를 초과하지 않는지 확인합니다.
            final long MAX_FILE_SIZE = 10 * 1024 * 1024;  // 예: 10MB
            if (profileImage.getSize() > MAX_FILE_SIZE) {
                throw new RuntimeException("Uploaded file is too large");
            }
            
            // 파일의 원본 이름을 가져옵니다.
            String originalFilename = profileImage.getOriginalFilename();
            if (originalFilename == null || originalFilename.isEmpty()) {
                throw new RuntimeException("Uploaded file has no name");
            }

            // 파일을 저장할 디렉토리의 경로를 얻습니다. 이 경로는 상대 경로로, 웹 애플리케이션의 'images/profileimage' 디렉토리를 참조합니다.
            String uploadDir = request.getServletContext().getRealPath("/images/profileimage");
            File uploadDirFile = new File(uploadDir);
            
            // 디렉토리가 존재하지 않으면 생성합니다.
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // 새로 저장할 이미지 파일의 경로를 설정합니다.
            String filename = originalFilename;
            String filePath = uploadDir + File.separator + filename;
            File file = new File(filePath);
            
            // 업로드된 파일이 비어있지 않은지 확인합니다.
            if (profileImage.isEmpty()) {
                throw new RuntimeException("Uploaded file is empty");
            }
            
            // 파일을 지정된 경로에 저장합니다.
            profileImage.transferTo(file);

            // 저장된 파일의 경로를 사용자 프로필에 업데이트합니다. 웹에서 접근할 수 있는 경로를 설정합니다.
            String webPath = filename;
            user.setUserProfile(webPath);

            // DAO를 통해 업데이트된 User 객체를 DB에 반영합니다.
            userDao.updateUserProfile(userId, webPath);

            return true;
        } catch (IOException e) {
            // IOException 발생 시 에러를 출력하고 false를 반환합니다.
            e.printStackTrace();
            return false;
        }
    }
	
	// 정보 수정
    public int update(UserUpdateDto dto) {
        log.debug("update({})", dto);  // 로그에 전달된 UserUpdateDto 객체를 출력합니다.
        
        // 사용자 프로필 이미지가 없는 경우 빈 문자열로 설정합니다.
        if(dto.getUserProfile() == null ) {
            dto.setUserProfile("");
        }
        
        // 사용자 힌트 질문이 없는 경우 빈 문자열로 설정합니다.
        if(dto.getHintQuestion() == null) {
            dto.setHintQuestion("");
        }
        
        // 사용자 힌트 답변이 없는 경우 빈 문자열로 설정합니다.
        if(dto.getHintAnswer() == null) {
            dto.setHintAnswer("");
        }
        
        // UserUpdateDto를 User 엔티티로 변환하여 userDao를 통해 데이터베이스의 사용자 정보를 업데이트합니다.
        int result = userDao.updateUser(dto.toEntity());

        return result;  // 업데이트 결과를 반환합니다.
    }

}
