

--***** PROJECT BY LORENA TZION *****--

/*
ISRAELI MUSIC – LATIN PEOPLE LIVING IN ISRAEL

A database project for a music platform for Latina community in Israel,
where users create cultural playlists featuring at least two Israeli
singers and two Israeli songs, fostering a connection through music. 

*/


--*** DATABASE CREATION ***--

--CREATE DATABASE LatinaILlMusic
GO
USE [LatinaILlMusic]



--*** TABLE CREATION ***--

--Table Users--
--Stores the basic information of the music platform users.
--Includes a minimum age validation (18 years) and unique email
--to ensure data integrity and avoid duplicates.
CREATE TABLE Users(
	UsersId INT IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	BirthDate DATE NOT NULL,
	OriginCountry NVARCHAR(20) NOT NULL,
	ActualCity NVARCHAR(20),
	Country NVARCHAR(10) DEFAULT 'Israel',
	AlyahYear INT,
	Gender NVARCHAR(1) NOT NULL,

	CONSTRAINT PKUsers PRIMARY KEY (UsersId),
	CONSTRAINT UQEmail UNIQUE (Email),
	CONSTRAINT CKUserAge
		CHECK (BirthDate <= (DATEADD(YEAR,-18,GETDATE()))),
	CONSTRAINT CKEmailUsers
		CHECK (Email LIKE '%_@_%._%'),
	CONSTRAINT CKAlyahYear
		CHECK (AlyahYear >= 1948 AND AlyahYear <= YEAR(GETDATE())),
	CONSTRAINT CKGender
		CHECK (Gender IN ('M','F','O'))
)

--Table Artist--
--Stores information about musical artists.
CREATE TABLE Artist(
	ArtistId INT IDENTITY(1,1),
	ArtistName NVARCHAR(50) NOT NULL,
	MusicStyle NVARCHAR(100) NOT NULL,
	LanguageArt NVARCHAR(20) DEFAULT 'Hebrew',
	DebutYear INT,
	ArtistActive BIT,

	CONSTRAINT PKArtist PRIMARY KEY (ArtistId)
)

--Table Album--
--Stores information about musical albums.
CREATE TABLE Album(
	AlbumId INT IDENTITY(1,1),
	AlbumName NVARCHAR(50) NOT NULL,
	NumSongs TINYINT,
	ArtistId INT NOT NULL,
	ReleaseYearAlbum INT,

	CONSTRAINT PKAlbum PRIMARY KEY (AlbumId),
	CONSTRAINT FKAlbumArtist
		FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId)
)

--Table Artist--
--Stores information about songs.
CREATE TABLE Songs(
	SongsId INT IDENTITY(1,1),
	SongsName NVARCHAR(50) NOT NULL,
	Duration TIME,
	ReleaseYearSong INT,
	ArtistId INT NOT NULL,
	AlbumId INT,

	CONSTRAINT PKSongs PRIMARY KEY (SongsId),
	CONSTRAINT FKSongsArtist
		FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId),
	CONSTRAINT FKSongsAlbum
		FOREIGN KEY (AlbumId) REFERENCES Album(AlbumId)
)

 --Table UsersFavoriteArtist--
 --Intermediate table representing the many-to-many relationship
 --between users and artists.
 --A Ranking field is included to indicate the user's preference.
 --The constraints ensure that:
 --1. A user cannot repeat the same artist.
 --2. A user cannot repeat the same ranking.
  CREATE TABLE UsersFavoriteArtist(
	UsersFavoriteArtistId INT IDENTITY(1,1),
	UsersId INT NOT NULL,
	ArtistId INT NOT NULL,
	Ranking INT NOT NULL,

	CONSTRAINT PKUsersFavoriteArtistId PRIMARY KEY (UsersFavoriteArtistId),
	CONSTRAINT FKUsersFavoriteArtistUsers
		FOREIGN KEY (UsersId) REFERENCES Users(UsersId),
	CONSTRAINT FKUsersFavoriteArtistArtist
		FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId),
	CHECK(Ranking>=1),
	CONSTRAINT UQUserArtistUsersId UNIQUE (UsersId,ArtistId),
	CONSTRAINT UQUserArtistRankingId UNIQUE (UsersId,Ranking)
)

 --Table UsersFavoriteSongs--
 --Intermediate table representing the many-to-many relationship
 --between users and songs.
 --A Ranking field is included to indicate the user's preference.
 --The constraints ensure that:
 --1. A user cannot repeat the same song.
 --2. A user cannot repeat the same ranking.
 CREATE TABLE UsersFavoriteSongs(
	UsersFavoriteSongsId INT IDENTITY(1,1),
	UsersId INT NOT NULL,
	SongsId INT NOT NULL,
	Ranking INT NOT NULL,

	CONSTRAINT PKUsersFavoriteSongsId PRIMARY KEY (UsersFavoriteSongsId),
	CONSTRAINT FKUsersFavoriteSongsUsers
		FOREIGN KEY (UsersId) REFERENCES Users(UsersId),
	CONSTRAINT FKUsersFavoriteSongsSongs
		FOREIGN KEY (SongsId) REFERENCES Songs(SongsId),
	CHECK(Ranking>=1),
	CONSTRAINT UQUUsersSongsId UNIQUE (UsersId,SongsId),
	CONSTRAINT UQUserSongsRankingId UNIQUE (UsersId,Ranking)
)

