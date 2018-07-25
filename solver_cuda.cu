#include "grid.h"
#include "solver_cuda.h"
#include <cuda.h>
#include <cuda_runtime.h>

static void fail(char const *message);
__global__ void red_black_ordering(float *d_grid, int grid_row, int value, float *d_diff1);

void Solver_cuda::simulate_eqn_solver(){
	int done = 0;
	float diff = 0.0;
	struct timeval start_time, end_time; // Variables to capture timing details
	int size = ( row * col * sizeof(float) );
	cudaError_t err = cudaSuccess;

	// The code below is optional.  We are going to create a diff array instead of
	// accumulating the diffs in a variable.  If we didn't do that, we would need to
	// synchronize threads as they summed the diffs, and that's harder for beginners.
	float *diff1 = NULL;
	diff1 = (float*) malloc (size);
	for (int i= 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			diff1[i * col + j] = 0.0;
		}
	}

	int threads_per_block = 256;
	int blocks_per_grid = (int)( ( row*col + threads_per_block - 1) / threads_per_block);		
	float *d_grid = NULL;
	err = cudaMalloc((void **)&d_grid, size);
	if(err != cudaSuccess) cout<<"Failed to allocate grid memory"<<endl;
	err = cudaMemcpy(d_grid,array,size,cudaMemcpyHostToDevice);
	if(err != cudaSuccess) cout<<"Failed to copy grid to device"<<endl;
	float *d_diff1 = NULL;
	err = cudaMalloc((void **)&d_diff1, size);
	if(err != cudaSuccess) cout<<"Failed to allocate diff memory"<<endl;
	err = cudaMemcpy(d_diff1,diff1,size,cudaMemcpyHostToDevice);
	if(err != cudaSuccess) cout<<"Failed to copy diff to device"<<endl;

	// Calculate start time for equation solver
	gettimeofday(&start_time, NULL);
	
	while (!done){
		diff = 0.0;
		red_black_ordering <<< blocks_per_grid, threads_per_block >>> (d_grid, row, RED, d_diff1);
		cudaDeviceSynchronize();		
		red_black_ordering <<< blocks_per_grid, threads_per_block >>> (d_grid, row, BLACK, d_diff1);
		cudaDeviceSynchronize();
		err = cudaMemcpy(diff1,d_diff1,size,cudaMemcpyDeviceToHost);
		if(err != cudaSuccess) cout<<"Failed to copy diff from device"<<endl;
		for (int i= 0; i < row; i++) 
		{
			for (int j = 0; j < col; j++) 
			{
				diff = diff + diff1[i * col + j];
			}
		}
		diff = diff/float (row*col);
		if(diff<tolerance) {done = 1;}
		else {done = 0;}		
	}

	gettimeofday(&end_time, NULL);
	// Print the final Timing Statistics
	print_timing_statistics(start_time,end_time);
	
	err = cudaMemcpy(array,d_grid,size,cudaMemcpyDeviceToHost);
	if(err != cudaSuccess) cout<<"Failed to copy grid from device"<<endl;
	err = cudaFree(d_diff1);
	if(err != cudaSuccess) cout<<"Failed to free diff memory"<<endl;
	err = cudaFree(d_grid);
	if(err != cudaSuccess) cout<<"Failed to free grid memory"<<endl;
	free(diff1);
	cudaDeviceReset();
}
//
//
__global__ void red_black_ordering(float *d_grid, int grid_row, int value, float *d_diff1)

{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	float temp = 0.0;
	int i;
	int row = index/grid_row;
	int col = index - (row * grid_row);
	int flag = 0;


	if(index<grid_row*grid_row)
	{
		if(!((row==0)|| (row==grid_row-1) || (col==0) || (col==grid_row-1))) 
		{
			if(!value)
			{
				if(((row%2==1) && (col%2==1)) || ((row%2==0) && (col%2==0)))
				{
					temp = d_grid[row*grid_row + col];
					d_grid[row*grid_row + col] = 0.2 * (d_grid[row*grid_row + col] + d_grid[row*grid_row + col +1] + d_grid[row*grid_row + col - 1] + d_grid[(row-1)*grid_row + col] + d_grid[(row+1)*grid_row + col]);
					d_diff1[index] = fabs(temp - d_grid[row*grid_row + col]);
				}				
			}
			else
			{
				if(((row%2==1) && (col%2==0)) || ((row%2==0) && (col%2==1)))
				{
					temp = d_grid[row*grid_row + col];
					d_grid[row*grid_row + col] = 0.2 * (d_grid[row*grid_row + col] + d_grid[row*grid_row + col +1] + d_grid[row*grid_row + col - 1] + d_grid[(row-1)*grid_row + col] + d_grid[(row+1)*grid_row + col]);
					d_diff1[index] = fabs(temp - d_grid[row*grid_row + col]);
				}
			}
		}
	}
	

}

