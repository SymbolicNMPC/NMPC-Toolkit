# MPC Design Tools

##
## Copyright (C) 2015-2017 Maplesoft
## Authors:    Behzad Samadi <bsamadi@maplesoft.com>
## Created:    July 2017
## Version:    0.3
## Keywords:   Maple, Code Generation, Model Predictive Control (MPC)
##
## Procedures:
##             IntermediateVariablesResult
##             LinearizeSystem
##             Hamiltonian
##             OptimalityConditions
##             GMRES
##             MPCtrl
##             MPCSimulation
##

NMPCToolkit := module()
description "Model Predictive Control (MPC) design and automatic code generation";
option package;

export LinearizeSystem,
       GMRES,
       OptimalityConditions,
       MPCtrl,
       MPCSimulation,
       GenerateC,
       MakeProcedure;

local  Hamiltonian,
       IntermediateVariablesResult,
       RemoveParam,
       GetParam;

$include "GMRES.mm"
$include "Hamiltonian.mm"
$include "IntermediateVariablesResult.mm"
$include "LinearizeSystem.mm"
$include "MPCSimulation.mm"
$include "MPCtrl.mm"
$include "OptimalityConditions.mm"
$include "RemoveParam.mm"
$include "GetParam.mm"
$include "GenerateC.mm"
$include "MakeProcedure.mm"

end module; # NMPCToolkit
