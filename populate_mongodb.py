#!/usr/bin/python
from datetime import datetime
from pymongo import MongoClient
client = MongoClient()
db = client.sparktest
print "Populate mongodb"
db.btest.insert_many([{

    "address": {
        "street": "2 Avenue "+str(i),
        "zipcode": "10075 "+str(i),
        "building": "1480 "+str(i),
        "coord": [-73.9557413, 40.7720266]
    },
    "borough": "Manhattan "+str(i),
    "cuisine": "Italian "+str(i),
    "grades": [
        {
            "date": datetime.strptime("2014-10-01", "%Y-%m-%d"),
            "grade": "A "+str(i),
            "score": 11+i
        },
        {
            "date": datetime.strptime("2014-01-16", "%Y-%m-%d"),
            "grade": "B",
            "score": 17+i
        }
    ],
    "name": "Vella "+str(i),
    "btest_id": "41704620"+str(i)

} for i in xrange(300)]).inserted_ids
print db.btest.count()
