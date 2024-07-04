/*
 * 테이블 15개 (컬럼 개수)
 *      albums (5개),     songs (7개),  title_songs (2개),    artists (4개),    artist_roles (3개),
 *      code_master (2개),    role_code (3개),  genre_code (3개), users (9개),     likes (2개),
 *      album_likes (2개),    comments (6개),  playlists (3개),   playlist_songs (3개),  pur_users (2개)
 *
 * 고유키(PK) 9개
 *      album_id (albums 테이블),   song_id (songs 테이블),   artist_id (artists 테이블), code_id (code_master 테이블),           
 *      role_id (role_code 테이블),    genre_id (genre_code 테이블),  id (users 테이블),  
 *      c_id (comments 테이블), p_list_id (playlists 테이블)
 */

create table albums ( -- 앨범 (컬럼 5개)
        album_id                        number(4) generated as identity, -- 앨범 번호 (4자리, 자동 생성)
    	album_name                      varchar2(50 char), -- 앨범 이름 (50글자)
    	album_image                     varchar2(100), -- 앨범 표지 이미지 (100바이트)
    	album_type                      varchar2(10 char) not null, -- 앨범 종류 (10글자, 낫 널)
    	album_release_date              date, -- 발매일 (날짜 - 시분초 표시 안 함)
    	constraint albums_album_id_pk   primary key (album_id) -- 앨범 번호 (고유키)
);

create table songs ( -- 음악 (컬럼 7개)
        song_id                             number(5) generated as identity, -- 음악 번호 (5자리, 자동 생성)
        album_id                            number(4), -- 앨범 번호 (4자리)
        title                               varchar2(30 char) not null, -- 음악 제목 (30글자, 낫 널)
        song_path                           varchar2(200) not null, -- 음악 파일 경로 (200바이트, 낫 널)
        lyrics                              varchar2(100) not null, -- 음악 가사 (100바이트, 낫 널)
        video_link                          varchar2(200), -- 뮤비 링크 (200바이트)
        
        ------- 장르 코드 테이블로 변경해야됨!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      --  genre_id                            number(4), -- 장르 번호 (4자리)
        
        constraint songs_song_id_pk         primary key (song_id), -- 음악 번호 (고유키)
        constraint songs_album_id_fk        foreign key (album_id) references albums (album_id) -- 앨범 번호 (외래키)

);

create table song_genre (
    song_id number(4) references songs (song_id),
    genre_id number(4) references genre_code (genre_id)
)

create table title_songs ( -- 타이틀 곡 (컬럼 2개)
        album_id                            number(4), -- 앨범 번호 (4자리)
        song_id                             number(5), -- 음악 번호 (5자리)
        constraint title_songs_album_id_fk  foreign key (album_id) references albums (album_id), -- 앨범 번호 (외래키)
        constraint title_songs_song_id_fk   foreign key (song_id) references songs (song_id) -- 음악 번호 (외래키)

);

create table artists ( -- 아티스트 (컬럼 4개)
        artist_id                           number(4) generated as identity, -- 아티스트 번호 (4자리, 자동 생성)
        artist_name                         varchar2(20 char) not null, -- 아티스트 이름 (20글자, 낫 널)
        artist_image                        varchar2(100), -- 아티스트 이미지 (100바이트)
        artist_description                  varchar2(100), -- 아티스트 설명 (100바이트) (나무위키) 이 적혀져있는 txt파일 경로
       constraint artists_artist_id_pk      primary key (artist_id) -- 아티스트 번호 (고유키)
        
);

create table artist_roles ( -- 아티스트 참여 음원 (컬럼 3개)
    artist_id                                  number(4), -- 아티스트 번호 (4자리)
    song_id                                    number(5), -- 음악 번호 (5자리)
    role_id                                    number(4), -- 역할 번호 (4자리)
    constraint artist_roles_artist_id_fk       foreign key (artist_id) references artists (artist_id), -- 아티스트 번호 (외래키)
    constraint artist_roles_song_id_fk         foreign key (song_id) references songs (song_id), -- 음악 번호 (외래키)
    constraint artist_roles_role_id_fk         foreign key (role_id) references role_code (role_id) -- 역할 번호 (외래키)
)

create table code_master ( -- 코드 마스터 (컬럼 2개)
    code_id                                 number(4), -- 코드 번호 (4자리) (자동 생성 아님)
    code_name                               varchar2(20 char) not null, -- 코드 네임 (20글자, 낫 널)
    -- code_id: 1, code_name:roles
    -- code_id: 2, code_name:genre
    constraint code_master_code_id_pk       primary key (code_id) -- 역할 번호 (고유키)
)

create table role_code ( -- 역할 코드 (컬럼 3개)
    code_id                                 number(4), -- 코드 번호 (4자리)
    role_name                               varchar2(20 char) not null, -- 역할 이름 (20글자, 낫 널) ex: 가수, 작곡가, 작사가, 편곡가
    role_id                                 number(4), -- 역할 번호 (4자리) (자동 생성 아님) ex: 가수 - 10, 작곡가 - 20, 작사가 - 30 ...
    constraint role_code_code_id_fk         foreign key (code_id) references code_master (code_id), -- 코드 번호 (외래키)
    constraint role_code_role_id_pk         primary key (role_id) -- 역할 번호 (고유키)
)

