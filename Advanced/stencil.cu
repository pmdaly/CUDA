#define TILE_SIZE 32

__device__ unsigned int Idx3D(int nx, int ny, int i, int j, int k) {
    return k*nx*ny + j*nx + i;
}

__global__ void stencilKernel(int *A0, int *Anext, int nx, int ny, int nz) {

    __shared__ float ds_A[TILE_SIZE][TILE_SIZE];
    
    unsigned int tx = threadIdx.x;          unsigned int ty = threadIdx.y;
    unsigned int dx = blockDim.x;           unsigned int dy = blockDim.y;
    unsigned int  i = blockIdx.x * dx + tx; unsigned int  j = blcokIdx.y * dy + ty;

    if((i < nx) && (j < ny)) {

        float bottom = A0[Idx3D(nx, ny, i, j, 0)];
        float center = A0[Idx3D(nx, ny, i, j, 1)];
        float top    = A0[Idx3D(nx, ny, i, j, 2)];

        for(int k = 1; k < nz-1; k++) {
            ds_A[ty][tx] = cewnter;
            __syncthreads();
            Anext[Idx3D(nx, ny, i, j, k)] = bottom + top - 6 * center + 
                ((tx>0)    ? ds_A[ty][tx-1] : (i==0)    ? 0 : A0[Idx3d(nx,ny,i-1,j,k)]) +
                ((tx<dx-1) ? ds_A[ty][tx+1] : (i==nx-1) ? 0 : A0[Idx3d(nx,ny,i+1,j,k)]) +
                ((ty>0)    ? ds_A[ty-1][tx] : (i==0)    ? 0 : A0[Idx3d(nx,ny,i,j-1,k)]) +
                ((ty<dy-1) ? ds_A[ty+1][tx] : (i==ny-1) ? 0 : A0[Idx3d(nx,ny,i,j+1,k)]);
            bottom = center;
            center = top;
            __syncthreads();
            if(k + 2 < nz) top = A0[Idx3D(nx, ny, i, j, k+2)];
        }
    }

}
