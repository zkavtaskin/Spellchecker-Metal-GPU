
#include <metal_stdlib>
using namespace metal;



kernel void levenshteinDistance(device char *input        [[ buffer(0) ]],
                                device int *inputSize [[ buffer(1) ]],
                                      device char *dict        [[ buffer(2) ]],
                                    device int *dictSize        [[ buffer(3) ]],
                                      device   int *result [[ buffer(4) ]],
                                               uint   index [[ thread_position_in_grid ]],
                                uint totalThreads [[ threads_per_grid ]]) {
    device const char *lhs_chars = input;
    int  lhs_size  = *inputSize;
    device const char *rhs_chars = &dict[dictSize[index]];

    int  rhs_size  = 0;
    if(index < totalThreads-1) {
        rhs_size = dictSize[index+1]-dictSize[index];
    } else {
        rhs_size = dictSize[index]-dictSize[index-1];
    }

    int matrix[45][45] = {{0}};

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
                int a = matrix[i-1][j-1]+1;
                int b = matrix[i][j-1]+1;
                int c = matrix[i-1][j]+1;
                if(a > b) {
                    matrix[i][j] = b;
                } else {
                    matrix[i][j] = a;
                }
                if(matrix[i][j] > c) {
                    matrix[i][j] = c;
                }
            }
        }
    }
    //if (index >= totalThreads) return;
    result[index] = matrix[lhs_size-1][rhs_size-1];
    //result[index] = rhs_size;
    //result[index] = dictSize[index];
    //result[index] = (int)(dict[index]);
    //result[index] = rhs_chars[0];
}




/*


kernel void levenshteinDistance(device char* inputWord, device char* dictionary, device int* distances, uint id [[thread_position_in_grid]]) {
    int inputLength = inputWord[0];
    int dictWordStart = id * (inputLength + 1);
    device int* result = &distances[id * (inputLength + 1) * (inputLength + 1)];
    
    //distances[id] = result[inputLength * (inputLength + 1) + inputLength];
}


 
 for (int i = 0; i <= inputLength; ++i) {
     result[i] = i;
 }
 
 for (int j = 1; j <= inputLength; ++j) {
     for (int i = 1; i <= inputLength; ++i) {
         int cost = (inputWord[i - 1] == dictionary[dictWordStart + j - 1]) ? 0 : 1;
         result[j * (inputLength + 1) + i] = min(result[(j - 1) * (inputLength + 1) + i] + 1,
                                                 min(result[j * (inputLength + 1) + (i - 1)] + 1,
                                                     result[(j - 1) * (inputLength + 1) + (i - 1)] + cost));
     }
 }
 
 
 
 */
