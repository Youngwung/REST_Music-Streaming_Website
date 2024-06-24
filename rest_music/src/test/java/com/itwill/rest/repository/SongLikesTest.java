package com.itwill.rest.repository;

import java.util.List;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/application-context.xml" })

public class SongLikesTest {

	@Autowired // 스프링 컨테이너가 생성/관리하는 빈을 주입받음.
	private SongLikesDao songLikesDao;

	 @Test
	public void testPopularSongs() {
		List<SongLikes> ranking = songLikesDao.popularSongs();
		Assertions.assertNotNull(ranking);
		for (SongLikes rank : ranking) {
			log.debug(rank.toString());
		}
	}

//	@Test
	public void testInsert() {
		SongLikes songLikes = SongLikes.builder().songId(1).id(1).build();
		int result = songLikesDao.insertSongLikes(songLikes);
		Assertions.assertEquals(1, result);

	}

//	@Test
	public void testDelete() {
		int result = songLikesDao.deleteSongLikes(1);
		Assertions.assertEquals(1, result);

	}

//	@Test
	public void testCountSongLikes() {
		int result = songLikesDao.countSongLikes(1);
		Assertions.assertEquals(15, result);
	}

}