create table genre_code ( -- 장르 코드 (컬럼 3개)
    code_id                                 number(4), -- 코드 번호 (4자리)
    genre_name                              varchar2(10 char) not null, -- 장르 이름 (10글자, 낫 널) ex: 발라드, 팝, 힙합
    genre_id                                number(4), -- 장르 번호 (4자리) (자동 생성 아님) ex: 발라드 - 10, 팝 - 20, 힙합 - 30 ...
    constraint genre_code_code_id_fk        foreign key (code_id) references code_master (code_id), -- 코드 번호 (외래키)
    constraint genre_code_genre_id_pk       primary key (genre_id) -- 장르 번호 (고유키)
)
 
create table users ( -- 회원 (컬럼 9개)
        id number(4)                        generated as identity, -- 회원 번호 (4자리, 자동 생성)
        user_name                           varchar2(20 char) not null, --  회원 이름 (20글자, 낫 널)
        user_id                             varchar2(20) not null, -- 회원 아이디 (20바이트, 낫 널)
        password                            varchar2(30) not null, -- 비밀번호 (30바이트, 낫 널)
        email                               varchar2(30) not null, -- 이메일 (30바이트, 낫 널)
        nickname                            varchar2(20 char) not null, -- 닉네임 (20글자, 낫 널)
        user_profile                        varchar2(100), -- 회원_프로필 (100바이트)
        hint_question                       varchar2(50 char), -- 힌트질문 (50글자)
        hint_answer                         varchar2(50 char), -- 힌트답변 (50글자)
        constraint users_id_pk              primary key (id), -- 회원 번호 (고유키)
        constraint users_user_id_uq         unique (user_id), -- 회원 아이디 (유니크)
        constraint users_email_uq           unique (email), -- 이메일 (유니크)
        constraint users_nickname_uq        unique (nickname) -- 닉네임 (유니크)
);

create table likes ( -- 좋아요 (컬럼 2개)
        song_id                             number(5), -- 음악 번호 (5자리)
        id                                  number(4), -- 회원 번호 (4자리)
        constraint likes_song_id_fk         foreign key (song_id) references songs (song_id), -- 음악 번호 (외래키)
        constraint likes_id_fk              foreign key (id) references users (id) -- 회원 번호 (외래키)

);

create table album_likes( -- 앨범 좋아요 (컬럼 2개)
        album_id                                number(4), -- 앨범 번호 (5자리)
        id                                      number(4), -- 회원 번호 (4자리)
        constraint album_likes_album_id_fk      foreign key (album_id) references albums (album_id), -- 앨범 번호 (외래키)
        constraint album_likes_id_fk            foreign key (id) references users (id) -- 회원 번호 (외래키)        
)

create table comments ( -- 댓글 (컬럼 6개)
        c_id number(5)                      generated as identity, -- 댓글 번호 (5자리, 자동 생성)
        song_id                             number(5), -- 음악 번호 (5자리)
        id                                  number(4), -- 회원 번호 (4자리)
        c_text                              varchar2(200 char) not null, -- 댓글 내용 (200글자, 낫 널)
        created_time                        timestamp default systimestamp, -- 작성 시간 (현재 시간 - 시분초까지 표시함.)
        modified_time                       timestamp default systimestamp, -- 수정 시간 (현재 시간 - 시분초까지 표시함.)
        constraint comments_c_id_pk         primary key (c_id), -- 댓글 번호 (고유키)
        constraint comments_song_id_fk      foreign key (song_id) references songs (song_id), -- 음악 번호 (외래키)
        constraint comments_id_fk           foreign key (id) references users (id) -- 회원 번호 (외래키)
);

create table playlists ( -- 플레이리스트 (컬럼 3개)
        p_list_id                           number(4) generated as identity, -- 플리 번호 (4자리, 자동 생성)
        id                                  number(4), -- 회원 번호 (4자리)
        p_list_name                         varchar2(20 char) not null, -- 플리 이름 (20글자, 낫 널)
        constraint playlists_p_list_id_pk   primary key (p_list_id), -- 플리 번호 (고유키)
        constraint playlists_id_fk          foreign key (id) references users (id) -- 회원 번호 (외래키)

);

create table playlist_songs ( -- 플레이리스트 저장 곡 (컬럼 3개)
        p_list_id                               number(4), -- 플리 번호 (4자리)
        song_id                                 number(5), -- 음악 번호 (5자리)
        created_time                            timestamp default systimestamp, -- 플리 저장 시간 (현재 시간 - 시분초까지 표시함)         
        constraint playlist_songs_p_list_id_fk  foreign key (p_list_id) references playlists (p_list_id), -- 플리 번호 (외래키)
        constraint playlist_songs_song_id_fk    foreign key (song_id) references songs (song_id) -- 음악 번호 (외래키)

);

create table pur_users ( -- 결제 회원 (컬럼 2개)
        id                              number(4), -- 회원 번호 (4자리)
        expiration_date                 date, -- 만료일 (날짜 - 시분초 표시 안 함)
        constraint pur_users_id_fk      foreign key (id) references users (id) -- 회원 번호 (외래키)
);

commit;

    