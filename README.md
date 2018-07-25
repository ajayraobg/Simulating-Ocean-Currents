# Simulating-Ocean-Currents
Ocean current simulation using red black ordering implemented in Serial, OpenMP and CUDA versions.

A parallel application that simulates the motion of water currents in the ocean.
This model uses a set of 2D horizontal cross-sections through the ocean basin. Equations of motion are solved at all the grid points in one time-step. Then the state of the variables is updated, based on this solution. Then the equations of motion are solved for the next time-step. It operates on a regular 2D grid of (n+2) by (n+2) elements.
• The border rows and columns contain boundary elements that do not change.
• The interior n-by-n points are updated, starting from their initial values. 
• The old value at each point is replaced by the weighted average of itself and its 4 nearest-neighbor points.
• Updates are done from left to right, top to bottom.
The update computation for a point sees the new values of points above and to the left, and the old values of points below and to the right. This form of update is called the Gauss-Seidel method. During each sweep, the solver computes how much each element
changed since the last sweep. 
• If this difference is less than a “tolerance” parameter, the solution has converged.
• If so, we exit solver; if not, do another sweep. 
