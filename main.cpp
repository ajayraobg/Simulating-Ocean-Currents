#include <assert.h>
#include <string.h>
#include <sys/time.h>
#include "grid.h"
#include "main.h"

#ifdef SERIAL
#include "solver_serial.h"
#elif OMP
#include "solver_omp.h"
#elif CUDA
#include "solver_cuda.h"
#endif

//*************************************************************************************************************//
//* 										Main Function													  *//
//*************************************************************************************************************//
int main(int argc, char *argv[]){
	//***** accept the simulator parameters from the command prompt *****//
    if (argv[1] == NULL){
	printf("input format: ");
	printf("./ocean_sim_* <dimension> <tolerance> <file_name> <num_of_threads> \n");
	printf(" where '*' is serial/omp \n");
	exit(0);
    }
	//***** Move the parameters to the local variables *****//
    int num_rows	= atoi(argv[1]);
    int num_cols	= atoi(argv[1]);
	float tolerance	= atof(argv[2]);
    char* fname		= argv[3];
	int num_of_threads = 0;
	if (argv[4]!= NULL)
		num_of_threads = atoi(argv[4]);
	//*******Print out simulator configuration*******//
	print_sim_stats(num_rows, num_cols, tolerance, fname, num_of_threads);
	//*******Instantiate a grid*********//
#ifdef SERIAL
	Grid* grid = new Solver_serial(num_rows, num_cols);
#elif OMP
	Grid* grid = new Solver_omp(num_rows, num_cols, num_of_threads);
#elif CUDA
	Grid* grid = new Solver_cuda(num_rows, num_cols);
#endif
	//*******Check for errors while opening the file****//
	FILE* p_file = fopen (fname,"r");
    if (p_file == 0){	
		printf("Trace file problem\n");
		exit(0);
    }
	//******Initialize the grid array******//
	grid->initialize_grid(p_file);
	//******Set the tolerance value********//
	grid->set_tol_value(tolerance);
	//******Simulate Equation Solver*******//
	grid->simulate_eqn_solver();
	//******Print Final Grid Statistics****//
	grid->print_grid();
	//Delete the grid
	delete (grid);
}
//*************************************************************************************************************//
//* 							Supporting methods for the main function									  *//
//*************************************************************************************************************//
//**	This function is used to print simulator configurations
void print_sim_stats(int grid_row, int grid_column, float tolerance, char *fname, int num_of_threads){
    printf("===== ECE506 Ocean Simulator Configuration =====\n");
    printf("OCEAN GRID DIMENSION:\t\t%d X %d\n", grid_row, grid_column);
	printf("TOLERANCE: \t\t%f\n", tolerance);
    printf("TRACE FILE:\t\t%s\n", fname);
#ifdef SERIAL
    printf("API:\t\t\tNone ( Sequential )\n");
#elif CUDA
    printf("API:\t\t\tCUDA\n");
#elif OMP
    printf("API:\t\t\tOpenMP\n");
	printf("NO OF THREADS: \t\t\t%d\n", num_of_threads);
#endif
}

