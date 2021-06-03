import numpy as np

# F,T,I,H,M,S
coden_dict4 = {'AF': 0, 'AT': 1, 'AI': 2, 'AH': 3, 'AM': 4, 'AS': 5, 'CF': 6, 'CT': 7, 'CI': 8, 'CH': 9, 'CM': 10,
               'CS': 11, 'GF': 12, 'GT': 13, 'GI': 14, 'GH': 15, 'GM': 16, 'GS': 17, 'UF': 18, 'UT': 19, 'UI': 20,
               'UH': 21, 'UM': 22, 'US': 23, }


def coden4(useful, ignore):
    vectors = np.zeros((len(useful), 24))
    for i in range(len(useful)):
        vectors[i][coden_dict4[useful[i] + ignore[i]]] = 1
    return vectors.tolist()


def dealwithSequenceAndStructure(protein, indexes):
    count = 0
    dataX = []
    with open('../Datasets/circRNA-RBP/'+ protein + '/positive_sec') as f:
        for line in f:
            if '>' not in line:
                count += 1
                if count == 1:
                    useful = line.strip()
                if count == 2:
                    ignore = line.strip()
                    dataX.append(coden4(useful, ignore))
                    useful = ''
                    ignore = ''
                    count = 0
    with open('../Datasets/circRNA-RBP/' +protein + '/negative_sec') as f:
        for line in f:
            if '>' not in line:
                count += 1
                if count == 1:
                    useful = line.strip()
                if count == 2:
                    ignore = line.strip()
                    dataX.append(coden4(useful, ignore))
                    useful = ''
                    ignore = ''
                    count = 0
    dataX = np.array(dataX)[indexes]
    return dataX