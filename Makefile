GCC = g++
NVCC = /usr/local/cuda/bin/nvcc
OPT = -O0
WARN = -Wall
ERR = -Werror
SER_VAR	= -D SERIAL
NVC_VAR = -D CUDA
OMP_VAR	= -D OMP 
OMP_OPT = -fopenmp

SER_DIR = SERIAL
CUD_DIR = CUDA
OMP_DIR = OMP

OMPFLAGS = $(OPT) $(WARN) $(ERR) $(OMP_OPT) $(OMP_VAR)
SERFLAGS = $(OPT) $(WARN) $(ERR) $(SER_VAR)
NV1FLGS = $(OPT) $(WARN) $(ERR) $(NVC_VAR)
NVFLAGS	= -arch=sm_21 -g -G -O0
NVCFLGS	= -L/usr/local/cuda/lib64 -lcuda


SER_SRC  = main.cc grid.cpp solver_serial.cpp
SER_OBJ	= $(addprefix $(SER_DIR)/, main.o grid.o solver_serial.o)

OMP_SRC = main.cpp grid.cpp solver_omp.cpp
OMP_OBJ	= $(addprefix $(OMP_DIR)/, main.o grid.o solver_omp.o)

NVC_SRC = main.cpp grid.cpp
NVC_OBJ = $(addprefix $(CUD_DIR)/,main.o grid.o)

NV2_SRC = solver_cuda.cu
NV2_OBJ = $(addprefix $(CUD_DIR)/, solver_cuda.o)

all: serial omp cuda
	@echo "Compilation Done ---> nothing else to make :) "

serial: CFLAGS = $(SERFLAGS)
serial: serial_temp

omp: CFLAGS = $(OMPFLAGS)
omp: omp_temp

cuda: CFLAGS = $(NV1FLGS)
      CC = $(GCC)
cuda: cuda_temp

serial_temp: $(SER_OBJ)
	$(GCC) $(SERFLAGS) -o ocean_sim_serial $(SER_OBJ) -lm
	@echo "----------------------------------------------------------"
	@echo "---------FA2017-506 OCEAN SIMULATOR SERIAL VERSION--------"
	@echo "----------------------------------------------------------"
	
omp_temp: $(OMP_OBJ)
	$(GCC) $(OMPFLAGS) -o ocean_sim_omp $(OMP_OBJ) -lm
	@echo "----------------------------------------------------------"
	@echo "-----------FA2017-506 OCEAN SIMULATOR OMP VERSION---------"
	@echo "----------------------------------------------------------"

cuda_temp: $(NVC_OBJ)
	$(NVCC) $(NVFLAGS) -o $(NV2_OBJ) -c solver_cuda.cu
	$(NVCC) $(NVFLAGS) -o ocean_sim_cuda $(NVC_OBJ) $(NV2_OBJ)
	@echo "----------------------------------------------------------"
	@echo "-----------FA2017-506 OCEAN SIMULATOR CUDA VERSION--------"
	@echo "------------------------	----------------------------------"

$(SER_DIR)/%.o: %.cpp
	@mkdir -p $(SER_DIR)
	$(CC) $(CFLAGS)  -c $< -o $@
	
$(OMP_DIR)/%.o: %.cpp
	@mkdir -p $(OMP_DIR)
	$(CC) $(CFLAGS)  -c $< -o $@

$(CUD_DIR)/%.o: %.cpp
	@mkdir -p $(CUD_DIR)
	$(CC) $(CFLAGS)  -c $< -o $@

$(CUD_DIR)/%.o: %.cu
	$(NVCC) $(NVFLAGS) -c $*.cu

clean:
	rm -rf SERIAL OMP CUDA
	rm -f *.o ocean_sim_*
