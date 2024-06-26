package com.itwill.rest.dto.song;

import com.itwill.rest.repository.SongChart;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor @AllArgsConstructor @Builder
public class PopularSongsDto {
	private Integer songId; // 음악 번호
	private Integer id; // 회원 번호
	private String albumImage; // 앨범 표지
	private String title; // 노래 제목
	private String singerName; // 가수 이름
	private String albumName; // 앨범 이름
	private Integer likes; // 좋아요 개수
	private String songPath; // 음악 파일 경로
	private String videoLink; // 뮤비 링크
	
	public static PopularSongsDto fromEntity(SongChart songLikes) {
		return PopularSongsDto.builder()
				.songId(songLikes.getSongId())
				.id(songLikes.getId())
				.albumImage(songLikes.getAlbumImage())
				.title(songLikes.getTitle())
				.singerName(songLikes.getSingerName())
				.albumName(songLikes.getAlbumName())
				.likes(songLikes.getLikes())
				.songPath(songLikes.getSongPath())
				.videoLink(songLikes.getVideoLink())
				.build();
				
	}
	

}
