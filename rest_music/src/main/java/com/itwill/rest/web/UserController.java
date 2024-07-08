package com.itwill.rest.web;

import com.itwill.rest.service.MailSendService;
import com.itwill.rest.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.itwill.rest.dto.user.UserCreateDto;
import com.itwill.rest.dto.user.UserLikeDto;
import com.itwill.rest.dto.user.UserSignInDto;
import com.itwill.rest.repository.User;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/user")
public class UserController {
    
    private final UserService userService;
    private final MailSendService mailSendService;
    
    @GetMapping("/mypage")
    public void myPage(@RequestParam(name = "userId") String userId, Model model) {
        log.debug("userId={}", userId);
        
        User user = userService.readInfo(userId); // 유저 정보 불러오기(프로필 사진, 닉네임 출력)
        List<UserLikeDto> list = userService.selectLikesByUserid(userId); // 유저가 좋아요 누른 곡 출력
        
        model.addAttribute("user", user);
        model.addAttribute("like", list);
    }
    
    @GetMapping("/playlists")
    public void playlist(@RequestParam(name = "userId") String userId, Model model) {
        log.debug("userId={}", userId);
        
        User user = userService.readInfo(userId); // 플레이리스트를 불러오기 위한 유저 정보(userId) 불러오기
        
        model.addAttribute("user", user);
    }
    
    @GetMapping("/signup") // GET 방식의 /user/signup 요청을 처리하는 컨트롤러 메서드 
    public void signUp() {
        log.debug("GET signUp()");
    }
    
    @PostMapping("/signup")
    public String signUp(UserCreateDto dto, HttpServletRequest request, HttpSession session) {
        log.debug("POST signUp({})", dto);

        String emailAuthNumber = (String) session.getAttribute("EMAIL_AUTH_NUMBER");
        String dtoAuthNumber = dto.getEmailAuthNumber().trim(); // dto에서 인증번호 가져오기

        log.debug("Session emailAuthNumber: {}", emailAuthNumber);
        log.debug("DTO emailAuthNumber: {}", dtoAuthNumber);

        if (emailAuthNumber == null || dtoAuthNumber == null || !dtoAuthNumber.equals(emailAuthNumber.trim())) {
            log.debug("Email authentication failed: emailAuthNumber={}, dtoAuthNumber={}", emailAuthNumber, dtoAuthNumber);
            return "redirect:/user/signup?result=emailAuthFail";
        }

        userService.create(dto, request);
        session.removeAttribute("EMAIL_AUTH_NUMBER");

        return "redirect:/user/signin";
    }

    
    // 사용자 아이디 중복체크 REST 컨트롤러
    @GetMapping("/checkid")
    @ResponseBody // 메서드 리턴 값이 클라이언트로 전달되는 데이터.
    public ResponseEntity<String> checkId(@RequestParam(name = "userid") String userid) {
        log.debug("checkId(userid={})", userid);
        
        boolean result = userService.checkUserId(userid);
        return ResponseEntity.ok(result ? "Y" : "N");
    }

    // 사용자 이메일 중복체크 REST 컨트롤러
    @GetMapping("/checkemail")
    @ResponseBody // 메서드 리턴 값이 클라이언트로 전달되는 데이터.
    public ResponseEntity<String> checkEmail(@RequestParam(name = "email") String email) {
        log.debug("checkEmail(email={})", email);
        
        boolean result = userService.checkEmail(email);
        return ResponseEntity.ok(result ? "Y" : "N");
    }
    
    // 사용자 닉네임 중복체크 REST 컨트롤러
    @GetMapping("/checknickname")
    @ResponseBody // 메서드 리턴 값이 클라이언트로 전달되는 데이터.
    public ResponseEntity<String> checkNickname(@RequestParam(name = "nickname") String nickname) {
        log.debug("checkNickname(nickname={})", nickname);
        
        boolean result = userService.checkNickname(nickname);
        return ResponseEntity.ok(result ? "Y" : "N");
    }

    @GetMapping("/signin")
    public void signIn() {
        log.debug("GET signIn()");
    }
    