--Table ListHabitsUsers--
--Store each user's music listening habits.
--(device, platform, Spotify Premium status, and listening frequency).
CREATE TABLE ListHabitsUsers(
	ListHabitsUsersId INT IDENTITY(1,1),
	UsersId INT NOT NULL,
	TypeDevice NVARCHAR(30) NOT NULL,
	Plataform NVARCHAR(50) NOT NULL,
	SpotifyPremium BIT,
	Frequency NVARCHAR(20) NOT NULL,
		
	CONSTRAINT PKListHabitsUsers PRIMARY KEY (ListHabitsUsersId),
	CONSTRAINT FKListHabUsers
		FOREIGN KEY (UsersId) REFERENCES Users(UsersId)
)

--*** INSERTING DATA INTO THE TABLES ***--

INSERT INTO Users (FirstName, LastName, Email, BirthDate, OriginCountry, ActualCity, Country, AlyahYear, Gender)
	VALUES ('Hanna','Sapir','iahana@live.com','1992-02-29','Colombia','Harish',DEFAULT,2020,'F'),
		('Tamara','Ungerovich','tamyungerovich@gmail.com','1992-02-01','Brasil','Harish',DEFAULT,2011,'F'),
		('Sarah','Karduner','Sarah.karduner@gmail.com','1987-02-16','Chile','Harish',DEFAULT,2016,'F'),
		('Anat','Shabot','xxxxx@xxx.xx','1985-06-14','Mexico','Harish',DEFAULT,2023,'F'),
		('Malka','Peretz','malka177@gmail.com','1981-09-19','Colombia','Harish',DEFAULT,2018,'F'),
		('Sarah','Peretz','sarahcifuentes@gmail.com','2000-08-02','Colombia','Ranana',DEFAULT,2017,'F'),
		('Sara','Shifman','bautylandharish@gmail.com','1959-09-12','Colombia','Harish',DEFAULT,2023,'F'),
		('Rachel','Cortes','saracorgold@gmail.com','1986-08-14','Colombia','Harish',DEFAULT,2015,'F'),
		('Tzivia','Kusminsky','tziviakusminsky@gmail.com','1983-04-23','Argentina','Harish',DEFAULT,2002,'F'),
		('Tali','Korenvais','Taliyasminkorenvais@gmail.com','1992-12-04','Argentina','Harish',DEFAULT,2022,'F'),
		('Mijal','Sarse','valecherni@gmail.com','1987-05-11','Chile','Harish',DEFAULT,2005,'F'),
		('Andrea','Bejarano','politabeja@hotmail.com','1976-03-11','Colombia','Natanya',DEFAULT,2022,'F'),
		('Shirly','Mork','shirlymorko@gmail.com','1991-04-13','Argentina','Harish',DEFAULT,2013,'F'),
		('Jenifer','Lopez','jeniferli.jl@gmail.com','1992-12-16','Ecuador','Jerusalen',DEFAULT,2008,'F'),
		('Sabrina','Ehrlich','sabriehrl@gmail.com','1979-02-16','Argentina','Harish',DEFAULT,2021,'F'),
		('Arabel','Molas','scylla62@gmail.com','1979-12-16','Mexico','Petach Tikvah',DEFAULT,2004,'F'),
		('Gabriela','Fischer','gfischerpsi@gmail.com','1973-12-30','Argentina','Kfar Saba',DEFAULT,2004,'F'),
		('Daniela','Bortnik','daniela.bortnik@gmail.com','1987-02-07','Chile','Pardes Hanna',DEFAULT,2012,'F'),
		('Vale','Cukier','valcukier@gmail.com','1974-04-30','Argentina','Or Yehuda',DEFAULT,2000,'F'),
		('Yasmin','Leon','yasminbenchuya@hotmail.com','1993-11-30','Argentina','Harish',DEFAULT,2022,'F'),
		('Sofi','Ezban','sofibetech@yahoo.com.mx','1984-09-18','Mexico','Harish',DEFAULT,2013,'F'),
		('Ariana','Turn','ariana.iusim@gmail.com','1981-04-11','Uruguay','Harish',DEFAULT,2010,'F'),
		('Daniela','Yancelson','agaydaniela@gmail.com','1986-02-27','Mexico','Harish',DEFAULT,2013,'F'),
		('Tamara','Buyanovsky','tamiberenstein@gmail.com','1989-12-08','Argentina','Harish',DEFAULT,2022,'F'),
		('Itzjak','Cortes','itzjaqbenyehuda@gmail.com','1982-04-24','Colombia','Harish',DEFAULT,2015,'M'),
		('Judy','Reiff','gusflowerking@gmail.com','1976-10-23','Argentina','Harish',DEFAULT,2003,'F'),
		('Yojanan','Peretz','yyba29@gmail.com','1989-09-14','Venezuela','Bet El',DEFAULT,2018,'M'),
		('Yehuda','Geffen','yehudageffen@hotmail.com','1974-01-18','Colombia','Harish',DEFAULT,2019,'M'),
		('Karin','Efron','kasaru@yahoo.com.ar','1970-02-15','Argentina','Kfar Saba',DEFAULT,2005,'F'),
		('Yehuda','Perez','yehudaperez@hotmail.com','1978-03-03','Colombia','Harish',DEFAULT,2018,'M'),
		('Ruben','Companeetz','rcompaneetz@gmail.com','1963-10-20','Argentina','Maggal',DEFAULT,1984,'M'),
		('Oscar','Bogolavsky','crazy-4you@hotmail.com','1957-03-29','Argentina','Kfar Saba',DEFAULT,1977,'M'),
		('Ariel','Chernizki','achernizki@gmail.com','1982-10-18','Argentina','Harish',DEFAULT,2022,'M'),
		('Sara','Sanchez','penagoslida@gmail.com','1974-05-26','Colombia','Harish',DEFAULT,2017,'F'),
		('Aliza','Molano','mariat_mn@hotmail.com','1968-03-02','Colombia','Harish',DEFAULT,2021,'F'),
		('Rajeli','Cortes','ragelyrimon@hotmail.com','1979-09-10','Colombia','Harish',DEFAULT,2012,'F'),
		('Matityahu','Cortes','mattiaskertesz@gmail.com','1979-08-27','Colombia','Harish',DEFAULT,2014,'M'),
		('Alejandro','Raijer','alejandroraijer@gmail.com','1982-03-24','Argentina','Tel Aviv',DEFAULT,2023,'M'),
		('Eugenia','Kupchik','yardenahazan@gmail.com','1954-09-05','Argentina','Ashdod',DEFAULT,1972,'F'),
		('Dana','Geffen','ginalugo1607@hotmail.com','1980-07-16','Argentina','Maggal',DEFAULT,2021,'F'),
		('Gabriel','Sarce','gsarcep@gmail.com','1988-12-10','Chile','Harish',DEFAULT,2021,'M'),
		('Denise','Dalva','denisedalva@gmail.com','1980-04-10','Uruguay','Jerusalem',DEFAULT,2012,'F'),
		('Javier','Blinder','cblinder.cpa@gmail.com','1964-10-16','Argentina','Kiriat Bialik',DEFAULT,2002,'M'),
		('Hector','Liebembuk','hectorl@bezeqint.net','1960-01-17','Argentina','Kiriat Yam',DEFAULT,1974,'M'),
		('Mauricio','Tzion','elimauro22@gmail.com','1981-11-02','Colombia','Harish',DEFAULT,2011,'M'),
		('Sharon','Stanishevsky','sharon.kopchinsky@gmail.com','1990-02-10','Mexico','Modiin',DEFAULT,2010,'F'),
		('Neomi','Diamante','neomi.diamante13@gmail.com','1964-02-13','Argentina','Kraiot',DEFAULT,2018,'F'),
		('Santiago','Sapir','santi-fox@hotmail.com','1985-11-06','Colombia','Harish',DEFAULT,2020,'M'),
		('Lorena','Tzion','lorenatzion@gmail.com','1982-01-29','Colombia','Harish',DEFAULT,2011,'F'),
		('Hanna','Peretz','hannaperetz@gmail.com','2007-01-09','Colombia','Harish',DEFAULT,2018,'F'),
		('Shirel','Moyal','shirelmoyal@gmail.com','1992-04-10','Argentina','Harish',DEFAULT,2013,'F'),
		('Adolfo','Mowerman','adolfomow@gmail.com','1997-10-17','Colombia','Tel Aviv',DEFAULT,2022,'M'),
		('Binyamin','Cortes','benyicortes1995@gmail.com','1995-09-16','Colombia','Harish',DEFAULT,2015,'M')

