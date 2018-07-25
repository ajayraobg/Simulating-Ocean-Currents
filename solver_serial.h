#ifndef SOLVER_SERIAL_H
#define SOLVER_SERIAL_H

class Solver_serial : public Grid{
public:
	Solver_serial(int r, int c): Grid(r, c) {};
	~Solver_serial() {};
	void simulate_eqn_solver();
  void red_black_ordering(int rb, float &diff);
};

#endif
	

