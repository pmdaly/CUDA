// intermediate is just a generic computation, can be anything

__global void scatterKernel(int *in, int *out, int num_in, int num_out) {

    unsigned int inIdx = blockIdx.x * blockDim.x + threadIdx.x;

    if( inIdx < num_in) {
        unsigned int intermediate = outInvariant(in[inIdx]);
        for( unsigned int outIdx = 0; outIdx < num_out; ++outIdx) {
            atomicAdd(
                    &(out[outIdx]),
                    outDependent(intermediate, inIdx, outIdx)
                    );
        }
    }

}