INSERT INTO Artist (ArtistName,MusicStyle,LanguageArt,DebutYear,ArtistActive)
	VALUES('Batel Tzabari','Children’s Music',DEFAULT,2010,1),
		('Eli Keshet','Contemporary Jewish/Israeli pop music',DEFAULT,2023,1),
		('Yair Elitzur','Chassidic Rap/Spiritual Hip-Hop/Jewish Contemporary Music',DEFAULT,2003,1),
		('Ishai Ribo','Contemporary Jewish/Israeli pop music',DEFAULT,2007,1),
		('Natan Goshen','Pop/Soft Rock/Electronic',DEFAULT,2010,1),
		('Akiva Turgeman','Pop/Soul/Contemporary Rock',DEFAULT,2017,1),
		('Hanan Ben Ari','Jewish Rock/Pop/R&B/Soul',DEFAULT,2014,1),
		('Ruchama Ben Yosef','Jewish Pop',DEFAULT,2012,1),
		('Shmuel Frednik','Jewish Pop/Electronic/Pop-rock',DEFAULT,2015,1),
		('Eliad Nachum','Pop/Dance/R&B/Rock',DEFAULT,2011,1),
		('Omer Adam','Mizrahi pop/Pop/Dance-pop',DEFAULT,2010,1),
		('Ben Tzur','World music/Mizrahi fusion/Jewish folk',DEFAULT,2005,1),
		('HaTikva 6','Reggae/Dancehall/Pop-rock',DEFAULT,2015,1),
		('Idan Rafael','Pop/Rock',DEFAULT,2011,1),
		('Moshe Peretz','Mizrahi pop/Israeli pop',DEFAULT,2002,1),
		('Eyal Golan','Mizrahi pop/Israeli pop fusion',DEFAULT,1995,1),
		('Cafe Shachor Hazak','Hip hop/Rap',DEFAULT,2013,1),
		('Idan Raichel','World music/pop/folk fusion',DEFAULT,2002,1),
		('Eden Hason','Mizrahi pop/Pop',DEFAULT,2017,1),
		('Asaf Avidan','Indie rock/Folk/Blues','English',2006,1),
		('Meir Banai','Israeli pop/Rock/Folk',DEFAULT,1995,0),
		('Shlomo Artzi','Pop/Rock',DEFAULT,1970,1),
		('David Broza','Pop/Folk',DEFAULT,1978,1),
		('Tomer Yosef','World music/Alternative/Fusion',DEFAULT,1997,1),
		('Amir Benayoun','Mizrahi pop/Pop/World Music',DEFAULT,1999,1),
		('Naomi Shemer','Israeli Folk/Pop',DEFAULT,1956,0),
		('Yuval Dayan','Acoustic Pop/Soft Rock/Israeli Folk-Pop',DEFAULT,2012,1),
		('Itzik Dadya','Jewish Pop/Mizrahi pop',DEFAULT,2010,1),
		('Abraham Fried','Jewish Pop',DEFAULT,1981,1),
		('Arik Einstein','Israeli Rock/Folk/Rock/Classic Pop',DEFAULT,1957,0),
		('Amir Dadon','Israeli Rock/Soft Rock/Contemporary Pop',DEFAULT,2010,1),
		('Ehud Banai','Ethno-Rock/Folk-Rock/Blues/World Music',DEFAULT,1987,1),
		('Benaya Barabi','Israeli pop/Mizrahi Folk/Acoustic Rock',DEFAULT,2017,1),
		('Ariel Zilber','Pop/Rock/Mizrahi',DEFAULT,1970,1),
		('Aaron Razel','Jewish pop/Contemporary Jewish music','Hebrew and English',2001,1),
		('Shuli Rand','Jewish religious music/Pop',DEFAULT,1990,1),
		('Sarit Hadad','Mizrahi pop/Pop Israeli',DEFAULT,1989,1),
		('Ilai Botner','Mizrahi pop/Pop Rock',DEFAULT,2000,1),
		('Dudu Tassa','Rock/Mizrahi/Folk Iraqi fusion',DEFAULT,1998,1),
		('Kobi Oz','Pop/Rock/Mizrahi',DEFAULT,1980,1),
		('Benny Friedman','Contemporary Jewish music/Orthodox pop','Hebrew and English',2008,1),
		('Yaakov Shwekey','Jewish religious pop','Hebrew and English',1990,1),
		('Shlomo Shabat','Mizrahi pop/Pop',DEFAULT,1970,1),
		('Yonatan Razel','Contemporary Jewish music/Orchestral pop',DEFAULT,2000,1),
		('Avraham Tal','Pop/Rock',DEFAULT,2000,1),
		('Project Revivo','Contemporary Jewish music/Pop/Inspirational',DEFAULT,2000,1),
		('The Durbanim','Pop/Rock',DEFAULT,2000,1),
		('Kobi Aflalo','Mizrahi pop/Pop',DEFAULT,2010,1),
		('Hava Alberstein','Israeli Folk/Pop',DEFAULT,1964,1),
		('Avia Sherman','World music/Pop/Jazz',DEFAULT,2000,1),
		('Shlomo Idov','Soft rock/Folk/Melodic pop',DEFAULT,1980,1),
		('Rita','World music/Pop/Ballads',DEFAULT,1980,1),
		('Moshav','Folk rock/Reggae/Pop rock',DEFAULT,1996,1),
		('Ran Danker','Pop/Pop rock/Soft rock',DEFAULT,2000,1),
		('Yoram Gaon','Traditional pop/Israeli classics/Musical theater',DEFAULT,1960,1),
		('Boaz Sharabi','Mizrahi pop/Pop/Ballads',DEFAULT,1970,1),
		('Berry Sakharof','Pop rock/Rock/Alternative',DEFAULT,1980,1),
		('Mashina','Pop rock/Rock/Alternative',DEFAULT,1983,1),
		('Shalom Hanoch','Rock/Hard rock',DEFAULT,1967,1),
		('Mercedes Band','Funk rock/Funk/Alternative rock',DEFAULT,1998,1),
		('Neshot HaShomron im Merav Brenner','Jewish Spiritual Music/Female Vocal Pop/Contemporary Religious Music',DEFAULT,2006,1),
		('Yoni Bloch','Indie Pop/Rock/Alternative',DEFAULT,2004,1)

