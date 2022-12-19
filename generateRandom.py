import random

filename = "random.txt"
outFile = open(filename, 'w')
lower_limit = 4
upper_limit = 7

no_random = 120
for i in range(no_random):
    x = upper_limit - lower_limit
    n = round(random.random()*x + lower_limit, 2)
    outFile.write(str(n) +'\n')
outFile.close()