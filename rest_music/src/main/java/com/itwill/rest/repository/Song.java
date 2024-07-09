package com.itwill.rest.repository;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Song {
	private int songId;
	private int albumId;
	private String title;
	private String songPath;
	private String lyrics;
	private String videoLink;
	
}