INSERT INTO Album (AlbumName, NumSongs, ArtistId, ReleaseYearAlbum)
	VALUES ('Ben Tzur',12,12,2024),
		('Bati Lachlom',8,5,2020),
		('HaKadosh Baruch Hu Yoter Gadol MiZe',10,9,2024),
		('Sof Chama Lavo',8,5,2020),
		('Vayehi or',13,14,2025),
		('Shifuim',15,23,2007),
		('Keren Shemesh',14,12,2022),
		('Shetach Afor',11,4,2018),
		('Chayal Shel Ahava',10,16,1998),
		('Ktzat Mize Vektzat Mize',11,27,2014),
		('Shutafim Lanesia',11,14,2024),
		('Brocha Vehatzlocha',10,29,1995),
		('Omer',22,11,2020),
		('Yesh Bi Ahava',10,30,1995),
		('Ane li',11,33,1996),
		('Yesh Kan Yoter Mize',10,7,2023),
		('Album 2',35,20,2021),
		('Am Yisrael Chai',18,16,2024),
		('Geshem',8,22,1987),
		('Anagnorisis',10,21,2020),
		('Davri Iti Yoter',10,5,2015),
		('HaIsha SheIty',10,23,1983),
		('Livchor Nachon',10,31,2018),
		('Nitzacht Iti Hakol',11,25,2004),
		('Ariel Zilber',10,34,1978),
		('Stalbet BaKibbutz',12,40,2022),
		('Yeladim',12,30,1975),
		('Mimaamakim',13,18,2005),
		('Yuval Dayan Debut',11,27,2013),
		('Yigal Bashan 1978',10,55,1978),
		('Ratz O VaShov',12,36,2018),
		('Bli Alayich',14,10,2018),
		('Kmo Sintat',12,37,1999),
		('Laila Tov',10,43,1980),
		('HaIsha SheIti Rep',10,23,1977),
		('Shevet Achim VeAchayot',1,46,2019),
		('Im Eshkachech',12,28,2014),
		('Ani Yehudi',11,29,2023),
		('Leshem Shamayim',13,42,2007),
		('SheMishehu Yaatzor Oti',12,19,2019),
		('Shtar HaTnaim',13,29,1993),
		('Maaminim BNisim',12,42,2001),
		('Your Life in a Song',18,40,2015),
		('Nidat',10,56,1988),
		('Etzli BaNeshama',11,56,1986),
		('Ariel Zilber 1970',10,34,1970),
		('Geula',12,28,2020),
		('Al Taazvi Yadayim',11,6,2021),
		('VeEim Tavoi Elay',10,18,2017),
		('Lishmor Al HaChalom',12,56,2005),
		('Shalom Lach Eretz Nehederet',12,55,1977),
		('Hachi Israeli',11,13,2014),
		('HaAmuta LeHecherat HaOchel',10,58,1990),
		('Beit Meshugaim',10,54,2021),
		('Yihye Beseider',12,17,2015),
		('Hacol Mechaven',10,61,2017),
		('Ulay Ze Ani',15,62,2004),
		('Remazim',10,52,2008),
		('Ir VeBehala',12,39,2015),
		('Esh',11,15,2007),
		('Tamid Ohev Oti',1,3,2024),
		('Rikud HaSvivonim',1,1,2024),
		('Shlemim',1,14,2020),
		('Shiro Shel Abba',1,26,1968),
		('Yom Tov',1,3,2022)

