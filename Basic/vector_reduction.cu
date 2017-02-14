__global__ void reductionKernel(float *g_data, int n) {

    __shared__ float partialSum[2*BLOCK_SIZE];

    int tx = threadIdx.x;
    int bx = blockDim.x
    int start = 2 * blockIdx.x * bx;

    // Setting the identity for addition as well as corner turning
    partialSum[tx] = ((start + tx) < n) ? g_data[start + tx] : 0;
    partialSum[bx + tx] = ((start + bx + t) < n) ? g_data[start + bx + tx] : 0;

    for (int stride = bx; stride >= 1; stride >>= 1) {
        __syncthreads();
        if (tx < stride) partialSum[tx] += partialSum[tx + stride];
    }
    if (tx == 0) g_data[blockIdx.x] = partialSum[0];
}
