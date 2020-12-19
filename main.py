import mysql.connector
from pprint import pprint
import sys

# connect to db as user 'api'
try:
    db  = mysql.connector.connect(
        host='localhost',
        user='api',
        database='CSC315FinalFall2020'
    )
except:
    print('Error connecting to database.')
    sys.exit(1)

cursor = db.cursor()

# query execution
def execQuery(query, *args):
    try:
        cursor.execute(query % (args))
    except:
        return f'Could not execute query: {query % (args)}'

    return [*cursor]

# determine which subgenres come from which regions
def getSubGenreRegions():
    query = '''SELECT DISTINCT S.sgname, R.rname FROM Band_Styles S JOIN
    (SELECT O.bname, C.rname FROM Band_Origins O JOIN Country C
        WHERE C.cname = O.cname
    ) AS R
    WHERE S.bname = R.bname;'''
    return execQuery(query)


# bands not in user favorites that are of same subgenre as those in favorites (artist reccomendation)
def reccomendBySubGenre(id):
    query = '''SELECT bname FROM
    (SELECT DISTINCT sgname FROM 
        (SELECT bname FROM Bands WHERE bid IN -- bands in favorites
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) as InFavorites
        JOIN
        (SELECT bname,sgname FROM Band_Styles) as Styles -- bands subgenres in favorites
        WHERE InFavorites.bname=Styles.bname) AS SGInFavorites
    JOIN
    (SELECT DISTINCT NotFavorites.bname,sgname FROM 
        (SELECT bid,bname FROM Bands WHERE bid NOT IN -- bands not in favorites
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) as NotFavorites
        JOIN
        (SELECT bname,sgname FROM Band_Styles) as Styles -- bands subgenres not in favorites
        WHERE NotFavorites.bname=Styles.bname) AS SGNotInFavorites
    WHERE SGNotInFavorites.sgname=SGInFavorites.sgname; -- sg in favorites = sg not in favorites'''
    return execQuery(query,id,id)

# bands not in user favorites that are of same genre as those in favorites (artist reccomendation)
def reccomendByGenre(id):
    query = '''SELECT DISTINCT GNotInFavorites.bname FROM

        (SELECT DISTINCT InFavorites.bname,BGenre.gname FROM 
            (SELECT bname FROM Bands WHERE bid IN -- bands in favorites
                (SELECT bid FROM Favorites WHERE uid=%s)
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
                (SELECT bid FROM Favorites WHERE uid=%s)
            ) as NotInFavorites
            JOIN
            (SELECT Style.bname,Style.sgname,SGenre.gname FROM  -- bands genres
                Band_Styles Style JOIN Sub_Genre SGenre 
                    where Style.sgname=SGenre.sgname
                ) AS BGenre
        WHERE NotInFavorites.bname=BGenre.bname) AS GNotInFavorites

    WHERE GNotInFavorites.gname=GInFavorites.gname;'''
    return execQuery(query,id,id)

pprint(reccomendBySubGenre(1))

# db.commit()
db.close()