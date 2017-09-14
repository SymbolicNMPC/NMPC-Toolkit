################################################################################
## Procedure:   MPCSimulation
## Description: This procedure simulates the closed loop system using
##              a simple fixed step solver.
##
## Parameters:  fxuw :: procedure; fxuw is a procedure that computes the
##                                 vector of the nonlinear system. It
##                                 gets states, control inputs and
##                                 external inputs of the system
##                                 as scalar input arguments and it
##                                 returns the vector field of the
##                                 system as a list.
##              SLP       :: list; the straight line program to compute
##                                 the vector field
##              states    :: list; state variables
##              inputs    :: list; input variables
##              statesdot :: list; the name of the derivatives of the
##                                 state variables in SLP
##              constraints :: list; expressions defining the constraints
##                                   of the optimal control problem.
##                                   The convention is that the
##                                   expressions are required to be
##                                   less than or equal to zero.
##              x0 :: Vector; initial states
##              xd   :: Vector; desired state vector
##              ud   :: Vector; desired input vector
##              Uvec :: Vector; U, initial value of the vector of inputs,
##                              slack variables and Lagrange multipliers
##                              corresponding to the constraints
##              Params :: list; numerical values of the MPC parameters.
##                              For an example, see the MPC example worksheet
##              Tf   :: nonnegative; simulation time

MPCSimulation := proc(SLP         :: list,
                      states      :: list,
                      inputs      :: list,
                      extputs     :: list,
                      statesdot   :: list,
                      constraints :: list,
                      Params      :: list,
                      Tf          :: positive,
                      x0          :: Vector,
                      Uvec        :: Vector,
                      xd          :: Vector,
                      ud          :: Vector,
 					            woft        :: Vector)

   local fxuw      :: 'procedure',
         Nsim      :: 'posint',
         Time      :: 'Vector',
         States    :: 'Matrix',
         Inputs    :: 'Matrix',
         Extputs    :: 'Matrix',
         ErrMagVec :: 'Vector',
         t         :: 'nonnegative',
         ts        :: 'positive',
         xdot      :: 'Vector',
         xk        :: 'Vector',
         xkp1      :: 'Vector',
         uk        :: 'Vector',
         wk        :: 'Vector',
         wt        :: 'Vector',
         tw        :: 'name',
         i         :: 'posint',
         j         :: 'posint',
         P         :: 'Matrix',
         Q         :: 'Matrix',
         R         :: 'Matrix',
         cost      :: 'Vector(nonnegative)',
         N         :: 'posint',
         nU        :: 'posint',
         Tp        :: 'positive',
         kmax      :: 'posint',
         dimx      :: 'posint',
         dimu      :: 'posint',
         dimw      :: 'nonnegative',
         dimc      :: 'nonnegative',
         dUvec     :: 'Vector',
         Err       :: 'Vector';

global   _MPC_b,
         _MPC_Ax;

  # Vector field procedure
  fxuw := MakeProcedure(SLP, states, inputs, extputs, statesdot);

   _MPC_Ax, _MPC_b := OptimalityConditions(SLP, states, inputs, extputs,
                                     statesdot, constraints, Params)[2..3];

   # MPC parameters
   P := Params[1];
   Q := Params[2];
   R := Params[3];
   Tp := Params[4];
   N := Params[5];
   ts := Params[9];
   dimx := Params[10];
   dimu := Params[11];
   dimc := Params[12];
   kmax := Params[13];

   if _params['woft'] = NULL then
      dimw := 0;
   else
	   if type(woft,Vector) then
          wt := woft;
	   else
		  wt := woft[1];
	      tw := woft[2];
	   end if;
       dimw := numelems(wt);
   end if;

   nU := N*(dimu+2*dimc):

   # Initialization
   Nsim   := floor(Tf/ts)+1:       # Number of simulation steps
   States := Matrix(dimx,Nsim):    # History of the state vector
   Inputs := Matrix(dimu,Nsim):    # Histrory of the control input vector
   if dimw > 0 then
      Extputs := Matrix(dimw,Nsim):   # Histrory of the external input vector
   end if:
   Err    := Vector(nU);           # Error of the cGMRES equation
   ErrMagVec := Vector(Nsim):      # History of the magnitude of 'Err'
   cost   := Vector(Nsim):         # History of instantaneous cost
   xdot   := Vector(dimx):         # Derivative of the state vector
   xkp1   := Vector(dimx):         # x[k+1]
   dUvec  := Vector(nU);           # Rate of U

   States(..,1):=x0:               # Initialize States


   # Simulation
   for i to Nsim do
	   xk := States(..,i):     # Current state x[k]
	   uk := Uvec[1..dimu]:    # Current control input u[k]

	   if dimw > 0 then
          wk := eval(wt, tw=i*ts): # Current external input w[k]
	       Extputs[..,i]:=wk:
	   else
		    wk := <NULL>:
      end if;

	   cost[i]:=(xk-xd)^%T.Q.(xk-xd)+(uk-ud)^%T.R.(uk-ud); # Instantaneous cost
      xdot := Vector(fxuw(seq(xk), seq(uk), seq(wk))): # Derivative of the state vector

      # Simulation step

      for j to dimx do
		    xkp1[j] := xk[j]+ts*xdot[j]:
      end do:

      if i < Nsim then
          States[.., i+1] := xkp1: # Storing x[k+1]
      end if;
      Inputs[.., i] := uk:  # Storing u[k]
      t:=i*ts;  # Current time

      # MPC controller
      MPCtrl(Uvec, xk, xdot, wk, xd, ud, Tp, t, kmax, nU, dUvec, Err):

      # Updating U
      for j to nU do
	        Uvec[j] := Uvec[j] + ts*dUvec[j]:
      end do:

      # Magnitude of the error vector of the cGMRES equation
      ErrMagVec[i]:=LinearAlgebra:-Norm(Err):

   end do:

   # Final state penalty
   cost[Nsim]:=(xkp1-xd)^%T.P.(xkp1-xd);

   Time := <seq(i*ts,i=0..Nsim-1)>: # Time history

   return Time, States, Inputs, ErrMagVec, cost;

end proc:
