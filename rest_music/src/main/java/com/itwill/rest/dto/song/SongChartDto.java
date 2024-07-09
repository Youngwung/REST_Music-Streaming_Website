package com.itwill.rest.dto.song;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor @AllArgsConstructor @Builder
public class SongChartDto {
	private Integer songId; // 음악 번호
	private Integer id; // 회원 번호
	private Integer genreId; // 장르 번호
	private String genreName; // 장르 이름
	private Integer albumId; // 앨범 번호
	private String albumImage; // 앨범 표지
	private String title; // 노래 제목
	private Integer artistId; // 아티스트 번호
	private String artistName; // 아티스트 이름
	private String albumName; // 앨범 이름
	private Integer likes; // 좋아요 개수
	private String songPath; // 음악 파일 경로
	private String videoLink; // 뮤비 링크
	
}

