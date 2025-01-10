import datetime
from time import sleep
from random import shuffle

def sort_by_date(objs):
    n = len(objs)
    for i in range (n):
        for j in range (n - 1):
            if objs[j].date > objs[j + 1].date:
                aux = objs[j]
                objs[j] = objs[j+1]
                objs[j+1] = aux


class Obj():
    def __init__(self):
        self.date = datetime.datetime.utcnow()

objs = []

for i in range(10):
    objs.append(Obj())
    sleep(0.2)

shuffle(objs)

for v in objs:
    print(v.date)

print()

sort_by_date(objs)

for v in objs:
    print(v.date)