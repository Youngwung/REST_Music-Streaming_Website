//package com.itwill.rest.repository;
//
//import java.util.List;
//
//import org.junit.jupiter.api.Assertions;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit.jupiter.SpringExtension;
//
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//@ExtendWith(SpringExtension.class)
//@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/application-context.xml" })
//
//public class SongDaoTest {
//
//	@Autowired
//	private SongDao songDao;
//
//	
//	@Test
//    public void testGetSongLikesRanking() {
//        List<Song> ranking = songDao.rankSongLikes();
//        Assertions.assertNotNull(ranking);
//        for (Song rank : ranking) {
//			log.debug(rank.toString());
//		}
//    }
//
//}
