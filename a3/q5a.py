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
# Now to sort by url which is at index 11 (from inspection).
lines = sorted(lines, key=lambda arr: arr[11])

# Filter out duplicates
def keepUniques(arr):
    enumArr = list(enumerate(arr))
    return [line for i,line in enumArr if line != arr[i-1]]
lines = keepUniques(lines)
lines = [",".join(line) for line in lines]
lines = [line.replace("<", ",") for line in lines]

f = open('stories_orig_no-duplicates-a.csv', 'w')
f.seek(0)
f.truncate()
f.write(header + "\n")
f.write("\n".join(lines))
f.close()
