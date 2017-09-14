################################################################################
## Procedure:   MPCtrl
## Description: This procedure computes the rate of U. For the
##              definition of U, see the MPC report.
##
## Parameters:  Uvec :: Vector; U, vector of inputs, slack
##                              variables and Lagrange multipliers
##                              corresponding to the constraints
##              xk   :: Vector; state vector of the system
##              xdot :: Vector; derivative of the state vector
##              xd   :: Vector; desired state vector
##              ud   :: Vector; desired input vector
##              Tp   :: nonnegative; prediction horizon
##              t    :: nonnegative; current time
##              kmax :: posint; number of iteration for GMRES
##              nU   :: posint; length of Uvec
##              dUvec:: Vector; rate of U
##              Err  :: Vector; error vector
##              bP   :: procedure; right hand side of the cGMRES equation
##              Ax   :: procedure; left hand side of the cGMRES equation,
##                                 see the MPC report
##

MPCtrl := proc(Uvec  :: Vector,
			         xk    :: Vector,
			         xdot  :: Vector,
			         w     :: Vector,
			         xd    :: Vector,
			         ud    :: Vector,
			         Tp    :: numeric,
			         t     :: numeric,
			         kmax  :: posint,
			         nU    :: posint,
			         dUvec :: Vector,
			         Err   :: Vector)

          local  bvec :: 'Vector' := Vector(nU),
		             tp   :: 'nonnegative',
		             i    :: 'integer';

 	  for i to nU do
		   dUvec[i] := 0;
		   Err[i] := 0;
    end do;

    tp := Tp*(1-exp(-0.01*t)); # Current horizon time
    _MPC_b(xk, Uvec, w, xdot, xd, ud, bvec, tp); # Right hand side of the equation

    # Call the solver to compute dUvec, the rate of Uvec
    GMRES(nU, bvec, dUvec, kmax, Err, xk, Uvec, w, xd, ud, tp):

end proc:
