import datetime
from time import sleep
from random import shuffle

def sort_by_date(objs, type):
    if type == "bubble":
        n = len(objs)
        for i in range (n):
            for j in range (n - 1):
                if objs[j].date > objs[j + 1].date:
                    objs[j], objs[j+1] = objs[j+1], objs[j]
        return objs
    elif type == "quick":
        return quick_sort(objs)

def quick_sort(lista):
    if len(lista) <= 1:
        return lista

    pivo = lista[0]
    lista1 = []
    lista2 = []
    for v in lista[1::]:
        if v.date > pivo.date:
            lista2.append(v)
        else:
            lista1.append(v)
    return quick_sort(lista1) + [pivo] + quick_sort(lista2)


class Obj():
    def __init__(self):
        self.date = datetime.datetime.utcnow()

objs = []

for i in range(10):
    objs.append(Obj())
    sleep(0.1)

shuffle(objs)

for v in objs:
    print(v.date)

print()

objs = sort_by_date(objs, "bubble")

for v in objs:
    print(v.date)