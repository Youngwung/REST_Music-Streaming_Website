package com.itwill.rest.dto.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor @AllArgsConstructor @Builder
public class UserLikeDto {
	private Integer id;
	private Integer songId;
	private Integer albumId;
	private String userId;
	private String songPath;
	private String title;
	private String genre;
	private String albumName;
	private String albumImage;
	private String albumType;
	private Integer artistId;
	private String artistName;

}