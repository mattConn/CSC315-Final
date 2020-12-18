USE CSC315FinalFall2020;

-- create user api with read-only access to initial tables and rw/update for additional tables
CREATE USER api;
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
GRANT SELECT,INSERT,UPDATE ON CSC315FinalFall2020.Favorites TO api;

-- determine which sub genres come from which regions
SELECT DISTINCT S.sgname, R.rname FROM Band_Styles S JOIN
    (SELECT O.bname, C.rname FROM Band_Origins O JOIN Country C
        WHERE C.cname = O.cname
    ) AS R
    WHERE S.bname = R.bname;

-- getting bands not in user (1) favorites
SELECT * FROM Bands WHERE bid NOT IN (SELECT bid FROM Favorites WHERE uid=1);