-- Please go to line 117 for updates

CREATE DATABASE CSC315FinalFall2020;
USE CSC315FinalFall2020;


CREATE TABLE Genre (
	gid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	gname CHAR(20) NOT NULL
);

INSERT INTO Genre (gname) VALUES ('Rock'), ('Jazz'), ('Country'), ('Classical'), ('Throat Singing');

CREATE TABLE Sub_Genre (
	sgid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	gname CHAR(20) NOT NULL,
	sgname CHAR(20) NOT NULL
);

INSERT INTO Sub_Genre (gname, sgname) VALUES ('Rock', 'Blues'), ('Rock', 'Classic Rock'), ('Rock', 'Power Metal'), ('Rock', 'Thrash Metal'), ('Rock', 'Death Metal'), ('Rock', 'Folk Metal');
INSERT INTO Sub_Genre (gname, sgname) VALUES ('Jazz', 'Swing'), ('Jazz', 'Smooth Jazz'), ('Jazz', 'Bossa Nova'), ('Jazz', 'Ragtime');
INSERT INTO Sub_Genre (gname, sgname) VALUES ('Country', 'Bluegrass'), ('Country', 'Country and Western'), ('Country', 'Jug Band');
INSERT INTO Sub_Genre (gname, sgname) VALUES ('Classical', 'Chamber Music'), ('Classical', 'Opera'), ('Classical', 'Orchestral');
INSERT INTO Sub_Genre (gname, sgname) VALUES ('Throat Singing', 'Khoomii'), ('Throat Singing', 'Kargyraa'), ('Throat Singing', 'Khamryn');

CREATE TABLE Region (
	rid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	rname CHAR(20) NOT NULL
);

INSERT INTO Region (rname) VALUES ('Central Asia'), ('Europe'), ('North Americ'), ('South America');

CREATE TABLE Country (
	rid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	rname CHAR(20) NOT NULL,
	cname CHAR(20) NOT NULL
);

INSERT INTO Country (rname, cname) VALUES ('Central Asia', 'Mongolia'), ('Central Asia', 'Tibet'), ('Central Asia', 'Tuva');
INSERT INTO Country (rname, cname) VALUES ('North Americ', 'Canada'), ('North Americ', 'United States'), ('North Americ', 'Mexico');
INSERT INTO Country (rname, cname) VALUES ('South Americ', 'Brazil');
INSERT INTO Country (rname, cname) VALUES ('Europe', 'Norway'), ('Europe', 'Austria'), ('Europe', 'England'), ('Europe', 'Russia');

CREATE TABLE Bands (
	bid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	bname CHAR(20) NOT NULL
);

INSERT INTO Bands (bname) VALUES ('Seputura'), ('Death'), ('Muddy Waters'), ('Led Zeppelin'), ('The Guess Who');
INSERT INTO Bands (bname) VALUES ('The Hu'), ('Huun-Huur-Tu'), ('Paul Pena'), ('Battuvshin'), ('Sade');
INSERT INTO Bands (bname) VALUES ('Mozart'), ('Tchaikovsky'), ('Twisted Sister'), ('Testament'), ('Tengger Cavalry');


CREATE TABLE Band_Origins (
	boid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	bname CHAR(20) NOT NULL,
	cname CHAR(20) NOT NULL
);

INSERT INTO Band_Origins (bname, cname) VALUES ('Seputura', 'Brazil');
INSERT INTO Band_Origins (bname, cname) VALUES ('Death', 'United States');
INSERT INTO Band_Origins (bname, cname) VALUES ('Muddy Waters', 'United States');
INSERT INTO Band_Origins (bname, cname) VALUES ('Led Zeppelin', 'England');
INSERT INTO Band_Origins (bname, cname) VALUES ('The Guess Who', 'Canada');
INSERT INTO Band_Origins (bname, cname) VALUES ('The Hu', 'Mongolia');
INSERT INTO Band_Origins (bname, cname) VALUES ('Huun-Huur-Tu', 'Tuva');
INSERT INTO Band_Origins (bname, cname) VALUES ('Paul Pena', 'United States');
INSERT INTO Band_Origins (bname, cname) VALUES ('Battuvshin', 'Mongolia');
INSERT INTO Band_Origins (bname, cname) VALUES ('Sade', 'England');
INSERT INTO Band_Origins (bname, cname) VALUES ('Mozart', 'Austria');
INSERT INTO Band_Origins (bname, cname) VALUES ('Tchaikovsky', 'Russia');
INSERT INTO Band_Origins (bname, cname) VALUES ('Twisted Sister', 'United States');
INSERT INTO Band_Origins (bname, cname) VALUES ('Testament', 'United States');
INSERT INTO Band_Origins (bname, cname) VALUES ('Tengger Cavalry', 'United States');


CREATE TABLE Band_Styles (
	boid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	bname CHAR(20) NOT NULL,
	sgname CHAR(20) NOT NULL
);

INSERT INTO Band_Styles (bname, sgname) VALUES ('Seputura', 'Death Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Seputura', 'Thrash Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Death', 'Death Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Muddy Waters', 'Blues');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Led Zeppelin', 'Classic Rock');
INSERT INTO Band_Styles (bname, sgname) VALUES ('The Guess Who', 'Classic Rock');
INSERT INTO Band_Styles (bname, sgname) VALUES ('The Hu', 'Folk Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('The Hu', 'Khoomii');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Huun-Huur-Tu', 'Khoomii');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Huun-Huur-Tu', 'Kargyraa');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Paul Pena', 'Blues');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Paul Pena', 'Kargyraa');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Battuvshin', 'Khoomii');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Battuvshin', 'Smooth Jazz');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Sade', 'Smooth Jazz');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Mozart', 'Opera');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Tchaikovsky', 'Opera');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Tchaikovsky', 'Orchestral');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Twisted Sister', 'Thrash Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Testament', 'Thrash Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Tengger Cavalry', 'Folk Metal');
INSERT INTO Band_Styles (bname, sgname) VALUES ('Tengger Cavalry', 'Khoomii');



