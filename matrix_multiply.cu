__global__ void matrixMultiplyKernel(Matrix M, Matrix N, Matrix P) {

    int row = blockIdx.x * blockDim.x + threadIdx.x;
    int col = blockIdx.y * blockDim.y + threadIdx.y;

    float pval = 0;
    for (int k = 0; k < MATRIX_SIZE; k++) {
        pval += 
            M.elements[row * MATRIX_SIZE + k] * 
            N.elements[k * MATRIX_SIZE + col];
    }
    P.elements[row * MATRIX_SIZE + col] = pval;
}