INSERT INTO Songs (SongsName,Duration,ReleaseYearSong,ArtistId,AlbumId)
	VALUES('Tamid Ohev Oti','00:03:40',2024,3,21),
		('Aba','00:03:53',2024,12,1),
		('Nechake Lecha','00:03:27',2020,5,2),
		('Nekudot','00:03:40',2024,9,3),
		('Ani Shayach Leam','00:02:50',2023,4,4),
		('Rikud HaSvivonim','00:02:45',2024,1,62),
		('Giborei Al','00:03:07',2024,13,52),
		('Tetaeru Lachem','00:04:26',2007,22,6),
		('Shlemim','00:03:41',2020,14,63),
		('Keren Shemesh','00:03:44',2022,12,7),
		('HaBoker Yaale','00:03:54',2018,4,8),
		('Yafa Sheli','00:03:47',1998,16,9),
		('Nitzacht Iti Hakol','00:04:11',2004,25,24),
		('Shiro Shel Abba','00:03:10',1968,26,64),
		('Ima','00:03:21',2021,27,29),
		('Akadem Et Panai','00:03:45',2017,4,8),
		('Israeli Complet','00:03:22',2024,13,11),
		('Ten Li Tefila','00:03:00',2022,9,3),
		('Kohavim','00:03:31',2021,28,37),
		('Yerushalayim','00:04:53',1995,29,12),
		('Yom Tov','00:03:16',2022,3,65),
		('Haverot Shelach','00:03:13',2018,11,13),
		('Yesh Bi Ahava','00:04:08',1995,30,14),
		('Shvori Lev','00:03:34',2020,7,16),
		('Shawarma Ve Dmaot','00:03:26',2023,7,16),
		('Rocky','00:03:13',2023,7,16),
		('Shkiot Adumot','00:03:45',2021,19,17),
		('Chutz Mi Kaduregel','00:04:24',2023,7,16),
		('Geshem','00:04:40',1987,22,19),
		('Rock Of Lazarus','00:04:00',2020,21,20),
		('Ma Shenishar','00:03:28',2015,5,21),
		('Sigaliyot','00:04:58',1983,24,22),
		('Tashlich','00:03:26',2017,32,23),
		('Yotze Laor','00:04:04',1996,33,15),
		('Sibat HaSibot','00:03:24',2021,4,8),
		('Brosh','00:03:36',1978,34,25),
		('Stalbet BaKibbutz','00:03:52',2022,40,26),
		('Eretz Yisrael','00:03:45',1975,30,27),
		('Mimaamakim','00:05:00',2005,18,28),
		('Libi','00:03:44',2013,27,29),
		('Ten Li Et HaYom HaZeh','00:03:32',1978,55,30),
		('Da','00:03:41',2018,36,31),
		('Bli Alayich','00:03:47',2018,10,32),
		('Shema Yisrael','00:04:41',1999,37,33),
		('Lashuv HaBaita','00:03:36',2017,4,8),
		('Nitzotzot Shel Havana','00:03:55',2015,4,8),
		('Laila Tov','00:02:40',1980,43,34),
		('Dmaot Shel Malachim','00:04:12',1973,30,27),
		('San Francisco Al HaMayim','00:03:58',1984,21,20),
		('Yihye Tov','00:05:14',1977,23,35),
		('Shevet Achim VeAchayot','00:03:40',2019,46,36),
		('Im Eshkachech Yerushalayim','00:03:45',2014,28,37),
		('HaLev Sheli','00:03:22',2019,4,8),
		('Ani Yehudi','00:03:15',2023,29,38),
		('Anachnu Lo Mefachadim','00:03:42',2007,42,39),
		('Am Yisrael Chai','00:03:24',2023,16,18),
		('Im Tirtzi','00:03:03',2020,11,13),
		('HaYamim Ovrim','00:03:25',2019,19,40),
		('Ir Miklat','00:03:30',1985,32,23),
		('Nagila Hallelujah','00:03:12',1993,29,41),
		('Ani Maamin','00:03:50',2001,42,42),
		('Od Laila','00:03:35',2015,40,43),
		('Latet','00:04:15',1988,56,44),
		('Halavai','00:03:08',1986,56,45),
		('Sigalit','00:03:10',1970,34,46),
		('Yesh Bi Emunah','00:03:40',2020,28,47),
		('Tseadim','00:03:28',2021,6,48),
		('Tavoi Elay','00:03:42',2017,18,49),
		('Im At Adayin Ohevet Oti','00:03:55',2005,56,50),
		('Shalom Lach Eretz Nehederet','00:03:42',1977,55,51),
		('Hachi Israeli','00:03:18',2014,13,52),
		('HaKochavim Dolkim Al Esh Ktatna','00:03:25',1990,58,53),
		('Beit Meshugaim','00:03:12',2021,54,54),
		('Yihye Beseder','00:03:28',2015,17,55),
		('Tagidi Li At','00:03:42',2007,15,60),
		('Mode Ani','00:03:48',2017,61,56),
		('Yeled Shel Aba','00:04:10',2015,39,59),
		('Siba Laazov','00:03:33',2004,62,57),
		('Ani Ve Ata','00:03:25',1971,30,27),
		('Mechake','00:04:15',2008,52,58)

