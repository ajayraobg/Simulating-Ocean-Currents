#ifndef SOLVER_OMP_H
#define SOLVER_OMP_H

class Solver_omp : public Grid{
private: 
	int num_of_threads;
public:
	Solver_omp(int r, int c, int t): Grid(r, c), num_of_threads(t) {} ;
	~Solver_omp() {};
	void simulate_eqn_solver();
	void red_black_ordering(int rb, float &diff);
};

#endif

