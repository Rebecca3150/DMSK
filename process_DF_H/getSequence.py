import numpy as np

coden_dict = {'GCU': 0, 'GCC': 0, 'GCA': 0, 'GCG': 0,  # alanine<A>
              'UGU': 1, 'UGC': 1,  # systeine<C>
              'GAU': 2, 'GAC': 2,  # aspartic acid<D>
              'GAA': 3, 'GAG': 3,  # glutamic acid<E>
              'UUU': 4, 'UUC': 4,  # phenylanaline<F>
              'GGU': 5, 'GGC': 5, 'GGA': 5, 'GGG': 5,  # glycine<G>
              'CAU': 6, 'CAC': 6,  # histidine<H>
              'AUU': 7, 'AUC': 7, 'AUA': 7,  # isoleucine<I>
              'AAA': 8, 'AAG': 8,  # lycine<K>
              'UUA': 9, 'UUG': 9, 'CUU': 9, 'CUC': 9, 'CUA': 9, 'CUG': 9,  # leucine<L>
              'AUG': 10,  # methionine<M>
              'AAU': 11, 'AAC': 11,  # asparagine<N>
              'CCU': 12, 'CCC': 12, 'CCA': 12, 'CCG': 12,  # proline<P>
              'CAA': 13, 'CAG': 13,  # glutamine<Q>
              'CGU': 14, 'CGC': 14, 'CGA': 14, 'CGG': 14, 'AGA': 14, 'AGG': 14,  # arginine<R>
              'UCU': 15, 'UCC': 15, 'UCA': 15, 'UCG': 15, 'AGU': 15, 'AGC': 15,  # serine<S>
              'ACU': 16, 'ACC': 16, 'ACA': 16, 'ACG': 16,  # threonine<T>
              'GUU': 17, 'GUC': 17, 'GUA': 17, 'GUG': 17,  # valine<V>
              'UGG': 18,  # tryptophan<W>
              'UAU': 19, 'UAC': 19,  # tyrosine(Y)
              'UAA': 20, 'UAG': 20, 'UGA': 20,  # STOP code
              }
# the amino acid code adapting 21-dimensional vector (5 amino acid and 1 STOP code)


def coden(seq):
    vectors = np.zeros((len(seq) - 2, 21))
    for i in range(len(seq) - 2):
        vectors[i][coden_dict[seq[i:i + 3].replace('T', 'U')]] = 1
    return vectors.tolist()

#
def dealwithSequence(protein):
    dataX = []
    dataY = []
    with open('../Datasets/circRNA-RBP/' + protein + '/positive') as f:
        for line in f:
            if '>' not in line:
                dataX.append(coden(line.strip()))
                dataY.append([0, 1])
    with open('../Datasets/circRNA-RBP/' +  protein + '/negative') as f:
        for line in f:
            if '>' not in line:
                dataX.append(coden(line.strip()))
                dataY.append([1, 0])
    indexes = np.random.choice(len(dataY), len(dataY), replace=False)
    dataX = np.array(dataX)[indexes]
    dataY = np.array(dataY)[indexes]
    return dataX, dataY, indexes