INSERT INTO UsersFavoriteArtist(UsersId,ArtistId,Ranking)
	VALUES (1,1,1),(1,2,2),
		(2,4,1),(2,5,2),
		(3,9,1),(3,4,2),
		(4,33,1),(4,10,2),
		(5,4,1),(5,14,2),
		(6,4,1),(6,15,2),
		(7,16,1),(7,17,2),
		(8,7,1),(8,4,2),
		(9,4,1),(9,13,2),
		(10,9,1),(10,33,2),
		(11,9,1),(11,10,2),
		(12,11,1),(12,16,2),
		(13,13,1),(13,18,2),
		(14,16,1),(14,11,2),
		(15,19,1),(15,11,2),
		(16,20,1),(16,21,2),
		(17,22,1),(17,23,2),
		(18,7,1),(18,22,2),
		(19,24,1),(19,12,2),
		(20,4,1),(20,6,2),
		(21,4,1),(21,7,2),
		(22,34,1),(22,51,2),
		(23,4,1),(23,18,2),
		(24,35,1),(24,4,2),
		(25,36,1),(25,27,2),
		(26,16,1),(26,37,2),
		(27,7,1),(27,11,2),
		(28,11,1),(28,4,2),
		(29,18,1),(29,58,2),
		(30,4,1),(30,13,2),
		(31,38,1),(31,39,2),
		(32,59,1),(32,30,2),
		(33,40,1),(33,41,2),
		(34,42,1),(34,4,2),
		(35,43,1),(35,44,2),
		(36,45,1),(36,7,2),
		(37,11,1),(37,46,2),
		(38,37,1),(38,47,2),
		(39,48,1),(39,49,2),
		(40,4,1),(40,14,2),
		(41,50,1),(41,9,2),
		(42,18,1),(42,6,2),
		(43,55,1),(43,56,2),
		(44,51,1),(44,52,2),
		(45,53,1),(45,13,2),
		(46,57,1),(46,58,2),
		(47,54,1),(47,13,2),
		(48,17,1),(48,11,2),
		(49,7,1),(49,13,2),
		(50,4,1),(50,13,2),
		(51,30,1),(51,7,2),
		(52,60,1),(52,62,2),
		(53,7,1),(53,27,2)

