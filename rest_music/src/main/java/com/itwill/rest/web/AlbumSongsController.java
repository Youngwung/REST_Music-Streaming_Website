package com.itwill.rest.web;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.itwill.rest.dto.album.AlbumLikeDto;
import com.itwill.rest.repository.AlbumSongs;
import com.itwill.rest.service.AlbumSongsService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Controller
@Slf4j
@RequestMapping("/album")
public class AlbumSongsController {
	private final AlbumSongsService albumSongsService;

	@GetMapping("/detail")
	public void detail(
			@RequestParam(name = "albumId") String albumId,
			Model model,
			HttpSession session) throws JsonProcessingException {
		log.debug("detail({})", albumId);
		Integer albumIdInteger = Integer.parseInt(albumId);
		List<AlbumSongs> list = albumSongsService.selectByAlbumId(albumIdInteger);
		log.debug("list = {}", list);
		// 앨범의 수록곡 리스트를 뷰에 전달
		model.addAttribute("albumSongs", list);

		AlbumSongs album = albumSongsService.selectAlbumByAlbumId(albumIdInteger);
		System.out.println("sssssssssssaeeraaedddddddddddddddddddddddddddddddddddddddddddddddddddddddddd + " + album);
		log.debug("album = {}", album);
		// 앨범의 정보를 뷰의 전달
		model.addAttribute("album", album);

		Integer songsCount = albumSongsService.selectAlbumSongsCount(albumIdInteger);
		log.debug("songsCount = {}", songsCount);
		// 앨범의 수록곡 개수를 뷰에 전달
		model.addAttribute("songsCount", songsCount);

		// 앨범의 좋아요 개수를 뷰에 전달
		Integer albumLikesCount = albumSongsService.albumLikesCount(albumIdInteger);
		log.debug("albumLikesCount = {}", albumLikesCount);
		model.addAttribute("albumLikes", albumLikesCount);

	}

		@PutMapping("/like")
	@ResponseBody
	public boolean albumLikes(@RequestBody AlbumLikeDto dto) {
		
		log.debug("dto={}",dto);
		boolean result = albumSongsService.albumLikes(dto);
		
		return result;
	}
	
	@PostMapping("/like")
	@ResponseBody
	public boolean isAlbumLikes(@RequestBody AlbumLikeDto dto) {
		
		boolean result = albumSongsService.isAlbumLikes(dto);
		
		return result;
	}


	

}
