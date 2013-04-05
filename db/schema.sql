create table song (
    id char(16) not null default '' primary key,
    album_id char(12) not null default '',
    title varchar(64) not null default '',
    track int unsigned not null default 0,
    duration int unsigned not null default 0,
    filepath varchar(255) not null default ''
    );

create table album (
    id char(12) not null default '' primary key,
    name varchar(64) not null default '',
    artist_id char(12) not null default '',
    genre_id char(12) not null default '',
    year int unsigned not null default 0
    );

create table artist (
    id char(12) not null default '' primary key,
    name varchar(64) not null default ''
    );

create table genre (
    id char(12) not null default '' primary key,
    name varchar(16) not null default ''
    );
