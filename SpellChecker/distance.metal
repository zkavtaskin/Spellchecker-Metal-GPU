
#include <metal_stdlib>
using namespace metal;

kernel void levenshteinDistance(device char *input        [[ buffer(0) ]],
                                device int *inputSize [[ buffer(1) ]],
                                      device char *dict        [[ buffer(2) ]],
                                    device int *dictSize        [[ buffer(3) ]],
                                    device   int *result [[ buffer(4) ]],
                                               uint   index [[ thread_position_in_grid ]],
                                uint totalThreads [[ threads_per_grid ]]) {
    //Input word
    device const char *lhs_chars = input;
    int  lhs_size  = *inputSize;
    //One of the words in the dictionary, pointing to the starting index and memory
    device const char *rhs_chars = &dict[dictSize[index]];

    int  rhs_size  = 0;
    //Dictionary word size
    if(index < totalThreads-1) {
        rhs_size = dictSize[index+1]-dictSize[index];
    } else {
        rhs_size = dictSize[index]-dictSize[index-1];
    }

    /*
    This is a bit of a hack, longest word in english is pneumonoultramicroscopicsilicovolcanoconiosis
    that is 45 chars. I need a matrix to perform dynamic programing calculations
    it is not possible to create array dynamically, size needs to be known at build time
    also matrix variable is stored in "register" memory for speed.
    */
    int matrix[45][45] = {{0}};

    //The rest is standard Levenshtein algorithm.
    for (int i = 0; i <= lhs_size; ++i) {
        matrix[i][0] = i;
    }
    
    for (int j = 0; j <= rhs_size; ++j) {
        matrix[0][j] = j;
    }
    
    for (int i = 1; i < lhs_size; i++) {
        for (int j = 1; j < rhs_size; j++) {
            if(lhs_chars[i-1] == rhs_chars[j-1]) {
                matrix[i][j] = matrix[i-1][j-1];
            } else {
                matrix[i][j] = min(matrix[i-1][j-1]+1, matrix[i][j-1]+1);
                matrix[i][j] = min(matrix[i][j], matrix[i-1][j]+1);
            }
        }
    }
    result[index] = matrix[lhs_size-1][rhs_size-1];
}
