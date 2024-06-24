package com.itwill.rest.repository;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// 차트 페이지의 좋아요를 위한 위한 클래스
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SongLikes {
	private Integer songId; // 음악 번호
	private Integer id; // 회원 번호
	private String albumImage; // 앨범 표지
	private String title; // 노래 제목
	private String singerName; // 가수 이름
	private String albumName; // 앨범 이름
	private Integer likes; // 좋아요 개수
	private String songPath; // 음악 파일 경로
	private String videoLink; // 뮤비 링크

}
