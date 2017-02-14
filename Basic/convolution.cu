__global__ void convolutionKernel(Matrix M, Matrix N, Matrix P) {

    __shared__ float N_s[BLOCK_SIZE][BLOCK_SIZE];

    int bx = blockIdx.x;  int by = blockIdx.y;
    int tx = threadIdx.x; int ty = threadIdx.y;

    int n = KERNEL_SIZE / 2;

    int row_o = by * TILE_SIZE + ty; int row_i = row_o - n;
    int col_o = bx * TILE_SIZE + tx; int col_i = col_o - n;

    float output = 0.0;

    if ((row_i >= 0) && (row_i < N.height) &&
        (col_i >= 0) && (col_i < N.width) ) {
        N_s[ty][tx] = N.elements[row_i * N.width + col_i];
    } else {
        N_s[ty][tx] = 0.0;
    }

    __syncthreads();

    if ((ty < TILE_SIZE) && (tx < TILE_SIZE)) {
        for (int i = 0; i < KERNEL_SIZE; i++) {
            for (int j = 0; j < KERNEL_SIZE; j++) {
                output += M_c[i][j] * N_s[i+ty][j+tx];
            }
            __syncthreads();
        }
        if ((row_o < P.height) && (col_o < P.width) ) {
            P.elements[row_o * P.width + col_o] = output;
        }
    }

}
