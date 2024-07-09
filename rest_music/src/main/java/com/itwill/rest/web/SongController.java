package com.itwill.rest.web;

import java.util.Arrays;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwill.rest.dto.song.SongChartDto;
import com.itwill.rest.dto.song.SearchResultDto;
import com.itwill.rest.dto.song.SongDetailDto;
import com.itwill.rest.dto.song.SongLikeDto;
import com.itwill.rest.dto.song.SongSearchDto;
import com.itwill.rest.service.SongService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/song")
public class SongController {

	private final SongService songService;
	@GetMapping("/detail")
	public String songDetail(@RequestParam(name = "songId")int id, Model model ) {
		log.debug("id={}",id);
		
		SongDetailDto data = songService.readDetail(id);
		
		model.addAttribute("songId",id);
		model.addAttribute("data", data);
		
		return "song/songDetail";
	}
	
	@PutMapping("/like")
	@ResponseBody
	public boolean songLikes(@RequestBody SongLikeDto dto) {
		
		log.debug("dto={}",dto);
		boolean result = songService.likes(dto);
		
		return result;
	}
	
	@PostMapping("/like")
	@ResponseBody
	public boolean isLikes(@RequestBody SongLikeDto dto) {
		
		boolean result = songService.isLikes(dto);
		
		return result;
	}
	
	@GetMapping("/search")
	public void songSearch(SongSearchDto dto, Model model) {
		log.debug("dto={}",dto);
		
		List<SearchResultDto> result = songService.searchSongs(dto);
		
		log.debug("result={}",result);
		
		model.addAttribute("result", result);
		
	}
	
	@GetMapping("/rest/search")
	@ResponseBody
	public ResponseEntity<List<SearchResultDto>> restSongSearch(SongSearchDto dto) {
		log.debug("dto={}",dto);
		
		List<SearchResultDto> result = songService.searchSongs(dto);
		
		log.debug("result={}",result);
		
		return ResponseEntity.ok(result);
	}
	
	// top30 차트
	@GetMapping("/popularChart")
	public void showPopularSongs(Model model, HttpSession session) {
		log.debug("showPopularSongs({})", model);

		Integer id = (Integer) session.getAttribute("loginUserId");
		log.debug("Session loginUserId: {}", id);
		id = (id == null) ? 0 : id;

		List<SongChartDto> list = songService.readTopSongs(id);
		model.addAttribute("topSongs", list);
		model.addAttribute("loginUserId", id);
	}
	
	// 전체 or 장르별 차트
	@GetMapping("/genreChart")
	public String showSongs(Model model, @RequestParam(name = "genreName", required = false, defaultValue = "전체") String genreName, HttpSession session) {
		log.debug("showSongs(model = {}, genreName = {})", model, genreName);
		
		Integer id = (Integer) session.getAttribute("loginUserId");
	    id = (id == null) ? 0 : id;
	    
	    List<SongChartDto> list = "전체".equals(genreName) 
	            ? songService.readAllSongs(id)
	            : songService.readSongsByGenre(genreName, id);
	    
	    model.addAttribute("genreSongs", list);
	    model.addAttribute("genres", Arrays.asList("전체", "OST", "댄스", "발라드", "팝", "힙합"));
	    model.addAttribute("loginUserId", id);
	    return "/song/genreChart";
	    
	}
	
}
