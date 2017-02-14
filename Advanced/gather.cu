// outdependent and outinvariant are just generic computations

__global__ void gatherKernel(int *in, int* out, int num_in, int num_out) {

    int outIdx = blockIdx.x * blockDim.x + threadIdx.x;

    if( outIdx < num_out) {
        for(unsigned int inIdx = 0; inIdx < num_in; ++inIdx) {
            atomicAdd(
                    &(out[outIdx]),
                    outDependent(outInvariant(in[inIdx]), inIdx, outIdx)
                    );
        }
    }

}
