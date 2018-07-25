#include "grid.h"

Grid::Grid(int r, int c){
	int i,j;
	row = r; 
	col = c;
	int size = r*c;
	array = new float [size];
	for (i= 0; i< row; i++){
		for (j=0; j< col; j++){
			array[i * col + j] = 0.0;
		}
	}
}
//
Grid::~Grid()
{
	delete(array);
}
//
void Grid::initialize_grid(FILE* p_file){
	//update the ocean current grid array from the input text file
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			float tmp;
			fscanf(p_file, "%f", &tmp);
			array[i * row + j] = tmp;
		}
		fscanf(p_file, "\n");
	}
    fclose(p_file);	
}
//
void Grid::print_grid(){
	cout << "FINAL GRID CONTENTS" << endl << "======================" << endl;
	for (int i=0; i < row;i++){
		for (int j=0; j < col; j++){
		    cout << array[i * col + j] << "\t";
		}
		cout << endl;
	}
}
//
void print_timing_statistics(struct timeval start_time,struct timeval end_time)
{
	printf("===== Ocean Current Simulator Timing Details =====\n");
    printf("START TIME:\t\t%f \n", (double)(start_time.tv_sec+((double)start_time.tv_usec/1000000)));
    printf("END TIME:\t\t%f\n", (double)(end_time.tv_sec+((double)end_time.tv_usec/1000000)));
	printf("ELAPSED TIME: \t\t%f sec\n", (double)( (double)(end_time.tv_sec - start_time.tv_sec) + ( (double)(end_time.tv_usec - start_time.tv_usec)/1000000)) );
}


