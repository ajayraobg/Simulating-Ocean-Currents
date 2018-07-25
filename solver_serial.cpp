#include "grid.h"
#include "solver_serial.h"
//

void Solver_serial::simulate_eqn_solver(){
	// Your code here: Variable declaration for timing statistics
	
	int done = 0;
	float diff = 0.0;
	struct timeval start_time, end_time; // Variables to capture timing details
	//Calculate start time for equation solver
	gettimeofday(&start_time, NULL);

	while(!done)
	{ 
		diff = 0.0;
		red_black_ordering(RED, diff);
		red_black_ordering(BLACK, diff);
		diff = diff/float(row*col);
		if (diff < tolerance){ done = 1;}
		else {done = 0;}
	}
	// Calculate end time for equation solver
	gettimeofday(&end_time, NULL);
	// Print the final Timing Statistics
	print_timing_statistics(start_time,end_time);
}

void Solver_serial::red_black_ordering(int value, float &diff)
{
	float temp;
	int i,j,offset=0;
	if (!value)
	{
		for(i=1 ; i<row-1; i++)
		{
			offset = (i+1)%2;
			for(j=1+offset; j<col-1; j=j+2)
			{
				temp = array[i*col + j];
				array[i*col + j] = 0.2 * (array[i*col + j] + array[i*col + (j-1)] + array[i*col + (j+1)] + array[(i-1)*col + j] + array[(i+1)*col + j]);
				diff = diff + fabs(array[i*col + j] - temp);
			}
		}	
	}
	else
	{
		for(i=1; i<row-1; i++)
		{
			offset = i%2;
			for(j = 1+offset; j<col-1; j=j+2)
			{	
				temp = array[i*col + j];
				array[i*col + j] = 0.2 * (array[i*col + j] + array[i*col + (j-1)] + array[i*col + (j+1)] + array[(i-1)*col + j] + array[(i+1)*col + j]);
				diff = diff +  fabs(array[i*col + j] - temp);
			}
		}
	}	
								
}