    @PostMapping("/signin")
    public String signIn(UserSignInDto dto, 
            @RequestParam(name = "target", defaultValue = "") String target,
            HttpSession session) throws IOException {
        log.debug("POST signIn({})", dto);

        User user = userService.read(dto);
        String targetPage = "";
        if (user != null) { // 아이디와 비밀번호가 일치하는 사용자 있는 경우
            // 세션에 로그인 사용자 아이디를 저장
            session.setAttribute("SESSION_ATTR_USER", user.getUserId());

            // 로그인 성공 후 이동할 타겟 페이지
            targetPage = (target.equals("")) ? "/" : target;
            
        } else { // 아이디와 비밀번호가 일치하는 사용자 없는 경우
            targetPage = "/user/signin?result=f&target="
                    + URLEncoder.encode(target, "UTF-8");
        }

        return "redirect:" + targetPage;
    }
    
    @GetMapping("/signout")
    public String signOut(HttpSession session) {
        log.debug("signOut()");

        session.removeAttribute("SESSION_ATTR_USER");
        session.invalidate();
        
        return "redirect:/user/signin";
    }

    // 아이디 찾기 (화면)
    @GetMapping("/findUserId")
    public void findUserId() {
        log.debug("GET findUserId()");
    }

    // 아이디 찾기 (조회)
    @PostMapping("/findUserId")
    public String findUserId(User user) {
        log.debug("POST findUserId({})", user);
        String userId = null;
        String targetPage = "";

        User findUser = userService.findUserId(user);

        if(findUser != null) {
            userId = findUser.getUserId();
            targetPage = "/user/findUserResult?userId=" + userId;
        } else {
            targetPage = "/user/findUserId?result=f";
        }

        return "redirect:" + targetPage;

    }

    // 아이디 찾기 결과
    @GetMapping("/findUserResult")
    public void findUserResult(@RequestParam(name = "userId") String userId, Model model) {
        model.addAttribute("userId", userId);
        log.debug("GET findUserResult()");
    }

    // 비밀번호 찾기 (화면)
    @GetMapping("/findpassword")
    public void findpassword() {
        log.debug("GET findpassword()");
    }

    // 비밀번호 찾기 (조회)
    @PostMapping("findpassword")
    public String findpassword(User user) {
        log.debug("POST findpassword({})", user);

        User findUser = userService.findpassword(user);
        String targetPage = "";
        if (findUser != null) {
            targetPage = "/user/setpassword?userId=" + user.getUserId();
        } else {
            targetPage = "/user/findpassword?result=f";
        }

        return "redirect:" + targetPage;
    }

    // 비밀번호 설정 (화면)
    @GetMapping("setpassword")
    public void setpassword() {
        log.debug("GET setpassword()");
    }

    @PostMapping("setpassword")
    public String setpassword(User user) {
        log.debug("POST setpassword({})", user);

        userService.setpassword(user);

        return "redirect:/user/signin"; 
    }
    
    // 이메일 인증 번호 발송
    @GetMapping("/sendEmailAuth")
    @ResponseBody
    public ResponseEntity<String> sendEmailAuth(@RequestParam(name = "email") String email, HttpSession session) {
        log.debug("sendEmailAuth(email={})", email);
        String authNumber = mailSendService.joinEmail(email);
        session.setAttribute("EMAIL_AUTH_NUMBER", authNumber);
        return ResponseEntity.ok(authNumber);
    }

    // 이메일 인증 번호 검증
    @PostMapping("/verifyEmailAuth")
    @ResponseBody
    public ResponseEntity<String> verifyEmailAuth(@RequestParam(name = "inputAuthNumber") String inputAuthNumber, HttpSession session) {
        String authNumber = (String) session.getAttribute("EMAIL_AUTH_NUMBER");
        log.debug("verifyEmailAuth(authNumber={}, inputAuthNumber={})", authNumber, inputAuthNumber);
        if (authNumber != null && authNumber.equals(inputAuthNumber)) {
            return ResponseEntity.ok("Y");
        } else {
            return ResponseEntity.ok("N");
        }
    }
}
