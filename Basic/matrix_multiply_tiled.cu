__global__ void matrixMultiplyTiledKernel(Matrix M, Matrix N, Matrix P) {

    __shared__ float M_s[TILE_WIDTH][TILE_WIDTH];
    __shared__ float N_s[TILE_WIDTH][TILE_WIDTH];

    int bx = blockIdx.x;  int by = blockIdx.y;
    int tx = threadIdx.x; int ty = threadIdx.y;

    int row = by * TILE_WIDTH + ty;
    int col = bx * TILE_WIDTH + tx;

    float pval = 0;
    for (int tile_idx = 0; tile_idx < ceil((float)M.width / TILE_WIDTH);
            ++tile_idx) {

        // Validate indices are w/in M
        if (row < M.height && tile_idx * TILE_WIDTH + tx < M.width) {
            M_s[ty][tx] = 
                M.elements[row * M.width + tile_idx * TILE_WIDTH + tx];
        } else {
            M_s[ty][tx] = 0.0;
        }

        // Validate indices are w/in N
        if (col < N.width && tile_idx * TILE_WIDTH + ty < N.height) {
            N_s[ty][tx] = 
                N.elements[(tile_idx * TILE_WIDTH + ty) * N.width + col];
        } else {
            N_s[ty][tx] = 0.0;
        }

        __syncthreads();

        for (int k = 0; k < TILE_WIDTH; ++k) pval += M_s[ty][k] * N_s[k][tx];

        __syncthreads();

    }

    if (row < M.height && col < N.width) {
        P.elements[row * N.width + col] = pval;
    }

}
