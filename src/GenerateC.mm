GenerateC := proc(Ax,b,kmax,nU)
	local bc, Axc, MPC2C, MPCtrlc, Code_str, Include, IncludeLines, i, defs, LinearSolver, LinearSolverc, MPC_b, MPC_Ax, WL;

         # Problem formulation

         MPC_b := eval(b);
         MPC_Ax := eval(Ax);
         bc := CodeGeneration:-C(MPC_b, ':-defaulttype' = float, ':-deducereturn' = false, ':-deducetypes' = false, ':-coercetypes' = false, ':-output' = string):
         Axc := CodeGeneration:-C(MPC_Ax, ':-defaulttype' = float, ':-deducereturn' = false, ':-deducetypes' = false, ':-coercetypes' = false, ':-output' = string):

         # GMRES
         LinearSolver:=eval(:-NMPCToolkit:-GMRES):
         LinearSolver:=subs(':-_MPC_Ax'=':-MPC_Ax', eval(LinearSolver)):
         LinearSolver:=RemoveParam(LinearSolver,':-kmax', kmax):
         LinearSolver:=RemoveParam(LinearSolver,':-n', nU):

         WL := interface(warnlevel);
         interface(warnlevel=0);
         LinearSolverc := CodeGeneration:-C(LinearSolver, ':-declare'=[':-b'::'Vector',
                                                                   ':-x'::'Vector',
                                                                 ':-Err'::'Vector',
                                                                  ':-xh'::'Vector',
                                                                ':-Uvec'::'Vector',
                                                                   ':-w'::'Vector',
                                                                 ':-xeq'::'Vector',
                                                                 ':-ueq'::'Vector',
                                                                  ':-Tp'::'float',
                                                                   ':-i'::'integer',
                                                                   ':-j'::'integer',
                                                                   ':-k'::'integer',
                                                                ':-cvec'::'Vector'(kmax),
                                                                ':-svec'::'Vector'(kmax),
                                                                ':-gvec'::'Vector'(kmax+1),
                                                              ':-tmpvec'::'Vector'(nU),
                                                                ':-vmat'::'Matrix'(nU,kmax+1),
                                                                ':-hmat'::'Matrix'(kmax+1,kmax),
                                                               ':-vmatk'::'Vector'(nU)],
                  ':-defaulttype' = float, ':-deducereturn' = false, ':-deducetypes' = false, ':-coercetypes' = false, ':-output' = string):
         interface(warnlevel=WL);


         # MPCtrl
         MPC2C := parse(StringTools:-Substitute(convert(eval(:-NMPCToolkit:-MPCtrl),string),"NMPCToolkit:-GMRES","LinearSolver")):
         MPC2C := subs(':-_MPC_b'=':-MPC_b', eval(MPC2C)):
         MPC2C := RemoveParam(MPC2C,':-nU', nU):
         MPC2C := RemoveParam(MPC2C,':-kmax'):

         WL := interface(warnlevel);
         interface(warnlevel=0);
         MPCtrlc := CodeGeneration:-C(MPC2C, ':-declare'=[':-Uvec'::Vector,
                                                        ':-xk'::Vector,
                                                      ':-xdot'::Vector,
                                                         ':-w'::Vector,
                                                        ':-xd'::Vector,
                                                        ':-ud'::Vector,
                                                     ':-dUvec'::Vector,
                                                       ':-Err'::Vector,
                                                      ':-bvec'::'Vector'(nU),
                                                        ':-tp'::'float',
                                                         ':-i'::'integer'],
                  ':-defaulttype' = float, ':-deducereturn' = false, ':-deducetypes' = false, ':-coercetypes' = false, ':-output' = string):
         interface(warnlevel=WL);

         MPCtrlc := StringTools:-Substitute(MPCtrlc,"MPC2C","MPCtrl");
         MPCtrlc := StringTools:-SubstituteAll(MPCtrlc,cat(convert(nU,':-string'),", "),"");

         # Generate the C code
         Code_str := cat(bc, Axc, LinearSolverc, MPCtrlc):
         Code_str := StringTools:-SubstituteAll(Code_str,"_MPC_Ax","MPC_Ax");
         Code_str := StringTools:-SubstituteAll(Code_str,"_MPC_b","MPC_b");

         Include:=[StringTools:-SearchAll("#include",Code_str)]:
         IncludeLines:= {seq(Code_str[Include[i]..Include[i]+StringTools:-Search("\n", Code_str[Include[i] .. -1])],i=1..numelems(Include))}:
         for i to numelems(IncludeLines) do
	       Code_str := StringTools:-SubstituteAll(Code_str,IncludeLines[i],""):
         end do:
         defs := "#ifdef WMI_WINNT\n #define EXP __declspec(dllexport)\n #define M_DECL __stdcall\n #else\n #define EXP\n #define M_DECL\n #endif\n\n":
         Code_str := cat(seq(IncludeLines),defs,Code_str):
         Code_str := StringTools:-Substitute(Code_str,"void MPCtrl","EXP void M_DECL MPCtrl"):

         return Code_str;

	end proc:
