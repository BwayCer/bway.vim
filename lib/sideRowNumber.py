
bway_sideRowNumber_enableInfo = {}
def bway_sideRowNumber_isEnable(bufId):
    if bway_sideRowNumber_enableInfo.get(bufId, True) == True:
        bway_sideRowNumber_enableInfo[bufId] = False
        return 0
    else:
        bway_sideRowNumber_enableInfo[bufId] = True
        return 1