-- cleanup
-- DROP TABLE Band_Styles;
-- DROP TABLE Band_Origins;
-- DROP TABLE Bands;
-- DROP TABLE Country;
-- DROP TABLE Region;
-- DROP TABLE Sub_Genre;
-- DROP TABLE Genre;
-- DROP DATABASE CSC315FinalFall2020;

-- updates start here

-- create user api with read-only access to initial tables and rw/update for additional tables
CREATE USER 'api' IDENTIFIED BY 'foobarbaz'; -- hashing with sha2 plugin
GRANT SELECT ON CSC315FinalFall2020.* TO api;


-- user relation with id, name and home country
CREATE TABLE User(
    uid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    home_country VARCHAR(20)
);
GRANT SELECT,INSERT,UPDATE ON CSC315FinalFall2020.User TO api;


-- favorites relation references User and Bands
CREATE TABLE Favorites(
    uid INT,
    FOREIGN KEY (uid) REFERENCES User(uid),
    bid int,
    FOREIGN KEY (bid) REFERENCES Bands(bid)
);
GRANT SELECT,INSERT,UPDATE,DELETE ON CSC315FinalFall2020.Favorites TO api;

-- should there be an error with my python program, all the queries used are listed below, with inline comments as well.

/* BREAK COMMENT IN CASE OF EMERGENCY

-- determine which sub genres come from which regions
SELECT DISTINCT S.sgname, R.rname FROM Band_Styles S JOIN
    (SELECT O.bname, C.rname FROM Band_Origins O JOIN Country C
        WHERE C.cname = O.cname
    ) AS R
    WHERE S.bname = R.bname;

-- bands not in user (1) favorites that are of same subgenre as those in favorites (artist reccomendation)
SELECT bname FROM
(SELECT DISTINCT sgname FROM 
    (SELECT bname FROM Bands WHERE bid IN -- bands in favorites
        (SELECT bid FROM Favorites WHERE uid=1)
    ) as InFavorites
    JOIN
    (SELECT bname,sgname FROM Band_Styles) as Styles -- bands subgenres in favorites
    WHERE InFavorites.bname=Styles.bname) AS SGInFavorites
JOIN
(SELECT DISTINCT NotFavorites.bname,sgname FROM 
    (SELECT bid,bname FROM Bands WHERE bid NOT IN -- bands not in favorites
        (SELECT bid FROM Favorites WHERE uid=1)
    ) as NotFavorites
    JOIN
    (SELECT bname,sgname FROM Band_Styles) as Styles -- bands subgenres not in favorites
    WHERE NotFavorites.bname=Styles.bname) AS SGNotInFavorites
WHERE SGNotInFavorites.sgname=SGInFavorites.sgname; -- sg in favorites = sg not in favorites

-- bands not in user (1) favorites that are of same genre as those in favorites (artist reccomendation)
SELECT DISTINCT GNotInFavorites.bname,GNotInFavorites.gname FROM

    (SELECT DISTINCT InFavorites.bname,BGenre.gname FROM 
        (SELECT bname FROM Bands WHERE bid IN -- bands in favorites
            (SELECT bid FROM Favorites WHERE uid=1)
        ) as InFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM  -- bands genres
            Band_Styles Style JOIN Sub_Genre SGenre 
                where Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE InFavorites.bname=BGenre.bname) AS GInFavorites

    JOIN

    (SELECT DISTINCT NotInFavorites.bname,BGenre.gname FROM 
        (SELECT bname FROM Bands WHERE bid NOT IN -- bands not in favorites
            (SELECT bid FROM Favorites WHERE uid=1)
        ) as NotInFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM  -- bands genres
            Band_Styles Style JOIN Sub_Genre SGenre 
                where Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE NotInFavorites.bname=BGenre.bname) AS GNotInFavorites

WHERE GNotInFavorites.gname=GInFavorites.gname;

-- find other users with same bands as user (1) favorites and list their favorites
SELECT bname FROM Bands JOIN
    (SELECT DISTINCT bid FROM
        (SELECT uid FROM Favorites WHERE bid IN -- users with same favorite
            (SELECT bid FROM Favorites WHERE uid=1)
                AND uid!=1) AS OtherUsers
        JOIN
        (select * from Favorites) AS F
    WHERE F.uid=OtherUsers.uid) AS OtherFavorites
WHERE Bands.bid=OtherFavorites.bid;

-- list other countries user (1) could travel to and hear favorite genres, excluding home
SELECT DISTINCT cname FROM Band_Origins
JOIN
    (SELECT DISTINCT BGenre.* FROM 
        (SELECT bname FROM Bands WHERE bid IN -- bands in favorites
            (SELECT bid FROM Favorites WHERE uid=1)
        ) as InFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM  -- bands genres
            Band_Styles Style JOIN Sub_Genre SGenre 
                where Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE InFavorites.bname=BGenre.bname) AS UserGenres
WHERE Band_Origins.bname=UserGenres.bname AND
cname NOT IN (SELECT home_country FROM User WHERE uid=1);

*/

-- the end