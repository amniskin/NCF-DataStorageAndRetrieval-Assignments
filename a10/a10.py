from pymongo import MongoClient

mg = MongoClient()

db = mg.cities.cities
tmp = mg.database_names()
print(tmp)
elem = db.find_one({"name": '/new/ig'})
print(elem)

print("HEY")
