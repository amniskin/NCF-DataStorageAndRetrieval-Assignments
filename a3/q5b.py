# Read the file into an array of lines:
lines = [line.rstrip('\r\n') for line in open('Fanfiction/stories_orig.csv')]
# remove the header and save it for later
header = lines.pop(0)

# Split each line on quotes (so that the odd ones will be the ones in quotes and we can replace any commas within them by another character such as #).
lines = [line.split('"') for line in lines]

# Now, let's replace the commas in every odd element by an unused character. It turns out that this file does not have any less than symbols, so we'll use those.
def replaceOdds(arr, a, b):
    #python doesn't come with a native copy function, so the line below is a way of copying the list
    retVal = arr[:]
    for i in range(len(retVal)):
        if (i % 2 == 1):
            retVal[i] = retVal[i].replace(a, b).strip()
        else:
            retVal[i] = retVal[i].strip()
    return retVal
lines = [replaceOdds(line, ",", "<") for line in lines]
lines = ["\"".join(line) for line in lines]
lines = [line.split(",") for line in lines]

modulus = 2**20 - 1

hashedValues = set()
def hashFunc(line):
    h = int('0' + line[15].replace("-","") + line[16]) % modulus
    hashedValues.add(h)
    return h

hashTable = [[] for _ in range(modulus)]

# pardon my side effects
def addLineToTable(line, fn, hashTab):
    ind = fn(line)
    hashTab[ind].append(line)

for line in lines:
    addLineToTable(line, hashFunc, hashTable)

retVal = []

for i in hashedValues:
    arr = hashTable[i]
    for j in range(len(arr)):
        if (arr[j] not in arr[:j]):
            retVal.append(arr[j])

retVal = [",".join(line) for line in retVal]
retVal = [line.replace("<", ",") for line in retVal]

f = open('stories_orig_no-duplicates-b.csv', 'w')
f.seek(0)
f.truncate()
f.write(header + "\n")
f.write("\n".join(retVal))
f.close()
