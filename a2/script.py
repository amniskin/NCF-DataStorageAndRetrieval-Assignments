
# This function should get a data file from stdin that has one line of numbers with a comma, then maybe a few lines of charge data (text between commas). That is data on one arrest (so all of those lines will have the same booking number). Each arrest data "group" will be separated by 3 lines of nothing.

import re, sys
from functools import reduce

tmp = [x.replace("\n", "") for x in sys.stdin if x != "\n"]
def listOfLinesPat(pat):
    def retVal(accu, nex):
        if (pat.match(nex)):
            accu[0] = pat.match(nex).group()
            return accu
        else:
            accu[1].append(accu[0] + nex)
            return accu
    return retVal
# This is the pattern for the preproccessed booking number lines
bookingPat = re.compile('^[0-9]+$')
# This should return an array of strings that need to be cleaned up (spaces removed, etc).
tmp = reduce(listOfLinesPat(bookingPat), tmp, ["", []])[1]
#Remove commas and spaces at the end
#tmp = [re.sub(re.compile(",,[\ ]*$"), "", x) for x in tmp]
tmp = [re.sub(re.compile("\ +,"), ",", x) for x in tmp]
tmp = [re.sub(re.compile("\ +\""), "\"", x) for x in tmp]
sys.stdout.write("\n".join(tmp))
