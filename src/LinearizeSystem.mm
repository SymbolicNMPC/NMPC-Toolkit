################################################################################
## Procedure:   LinearizeSystem
## Description: This procedure returns the system matrices (A and B) of
##              the linear approximation of a nonlinear system with the vector
##              field fxu at the operating point xeq and ueq
##              corresponding to state variables and input variables.
##
## Parameters:  fxu :: procedure; fxu is a procedure that computes the
##                                vector of the nonlinear system. It
##                                gets states and inputs of the system
##                                as scalar input arguments and it
##                                returns the vector field of the
##                                system as a list.
##              xeq :: Vector; xeq is the linearization point for the
##                             state variables.
##              ueq :: Vector; ueq is the linearization point for the
##                             inputs of the system.
##
## Example:     fxu := proc(x1,x2,u1) return [x2,-sin(x1)-2*x2+u1]; end proc;
##              A, B := LinearizeSystem(fxu,<0,0>,<0>);
##              The value of A will be <<0,1>,<-1,-2>> and B will be <<0>,<1>>.

LinearizeSystem := proc(fxu::procedure,
                        xeq::Vector,
                        ueq::Vector,
				            weq::Vector)

   local dimx :: 'integer',
         dimu :: 'integer',
         dimw :: 'integer',
         Jac  :: 'procedure',
         M    :: 'Matrix';

    dimx := numelems(xeq);  # number of states
    dimu := numelems(ueq);  # number of control inputs

  	Jac := codegen:-JACOBIAN([fxu]); # Jacobian of the vector field with
                                     # respect to states and inputs

    if _params['weq'] = NULL then
       M := convert(Jac(seq(xeq),seq(ueq)),Matrix); # M=[A B]
	     return M[1..dimx,1..dimx], M[1..dimx,dimx+1..dimx+dimu];
	  else
	     dimw := numelems(weq);  # number of external inputs
	     M := convert(Jac(seq(xeq),seq(ueq),seq(weq)),Matrix); # M=[A Bu Bw]
       return M[1..dimx,1..dimx], M[1..dimx,dimx+1..dimx+dimu], M[1..dimx,dimx+dimu+1..dimx+dimu+dimw];
	  end if;

end proc:
