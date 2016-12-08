import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pymongo import MongoClient
from pprint import pprint

db = MongoClient()
db = db.fall_db_final

business = db.academic_business

tmp = business.find({'attributes.Wi-Fi': "free", 'categories': {'$in': ['Bars']}}, projection={'attributes.Wi-Fi': 1, 'city': 1, 'categories': 1, 'name': 1, 'stars': 1})

tmp_list = []
max_ind = min(tmp.count(), 5)
for i in range(max_ind):
    tmp_list.append(tmp[i])
    pprint(tmp_list[i])

# There are four levels -- Unknown : null
#                   no, paid, and free


