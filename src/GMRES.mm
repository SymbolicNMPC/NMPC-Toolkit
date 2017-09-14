################################################################################
## Procedure:   GMRES
## Description: This procedure is a numerical solver for a linear
##              equation Ax=b.
##
## Parameters:
##              n :: posint;     length of x
##              b :: Vector;     value of b in Ax=b
##              x :: Vector;     initial value of x
##              kmax :: posint;  number of iterations
##              Err :: Vector;   error vector (Ax-b)
##
##              The following procedure is expected to be defined
##              _MPC_Ax :: procedure; a procedure that computes Ax
##
##              The following parameters are just passed to _MPC_Ax
##              xh :: Vector;      value of the current state vector
##              Uvec :: Vector;    value of the current U
##              xeq :: Vector;     target value for the state vector
##              ueq :: Vector;     target value for the input vector
##              Tp :: nonnegative; prediction horizon
##

GMRES := proc(n    :: integer,
              b    :: Vector,
              x    :: Vector,
              kmax :: integer,
              Err  :: Vector,
              xh   :: Vector,
              Uvec :: Vector,
              w    :: Vector,
              xeq  :: Vector,
              ueq  :: Vector,
              Tp   :: nonnegative)

   local i      :: integer,
         j      :: integer,
         k      :: integer,
         rho    :: positive,
         nu     :: numeric,
         cvec   :: Vector := Vector(kmax),
         svec   :: Vector := Vector(kmax),
         gvec   :: Vector := Vector(kmax+1),
         tmpvec :: Vector := Vector(n),
         hmat   :: Matrix := Matrix(kmax+1,kmax),
         vmat   :: Matrix := Matrix(n,kmax+1),
     	   vmatk  :: Vector := Vector(n),
         temp   :: numeric;

    _MPC_Ax(xh, Uvec, w, x, xeq, ueq, tmpvec, Tp); # Evaluating the initial value of
                                           # the left hand side of the equation
    for i to n do
      tmpvec[i] := b[i]-tmpvec[i];
    end do;

    rho := sqrt(abs(add(tmpvec[i]*tmpvec[i], i=1..n)));
    gvec[1]:=rho;

    for i from 2 to kmax do
      gvec[i]:=0;
    end do;

    for i to n do
      vmat[i,1]:=tmpvec[i]/rho;
    end do;

    for k from 1 to kmax do
      for i to n do
	     vmatk[i] := vmat[i,k];
      end do;

      _MPC_Ax(xh, Uvec, w, vmatk, xeq, ueq, tmpvec, Tp);

      for i to n do
         vmat[i,k+1]:=tmpvec[i];
      end do;

      # Modified Gram-Schmidt
      for j from 1 to k do
      	hmat[j,k]:=add(vmat[i,j]*vmat[i,k+1], i=1..n);
		for i to n do
      	   vmat[i,k+1]:=vmat[i,k+1]-hmat[j,k]*vmat[i,j];
		end do;
      end do;
      hmat[k+1,k]:=sqrt(add(vmat[i,k+1]*vmat[i,k+1], i=1..n));
      if hmat[k+1,k] > 0.0 then
	    for i to n do
      	   vmat[i,k+1]:=vmat[i,k+1]/hmat[k+1,k];
		end do;
      else
         # error("GMRES breakdown");
         return;
      end if;

      for j from 1 to k-1 do
      	temp := cvec[j]*hmat[j,k]+svec[j]*hmat[j+1,k];
      	hmat[j+1,k] := -svec[j]*hmat[j,k]+cvec[j]*hmat[j+1,k];
      	hmat[j,k] := temp;
      end do;

      # Rotation
      if hmat[k+1,k]=0.0 then
          cvec[k]:=1.0;
          svec[k]:=0.0;
      elif abs(hmat[k+1,k]) > abs(hmat[k,k]) then
      	temp := hmat[k,k]/hmat[k+1,k];
      	svec[k] := 1.0/sqrt(1.0+temp^2);
      	cvec[k] := temp*svec[k];
      else
      	temp := hmat[k+1,k]/hmat[k,k];
      	cvec[k] := 1.0/sqrt(1.0+temp^2);
      	svec[k] := temp*cvec[k];
      end if;

      temp := cvec[k]*gvec[k];
      gvec[k+1]:=-svec[k]*gvec[k];
      gvec[k]:=temp;
      hmat[k,k]:=cvec[k]*hmat[k,k]+svec[k]*hmat[k+1,k];
      hmat[k+1,k]:=0;

    end do;

    # Solve hmat*y = gvec (hmat is upper triangular)
    for i from kmax to 1 by -1 do
   	  nu := gvec[i];
      for j from i+1 to kmax do
      	nu := nu-hmat[i,j]*cvec[j];
      end do;
      cvec[i]:=nu/hmat[i,i];
    end do;

    # Answer
    for i from 1 to n do
   	  nu := 0;
   	  for j from 1 to kmax do
   	 	nu := nu + vmat[i,j]*cvec[j];
   	  end do;
   	  x[i]:= x[i]+nu;
    end do;

    _MPC_Ax(xh, Uvec, w, x, xeq, ueq, tmpvec, Tp); # Evaluate the final value of
                                           # the left hand side of the equation

    # Compute the error vector
    for i to n do
      Err[i] := tmpvec[i]-b[i];
    end do;

end proc:
