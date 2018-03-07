################################################################################
## Procedure:   Hamiltonian
## Description: This procedure returns the Hamiltonian, its partial derivatives
##              with respect to input variables and slack variables,
##              and the partial derivative of the final state penalty
##              with respect to state variables.
##
## Parameters:  fxuw :: procedure; fxuw is a procedure that computes the
##                                 vector of the nonlinear system. It
##                                 gets states, control inputs and
##                                 external inputs of the system
##                                 as scalar input arguments and it
##                                 returns the vector field of the
##                                 system as a list.
##              states  :: list; state variables
##              inputs  :: list; control input variables
##              extputs :: list; external input variables
##              constraints :: list; expressions defining the constraints
##                                   of the optimal control problem.
##                                   The convention is that the
##                                   expressions are required to be
##                                   less than or equal to zero.
##              Params :: list; numerical values of the MPC parameters.
##                              For an example, see the MPC example worksheet

Hamiltonian := proc(SLP         :: list,
                    states      :: list,
                    inputs      :: list,
					extputs     :: list,
                    statesdot   :: list,
                    constraints :: list,
                    Params      :: list)

   local i       :: 'posint',
         P       :: 'Matrix',
         Q       :: 'Matrix',
         R       :: 'Matrix',
         r       :: 'Vector',
         dimx    :: 'integer',
         dimu    :: 'posint',
         dimw    :: 'integer',
         dimc    :: 'integer',
         dstates :: 'Vector',
         dinputs :: 'Vector',
         xvec    :: 'Vector',
         uvec    :: 'Vector',
         wvec    :: 'Vector',
         cvec    :: 'Vector',
         lmdv    :: 'Vector',
         sgmv    :: 'Vector',
         muv     :: 'Vector',
         Cxu     :: 'Vector',
         xe      :: 'Vector',
         ue      :: 'Vector',
         phid    :: 'procedure',
         H       :: 'scalar',
         Hslp    :: 'list',
         uv      :: 'Vector',
         phix    :: 'procedure',
         Hp      :: 'procedure',
         Hpu     :: 'procedure',
         Hpx     :: 'procedure';

    # MPC parameters
    P := Params[1];
    Q := Params[2];
    R := Params[3];
    r := Params[7];

    dimx := numelems(states);       # number of states
    dimu := numelems(inputs);       # numbers of control inputs
    dimw := numelems(extputs);      # numbers of external inputs
    dimc := numelems(constraints);  # number of constraints

    # State vector
    xvec    := `<,>`(seq(`tools/genglobal`(cat('x',i)), i = 1 .. dimx));

    # Control input vector
    uvec    := `<,>`(seq(`tools/genglobal`(cat('u',i)), i = 1 .. dimu));

    # External input vector
    wvec    := `<,>`(seq(`tools/genglobal`(cat('w',i)), i = 1 .. dimw));

    # Desired state
    dstates := `<,>`(seq(`tools/genglobal`(cat('xd',i)), i = 1 .. dimx));

    # Desired input
    dinputs := `<,>`(seq(`tools/genglobal`(cat('ud',i)), i = 1 .. dimu));

    # Costate vector
    lmdv    := `<,>`(seq(`tools/genglobal`(cat('lmd',i)), i = 1 .. dimx));

    xe := xvec-dstates; # state tracking error
    ue := uvec-dinputs; # input tracking error

    # Final state penlty
    phid := unapply(xe^%T.P.xe, [seq(xvec),seq(dstates)]);

    # Hamiltonian assuming there are no constraints
    Hslp := [seq(eval(SLP, [seq(Vector(states)=~xvec),
                             seq(Vector(inputs)=~uvec),
                             seq(Vector(extputs)=~wvec)])),
             H = xe^%T.Q.xe+ue^%T.R.ue+lmdv^%T.Vector(statesdot)];


    # Adding the constraints if any
    if dimc > 0 then
        # Slack variables
        sgmv := `<,>`(seq(`tools/genglobal`(cat('sig',i)), i = 1 .. dimc));

        # Lagrange multipliers corresponding to constraints
        muv  := `<,>`(seq(`tools/genglobal`(cat('mu',i)), i = 1 .. dimc));

        # Constraints
        cvec := eval(Vector(constraints), [seq(states=~xvec),seq(inputs=~uvec),seq(extputs=~wvec)]);
        Cxu  := Vector([seq(sgmv[i]^2+cvec[i], i = 1 .. dimc)]);

        # Hamiltonian with constraints
        Hslp := [seq(Hslp), H = H-r^%T . sgmv+muv^%T . Cxu];

        # U in the MPC report
        uv   := `<,>`(seq(uvec), seq(sgmv), seq(muv));

    else

   	    sgmv := <NULL>; # Slack variables
   	    muv  := <NULL>; # Lagrangian multipliers corresponding to constraints
        uv := uvec;     # U in the MPC report

    end if;

    # Hamiltonian
    Hp := codegen:-makeproc(Hslp,
  	              ':-parameters' = [seq(xvec),seq(uvec),seq(wvec),
                                   seq(dstates),seq(dinputs),
                                   seq(lmdv),seq(sgmv),seq(muv)]);

    # Partial derivative of the Hamiltonian w.r.t U
    Hpu  := codegen:-JACOBIAN([Hp],convert(uv,list));

    # Partial derivative of the Hamiltonian w.r.t x
    Hpx  := codegen:-JACOBIAN([Hp],convert(xvec,list));

    # Partial derivative of the final state penalty w.r.t x
    phix := codegen:-JACOBIAN([phid],convert(xvec,list));

    return Hp, Hpu, Hpx, phix;

end proc:
