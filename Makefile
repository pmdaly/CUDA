NVCC        = nvcc
NVCC_FLAGS  = -03 -I/usr/local/cuda/include
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE         = stencil
OBJ         = main.o support.o

default: $(EXE)

dbg:
	$(NVCC) -c -o main.o main.cu -g -G $(NVCC_FLAGS)
	$(NVCC) -c -o support.o support.cu -g -G $(NVCC_FLAGS)
	$(NVCC) $(OBJ) -o stencil.dbg $(LD_FLAGS)

main.o: main.cu kernel.cu support.h
	$(nvcc) -c -o $@ main.cu $(NVCC_FLAGS)

support.o: support.cu support.h
	$(NVCC) -c -o $@ support.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -rf *.o $(EXE)