INSERT INTO UsersFavoriteSongs(UsersId,SongsId,Ranking)
	VALUES(1,6,1),(1,1,2),
		(2,2,1),(2,3,2),
		(3,4,1),(3,5,2),
		(4,7,1),(4,8,2),
		(5,9,1),(5,10,2),
		(6,1,1),(6,11,2),
		(7,12,1),(7,13,2),
		(8,14,1),(8,15,2),
		(9,16,1),(9,17,2),
		(10,18,1),(10,19,2),
		(11,20,1),(11,21,2),
		(12,10,1),(12,22,2),
		(13,23,1),(13,24,2),
		(14,25,1),(14,26,2),
		(15,27,1),(15,28,2),
		(16,29,1),(16,30,2),
		(17,31,1),(17,32,2),
		(18,7,1),(18,9,2),
		(19,33,1),(19,34,2),
		(20,11,1),(20,10,2),
		(21,1,1),(21,35,2),
		(22,36,1),(22,37,2),
		(23,38,1),(23,39,2),
		(24,35,1),(24,41,2),
		(25,40,1),(25,42,2),
		(26,43,1),(26,44,2),
		(27,28,1),(27,9,2),
		(28,22,1),(28,45,2),
		(29,39,1),(29,46,2),
		(30,28,1),(30,35,2),
		(31,47,1),(31,48,2),
		(32,49,1),(32,50,2),
		(33,51,1),(33,79,2),
		(34,52,1),(34,53,2),
		(35,56,1),(35,55,2),
		(36,57,1),(36,58,2),
		(37,60,1),(37,61,2),
		(38,44,1),(38,62,2),
		(39,63,1),(39,64,2),
		(40,53,1),(40,9,2),
		(41,65,1),(41,66,2),
		(42,67,1),(42,68,2),
		(43,69,1),(43,70,2),
		(44,79,1),(44,80,2),
		(45,76,1),(45,79,2),
		(46,72,1),(46,59,2),
		(47,73,1),(47,71,2),
		(48,74,1),(48,56,2),
		(49,7,1),(49,10,2),
		(50,35,1),(50,9,2),
		(51,23,1),(51,24,2),
		(52,75,1),(52,78,2),
		(53,77,1),(53,39,2)

