#ifndef GRID_H
#define GRID_H

#include <sys/time.h>
#include <math.h>
#include <fstream>
#include <iostream>
#include <stdlib.h>
using namespace std;

#define RED 0
#define BLACK 1

class Grid{
protected:
	int row, col;
	float tolerance;
	float* array;
	
public:
	Grid(int, int);
	virtual ~Grid();
	void initialize_grid(FILE* p_file);
	void set_tol_value(float tol) {tolerance = tol;}
	void print_grid();
	virtual void simulate_eqn_solver() = 0;
};

void print_timing_statistics(struct timeval start_time,struct timeval end_time);

#endif

