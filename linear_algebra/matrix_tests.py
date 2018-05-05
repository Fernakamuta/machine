from numpy import *
from numpy.linalg import inv
from matplotlib import pyplot

A = [[1,0],[-4,1]]

inv(A)



n = 100

def getOperationsNumber(n):
    i = 0
    ops = 0
    while i <= (n-1):
        ops += (n - i)^2
        i +=1
    return ops

x_axis = range(1,1000)
y_axis = []

for x in x_axis:
    y_axis.append(getOperationsNumber(x))

pyplot.scatter(x_axis, y_axis)