INSERT INTO ListHabitsUsers(UsersId,TypeDevice,Plataform,SpotifyPremium,Frequency)
	VALUES (1,'Computer, Smartphone','Spotify, YouTube',0,'Hardly ever'),
		(2,'Smartphone, Radio','Spotify, Radio',1,'Every Day'),
		(3,'Smartphone','Spotify',1,'Several times a week'),
		(4,'Smartphone','Spotify',1,'Several times a week'),
		(5,'Computer, Smartphone','Spotify',0,'Every Day'),
		(6,'Computer, Smartphone','Spotify, YouTube',1,'Every Day'),
		(7,'Computer, Smartphone','YouTube',0,'Several times a week'),
		(8,'Computer, Smartphone','Spotify, YouTube',1,'Every Day'),
		(9,'Computer, Smartphone','Youtube',0,'Several times a week'),
		(10,'Smartphone','Spotify, YouTube',0,'Every Day'),
		(11,'Smartphone','Spotify',1,'Sometimes'),
		(12,'Computer, Smartphone','Spotify',1,'Every Day'),
		(13,'Computer, Smartphone, Radio','Spotify, Youtube, Radio',0,'Every Day'),
		(14,'Smartphone','Spotify',0,'Sometimes'),
		(15,'Smartphone','Spotify',1,'Every Day'),
		(16,'Computer, Smartphone','YouTube, Apple Music',0,'Sometimes'),
		(17,'Smartphone, Radio','Spotify, YouTube, Radio',0,'Sometimes'),
		(18,'Computer, Smartphone','Spotify',1,'Every Day'),
		(19,'Smartphone','Spotify, YouTube',1,'Several times a week'),
		(20,'Smartphone','Youtube',0,'Several times a week'),
		(21,'Smartphone, Radio','Spotify, Youtube, Radio',0,'Several times a week'),
		(22,'Smartphone','Spotify',1,'Every Day'),
		(23,'Computer, Smartphone','Spotify',0,'Every Day'),
		(24,'Smartphone','Spotify',1,'Every Day'),
		(25,'Smartphone','Spotify',1,'Every Day'),
		(26,'Smartphone','Spotify',0,'Hardly ever'),
		(27,'Computer, Smartphone','Spotify, YouTube',1,'Several times a week'),
		(28,'Smartphone','Spotify',0,'Sometimes'),
		(29,'Smartphone, Radio','Spotify, YouTube, Radio',0,'Every Day'),
		(30,'Smartphone','Spotify, YouTube',0,'Sometimes'),
		(31,'Smartphone, Radio','Spotify, YouTube, Radio',1,'Every Day'),
		(32,'Computer, Smartphone','Spotify, YouTube, Apple Music',0,'Every Day'),
		(33,'Smartphone','Spotify, YouTube',0,'Sometimes'),
		(34,'Smartphone','YouTube',0,'Sometimes'),
		(35,'Smartphone','Spotify, YouTube',0,'Several times a week'),
		(36,'Smartphone','Spotify, YouTube',1,'Several times a week'),
		(37,'Smartphone','Spotify',1,'Hardly ever'),
		(38,'Smartphone','YouTube',0,'Sometimes'),
		(39,'Computer, Smartphone, Radio','Spotify, Radio, Other',0,'Every Day'),
		(40,'Smartphone','Spotify',0,'Every Day'),
		(41,'Computer, Smartphone','Spotify',1,'Several times a week'),
		(42,'Smartphone','Spotify, Other',0,'Several times a week'),
		(43,'Computer, Smartphone','Other',1,'Hardly ever'),
		(44,'Computer, Smartphone, Radio','Radio',0,'Several times a week'),
		(45,'Smartphone','YouTube',0,'Hardly ever'),
		(46,'Smartphone, Radio','YouTube, Apple Music, Radio',1,'Several times a week'),
		(47,'Computer, Smartphone','Spotify, YouTube, Radio',1,'Several times a week'),
		(48,'Smartphone','Spotify, YouTube',0,'Sometimes'),
		(49,'Computer, Smartphone, Radio','Spotify, YouTube, Radio',0,'Every Day'),
		(50,'Smartphone','Apple Music',0,'Hardly ever'),
		(51,'Computer, Smartphone, Radio','Spotify, YouTube, Radio',0,'Every Day'),
		(52,'Smartphone','Spotify, YouTube',1,'Sometimes'),
		(53,'Computer, Smartphone','Spotify, YouTube',1,'Several times a week')