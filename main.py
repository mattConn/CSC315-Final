# CSC 315
# Fall 2020
# Final Project
# Matthew Connelly

import mysql.connector
from pprint import pprint
import sys

# connect to db as user 'api'
try:
    db  = mysql.connector.connect(
        host='localhost',
        user='api',
        password='foobarbaz', 
        database='CSC315FinalFall2020'
    )
except mysql.connector.Error as err:
    print('Error connecting to database.')
    print(err)
    sys.exit(1)

cursor = db.cursor()

# simple error maker
def getError(error, result):
    return (error, result) # like golang returns ( err,y := f(x) )

# query execution
def execQuery(query, *args):
    try:
        cursor.execute(query % (args))
    except mysql.connector.Error as err:
        return getError(True, err)

    return getError(False, [*cursor])

# Query Functions
# ===============

# determine which subgenres come from which regions
# -------------------------------------------------
def getSubGenreRegions():
    query = '''SELECT DISTINCT S.sgname, R.rname FROM Band_Styles S JOIN
    (SELECT O.bname, C.rname FROM Band_Origins O JOIN Country C
        WHERE C.cname = O.cname
    ) AS R
    WHERE S.bname = R.bname;'''
    return execQuery(query)


# get bands not in user favorites that are of same subgenre as those in favorites
# -------------------------------------------------------------------------------
def recommendBandsBySubGenre(userID):
    query = '''SELECT bname FROM
    (SELECT DISTINCT sgname FROM 
        (SELECT bname FROM Bands WHERE bid IN
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) as InFavorites
        JOIN
        (SELECT bname,sgname FROM Band_Styles) as Styles
        WHERE InFavorites.bname=Styles.bname) AS SGInFavorites
    JOIN
    (SELECT DISTINCT NotFavorites.bname,sgname FROM 
        (SELECT bid,bname FROM Bands WHERE bid NOT IN
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) as NotFavorites
        JOIN
        (SELECT bname,sgname FROM Band_Styles) as Styles
        WHERE NotFavorites.bname=Styles.bname) AS SGNotInFavorites
    WHERE SGNotInFavorites.sgname=SGInFavorites.sgname;'''
    return execQuery(query,userID, userID)

# get bands not in user favorites that are of same genre as those in favorites
# ----------------------------------------------------------------------------
def recommendBandsByGenre(userID):
    query = '''SELECT DISTINCT GNotInFavorites.bname FROM

        (SELECT DISTINCT InFavorites.bname,BGenre.gname FROM 
            (SELECT bname FROM Bands WHERE bid IN
                (SELECT bid FROM Favorites WHERE uid=%s)
            ) as InFavorites
            JOIN
            (SELECT Style.bname,Style.sgname,SGenre.gname FROM
                Band_Styles Style JOIN Sub_Genre SGenre 
                    where Style.sgname=SGenre.sgname
                ) AS BGenre
        WHERE InFavorites.bname=BGenre.bname) AS GInFavorites

        JOIN

        (SELECT DISTINCT NotInFavorites.bname,BGenre.gname FROM 
            (SELECT bname FROM Bands WHERE bid NOT IN
                (SELECT bid FROM Favorites WHERE uid=%s)
            ) as NotInFavorites
            JOIN
            (SELECT Style.bname,Style.sgname,SGenre.gname FROM
                Band_Styles Style JOIN Sub_Genre SGenre 
                    where Style.sgname=SGenre.sgname
                ) AS BGenre
        WHERE NotInFavorites.bname=BGenre.bname) AS GNotInFavorites

    WHERE GNotInFavorites.gname=GInFavorites.gname;'''
    return execQuery(query,userID, userID)

# find other users with same favorites as user, and list their favorites
# ----------------------------------------------------------------------
def recommendBandsByOtherUsers(userID):
    query = '''SELECT bname FROM Bands JOIN
        (SELECT DISTINCT bid FROM
            (SELECT uid FROM Favorites WHERE bid IN
                (SELECT bid FROM Favorites WHERE uid=%s)
                    AND uid!=%s) AS OtherUsers
            JOIN
            (select * from Favorites) AS F
        WHERE F.uid=OtherUsers.uid) AS OtherFavorites
    WHERE Bands.bid=OtherFavorites.bid;'''
    return execQuery(query, userID, userID)


# list other countries user could travel to and hear favorite genres, excluding home country
# ------------------------------------------------------------------------------------------
def recommendCountriesByGenre(userID):
    query = '''SELECT DISTINCT cname FROM Band_Origins
    JOIN
        (SELECT DISTINCT BGenre.* FROM 
            (SELECT bname FROM Bands WHERE bid IN
                (SELECT bid FROM Favorites WHERE uid=%s)
            ) as InFavorites
            JOIN
            (SELECT Style.bname,Style.sgname,SGenre.gname FROM
                Band_Styles Style JOIN Sub_Genre SGenre 
                    where Style.sgname=SGenre.sgname
                ) AS BGenre
        WHERE InFavorites.bname=BGenre.bname) AS UserGenres
    WHERE Band_Origins.bname=UserGenres.bname AND
    cname NOT IN (SELECT home_country FROM User WHERE uid=%s);'''
    return execQuery(query, userID, userID)

# Modifying Functions
# ===================

# insert new users
# ----------------
def addUser(userID, name, country):
    query = 'INSERT INTO User VALUES (%s, \'%s\', \'%s\');'
    return execQuery(query, userID, name, country)

# insert favorite band by band name
# ---------------------------------
def addFavorite(userID,bandName):
    # check for band existence
    _, result = execQuery('SELECT bname FROM Bands WHERE bname=\'%s\';',bandName)
    bandExists = len(result) > 0

    if not bandExists:
        return getError(True, f'Error: {bandName} does not exist.')

    # get Band ID (bid)
    _, bandID = execQuery('SELECT bid FROM Bands WHERE bname=\'%s\';',bandName)
    bandID = bandID[0][0] # get int

    query = 'INSERT INTO Favorites values (%s, %s);'
    return execQuery(query, userID, bandID)

# delete favorite band by band name
# ---------------------------------
def removeFavorite(userID,bandName):
    # check for band existence
    _, result = execQuery('SELECT bname FROM Bands WHERE bname=\'%s\';',bandName)
    bandExists = len(result) > 0

    if not bandExists:
        return getError(True, f'Error: {bandName} does not exist.')

    # get Band ID (bid)
    _, bandID = execQuery('SELECT bid FROM Bands WHERE bname=\'%s\';',bandName)
    bandID = bandID[0][0]

    query = 'DELETE FROM Favorites WHERE uid=%s AND bid=%s;'
    return execQuery(query, userID, bandID)

# inserting users and favorites statically
# ========================================

# inserting 3 users
addUser(1,'Henry Finnegan', 'United States')
addUser(2,'Rickie Fritz', 'Mongolia')
addUser(3,'Claire Nava', 'Norway')

# show results
pprint(execQuery('SELECT * FROM User;'))

# inserting 4 favorites for each user
addFavorite(1, 'Led Zeppelin')
addFavorite(1, 'Testament')
addFavorite(1, 'The Hu')
addFavorite(1, 'The Guess Who')

addFavorite(2, 'Death')
addFavorite(2, 'Paul Pena')
addFavorite(2, 'Sade')
addFavorite(2, 'Testament')

addFavorite(3, 'Death')
addFavorite(3, 'Seputura')
addFavorite(3, 'The Hu')
addFavorite(3, 'Testament')

# show results
pprint(execQuery('SELECT * FROM Favorites;'))

# uncomment for db changes to persist
# db.commit()

# db.close()