#ifndef SOLVER_CUDA_H
#define SOLVER_CUDA_H

class Solver_cuda : public Grid{
public:
	Solver_cuda(int r, int c): Grid(r, c) {};
	~Solver_cuda() {};
	void simulate_eqn_solver();
	void calc_sum(float &diff, float *diff1, int row, int col);
};

#endif

