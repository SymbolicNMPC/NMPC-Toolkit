################################################################################
## Procedure:   IntermediateVariablesResult
## Description: This procedure returns the names of the intermediate
##              variables and the name of the output variable (result) of a
##              given single line program (SLP). It is assumed that the result
##              is an index variable.
##
## Parameters:  SLP :: list; SLP is a list of equations. The purpose of SLP
##                           is to compute a result given some input
##                           variables. The computation is performed
##                           step by step according to the order of the
##                           equations in SLP. The left hand side of
##                           each equation is the name of an
##                           intermediate variable or an entry of the result.
##                           The right hand side of each equation is a
##                           function of input variables and previous
##                           intermediate variables. The equations to
##                           compute the entries of the result are
##                           listed at the end of SLP.
##
##
## Example:     SLP := [a=x+2,b=x^2,z[1]=x+b,z[2]=a^2];
##              IV, Out := IntermediateVariablesResult(SLP);
##              The value of IV will be [a,b] and Out will be z.

IntermediateVariablesResult:=proc(SLP::list)

    local names::'list';

    # Put all the names of the variables on the left hand side of SLP.
    names := map(x->lhs(x),SLP);

    # Remove the variables that are indexed and return the main name of the
    # indexed variable (the output of the SLP)
    return remove(type,names,indexed), op(0,lhs(SLP[-1]));

end proc:
