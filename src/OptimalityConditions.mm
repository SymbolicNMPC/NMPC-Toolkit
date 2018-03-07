################################################################################
## Procedure:   OptimalityConditions
## Description: This procedure returns procedures that compute F(x,U)
##              the optimality conditions, F_U(x,U) the partial derivative of
##              optimality conditions with respect to U and
##              A_sF(x,U)-F_x(x,U)f(x,u,w), the right hand side of the
##              equation to compute the rate of U. For the definitions
##              of the variables, see the MPC report.
##
## Parameters:  fxuw :: procedure; fxuw is a procedure that computes the
##                                 vector of the nonlinear system. It
##                                 gets states, control inputs and
##                                 external inputs of the system
##                                 as scalar input arguments and it
##                                 returns the vector field of the
##                                 system as a list.
##              SLP      :: list; the straight line program to compute
##                                the vector field
##              states    :: list; state variables
##              inputs    :: list; control input variables
##              extputs   :: list; external input variables
##              statesdot :: list; the name of the derivatives of the
##                                 state variables in SLP
##              constraints :: list; expressions defining the constraints
##                                   of the optimal control problem.
##                                   The convention is that the
##                                   expressions are required to be
##                                   less than or equal to zero.
##              Params :: list; numerical values of the MPC parameters.
##                              For an example, see the MPC example worksheet

OptimalityConditions := proc(SLP         :: list,
                             states      :: list,
                             inputs      :: list,
                             extputs     :: list,
                             statesdot   :: list,
                             constraints :: list,
                             Params      :: list)

       local fxuw          :: 'procedure',
             dimx          :: 'posint',
             dimu          :: 'posint',
             dimw          :: 'nonnegint',
             dimc          :: 'posint',
             nU            :: 'posint',
             x             :: 'name',
             xd            :: 'name',
             x0            :: 'name',
             u             :: 'name',
             ud            :: 'name',
             w             :: 'name',
             lambda        :: 'name',
             output        :: 'name',
             sigma         :: 'name',
             mu            :: 'name',
             opSLP         :: 'list',
             Update        :: 'procedure',
             i             :: 'integer',
             j             :: 'integer',
             k             :: 'integer',
             kx            :: 'integer',
             Tp            :: 'name',
             N             :: 'integer',
             XH            :: 'Vector',
             UH            :: 'Vector',
             WH            :: 'Vector',
             LH            :: 'Vector',
             SH            :: 'Vector',
             MH            :: 'Vector',
             StateUpdate   :: 'list',
             result        :: 'name',
             IV            :: 'list',
             zi            :: 'name',
             oc            :: 'name',
             Hu            :: 'procedure',
             Hx            :: 'procedure',
             phix          :: 'procedure',
             XD            :: 'Vector',
             UD            :: 'Vector',
             CostateUpdate :: 'list',
             OC            :: 'Vector',
             OCSLP         :: 'list',
             Uvec          :: 'Vector',
             Xkp1          :: 'name',
             F             :: 'procedure',
             h             :: 'positive',
             out           :: 'name',
             OC1           :: 'name' := ':-OC1',
             OC2           :: 'name',
             X1            :: 'name',
             X2            :: 'name',
             lambda1       :: 'name',
             lambda2       :: 'name',
             zi1           :: 'name',
             zi2           :: 'name',
             OC1vec        :: 'Vector',
             OC2vec        :: 'Vector',
             X1vec         :: 'Vector',
             X2vec         :: 'Vector',
             lmd1vec       :: 'Vector',
             lmd2vec       :: 'Vector',
             zi1vec        :: 'Vector',
             zi2vec        :: 'Vector',
             a             :: 'positive',
             OCP           :: 'procedure',
             xdot          :: 'Vector',
             bvecSLP       :: 'list',
             bP            :: 'procedure',
             FUSLP         :: 'list',
             Ax            :: 'procedure',
             Udot          :: 'Vector',
             OptimalityCdn :: 'list';

    # Vector field procedure
    fxuw := MakeProcedure(SLP, states, inputs, extputs, statesdot);

    # MPC parameters
    N := Params[5];  # Prediction steps
    a := Params[6];  # Sliding surface parameter
    h := Params[8];  # Time step for approximating the Jacobian

    dimx := numelems(states);       # Number of states
    dimu := numelems(inputs);       # Number of control inputs
    dimw := numelems(extputs);      # Number of external inputs
    dimc := numelems(constraints);  # Number of constraints

    # Straight line program for one step state update
    opSLP := eval(SLP,[seq(states[i]=x[i],i=1..dimx),
                       seq(inputs[i]=u[i],i=1..dimu),
                       seq(extputs[i]=w[i],i=1..dimw)]);
    opSLP := [seq(opSLP),seq(Xkp1[i]=x[i]+(Tp/N)*statesdot[i],i=1..dimx)];

    # Intermediate variables of the straight line program
    # for one step state update
    IV, result := IntermediateVariablesResult(opSLP);

    kx := numelems(IV);  # Number of intermediate variables of the
                         # straight line program for one step state update

    # Create a procedure for one step state update
    Update := unapply(eval(opSLP,IV=~[seq(zi[kx*(i-1)+j],j=1..kx)]),
                                                          [result, x, u, w, i]);

    XH := Vector((N+1)*dimx, symbol = x);    # Vector of state vectors
    XH[1 .. dimx] := <seq(x0[i],i=1..dimx)>; # Initial conditions
    UH := Vector(N*dimu, symbol = u);        # Vector of control input vectors
    WH := Vector(dimw, symbol = w);          # Vector of external input vectors

    # State update for N steps
    StateUpdate := [seq(seq(Update(XH[dimx*i+1 .. (i+1)*dimx],
                                   XH[dimx*(i-1)+1 .. i*dimx],
                                   UH[dimu*(i-1)+1 .. i*dimu],
				       WH,i)), i = 1 .. N)];

    # Partial derivativs of the Hamiltonian and the final state penalty
    Hu, Hx, phix := Hamiltonian(SLP, states, inputs, extputs, statesdot, constraints, Params)[2..4];

    # Costate Update
    LH := Vector((N+1)*dimx, symbol = lambda); # Vector for costate vectors
    XD := Vector(dimx, symbol = xd);           # Desired state vector
    UD := Vector(dimu, symbol = ud);           # Desired input vector
    SH := Vector(N*dimc, symbol = sigma);      # Vector of slack variables
    MH := Vector(N*dimc, symbol = mu);         # Vector of Lagrange multipliers

    # Straight line program for one step costate update
    opSLP:=convert(<seq(output[i],i=1..dimx)> =~ <seq(lambda[i],i=1..dimx)>
                       +(Tp/N)*Vector[column](Hx(seq(x[i], i = 1 .. dimx),
                                                 seq(u[i], i = 1 .. dimu),
						             seq(w[i], i = 1 .. dimw),
                                                 seq(XD),
                                                 seq(UD),
                                                 seq(lambda[i], i = 1 .. dimx),
				     		             seq(sigma[i], i = 1 .. dimc),
                                                 seq(mu[i], i = 1 .. dimc))),list);

    opSLP:=[codegen:-optimize(opSLP)];

    # Intermediate variables of the straight line program
    # for one step costate update
    IV,result := IntermediateVariablesResult(opSLP);

    k := numelems(IV);

    # One step costate update
    Update := unapply(eval(opSLP,IV=~[seq(zi[k*(i-1)+j+N*kx],j=1..k)]),
                         [result, x, u, w, lambda, sigma, mu, i]);

    # N step costate update
    CostateUpdate := [seq(LH[dimx*N+1..-1]=~phix(seq(XH[dimx*N+1..-1]),
                           seq(XD))),
	                     seq(op(Update(LH[dimx*(i-1)+1 .. i*dimx],
   		                             XH[dimx*(i-1)+1 .. i*dimx],
				    	           UH[dimu*(i-1)+1 .. i*dimu],
					           WH,
					           LH[dimx*i+1 .. (i+1)*dimx],
					           SH[dimc*(i-1)+1 .. i*dimc],
                                         MH[dimc*(i-1)+1 .. i*dimc], i)),
                                         i = N..1, -1)];

    # Straight line program for computing H_u, the partial derivative
    # of the Hamiltonian with respect to U
    opSLP:=[seq(output[i],i=1..dimu+2*dimc)] =~ convert(Hu(seq(x[i], i = 1 .. dimx),
                             seq(u[i], i = 1 .. dimu),
				     seq(w[i], i = 1 .. dimw),
                             seq(XD),
                             seq(UD),
                             seq(lambda[i], i = 1 .. dimx),
				     seq(sigma[i], i = 1 .. dimc),
				     seq(mu[i], i = 1 .. dimc)), list);
    kx := kx+k;
    IV,result := IntermediateVariablesResult(opSLP);
    k := numelems(IV);
    Update := unapply(eval(opSLP,IV=~[seq(zi[k*(i-1)+j+N*kx],j=1..k)]),
    [result, x, u, w, lambda, sigma, mu, i]);

    kx := kx+k;
    OC:=Vector(N*(dimu+2*dimc), symbol = oc);

    # Putting N steps of H_u together
    OptimalityCdn :=
          [seq(seq(Update(OC[(dimu+2*dimc)*(i-1)+1 .. i*(dimu+2*dimc)],
	 		  XH[dimx*(i-1)+1 .. i*dimx],
			  UH[dimu*(i-1)+1 .. i*dimu],
			  WH,
			  LH[dimx*i+1 .. (i+1)*dimx],
			  SH[dimc*(i-1)+1 .. i*dimc],
                    MH[dimc*(i-1)+1 .. i*dimc], i)),
                    i = 1 .. N)];

    nU := N*(dimu+2*dimc); # Number of elements of U

    # Straight line program for optimality conditions
    OCSLP := [op(StateUpdate), op(CostateUpdate), op(OptimalityCdn)];

    OCSLP := eval(OCSLP, [u=<seq(seq(Uvec[i+j], j=0..dimu-1),
                                        i = 1 .. nU, dimu+2*dimc)>,
                             sigma=<seq(seq(Uvec[i+j], j=0..dimc-1),
                                        i = dimu+1 .. nU, dimu+2*dimc)>,
                             mu=<seq(seq(Uvec[i+j], j=0..dimc-1),
                                     i = dimu+dimc+1 .. nU, dimu+2*dimc)>]);

    # Procedure that returns the straight line program for optimality conditions
    F := unapply(OCSLP,[x0, Uvec, w, x, lambda, zi, xd, ud, oc, Tp]);

    # Make a procedure to compute optimality conditions
    OCP := codegen:-makeproc(OCSLP,
                       ':-parameters' = [x0, Uvec, w, xd, ud, oc, Tp],
                       ':-locals' = [x, lambda, zi]);

    # Compute b, the right hand side of the cGMRES equation
    bvecSLP := [seq(F(x0, Uvec, w, X1, lambda1, zi1, xd, ud, OC1, Tp)),
                   seq(F(<seq(x0[i]+h*xdot[i], i=1..dimx)>,
                         Uvec, w, X2, lambda2, zi2, xd, ud, OC2, Tp)),
	               seq(out[i]=-a*OC1[i]-(OC2[i]-OC1[i])/h,i=1..nU)];

    # Replace zi1, zi2, lambda1, lambda2, X1, X2, OC1 and OC2
    # with scalar variables
    zi1vec  := <seq(`tools/genglobal`(cat('iv1_',i)),i=1..N*kx)>;
    zi2vec  := <seq(`tools/genglobal`(cat('iv2_',i)),i=1..N*kx)>;
    lmd1vec := <seq(`tools/genglobal`(cat('lmd1_',i)),i=1..(N+1)*dimx)>;
    lmd2vec := <seq(`tools/genglobal`(cat('lmd2_',i)),i=1..(N+1)*dimx)>;
    X1vec   := <seq(`tools/genglobal`(cat('X1_',i)),i=1..(N+1)*dimx)>;
    X2vec   := <seq(`tools/genglobal`(cat('X2_',i)),i=1..(N+1)*dimx)>;
    OC1vec  := <seq(`tools/genglobal`(cat('oc1_',i)),i=1..N*(dimu+2*dimc))>;
    OC2vec  := <seq(`tools/genglobal`(cat('oc2_',i)),i=1..N*(dimu+2*dimc))>;

    bvecSLP := eval(bvecSLP,
                        [zi1=zi1vec,zi2=zi2vec,lambda1=lmd1vec,lambda2=lmd2vec,
                         X1=X1vec,X2=X2vec,OC1=OC1vec,OC2=OC2vec]);

    # Make an optimized procedure to compute b, the right hand side of
    # the cGMRES equation

    bP := codegen:-makeproc(bvecSLP,
             ':-parameters' = [x0::Vector, Uvec::Vector, w::Vector,
		                   xdot::Vector, xd::Vector, ud::Vector,
		                   out::Vector, Tp::numeric],
             ':-locals' = [seq(X1vec), seq(lmd1vec), seq(zi1vec),
                           seq(X2vec), seq(lmd2vec), seq(zi2vec),
                           seq(OC1vec), seq(OC2vec)]);
    bP := codegen:-optimize(bP);

	# Compute the left hand side of the cGMRES equation
    FUSLP := [seq(F(x0, Uvec, w, X1, lambda1, zi1, xd, ud, OC1, Tp)),
                 seq(F(x0, <seq(Uvec[i]+h*Udot[i],i=1..nU)>, w,
                       X2, lambda2, zi2, xd, ud, OC2, Tp)),
				 seq(out[i]=(OC2[i]-OC1[i])/h,i=1..nU)];

    FUSLP := eval(FUSLP,[zi1=zi1vec,zi2=zi2vec,lambda1=lmd1vec,
                         lambda2=lmd2vec,X1=X1vec,X2=X2vec,
                         OC1=OC1vec,OC2=OC2vec]);

    # Make an optimized procedure to compute the left hand side of
    # the cGMRES equation

    Ax := codegen:-makeproc(FUSLP,
	              ':-parameters' = [x0::Vector, Uvec::Vector, w::Vector, Udot::Vector, xd::Vector, ud::Vector, out::Vector, Tp],
                      ':-locals' = [seq(X1vec), seq(lmd1vec), seq(zi1vec),
                                seq(X2vec), seq(lmd2vec), seq(zi2vec),
                                seq(OC1vec), seq(OC2vec)]);
    Ax := codegen:-optimize(Ax);
    return OCP, Ax, bP;

end proc:
