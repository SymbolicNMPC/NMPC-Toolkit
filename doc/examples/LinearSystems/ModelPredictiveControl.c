#include <math.h>

#ifdef WMI_WINNT
 #define EXP __declspec(dllexport)
 #define M_DECL __stdcall
 #else
 #define EXP
 #define M_DECL
 #endif

void MPC_b (
  double *x0,
  double *Uvec,
  double *w,
  double *xdot,
  double *xd,
  double *ud,
  double *out,
  double Tp)
{
  double X1_100;
  double X1_30;
  double X1_40;
  double X1_50;
  double X1_60;
  double X1_70;
  double X1_80;
  double X1_90;
  double X2_100;
  double X2_30;
  double X2_40;
  double X2_50;
  double X2_60;
  double X2_70;
  double X2_80;
  double X2_90;
  double iv1_10;
  double lmd1_30;
  double lmd1_40;
  double lmd1_50;
  double lmd1_60;
  double lmd1_70;
  double lmd1_80;
  double lmd1_90;
  double lmd2_30;
  double lmd2_40;
  double lmd2_50;
  double lmd2_60;
  double lmd2_70;
  double lmd2_80;
  double lmd2_90;
  double oc1_110;
  double oc1_120;
  double oc1_20;
  double oc1_30;
  double oc1_50;
  double oc1_60;
  double oc1_80;
  double oc1_90;
  double t1;
  double t10;
  double t101;
  double t102;
  double t104;
  double t105;
  double t108;
  double t112;
  double t113;
  double t115;
  double t116;
  double t16;
  double t2;
  double t22;
  double t28;
  double t29;
  double t3;
  double t31;
  double t32;
  double t34;
  double t36;
  double t4;
  double t40;
  double t61;
  double t66;
  double t68;
  double t69;
  double t71;
  double t72;
  double t75;
  double t79;
  double t80;
  double t82;
  double t83;
  double t86;
  double t90;
  double t91;
  double t93;
  double t94;
  double t97;
  double lmd1_100;
  double lmd2_100;
  iv1_10 = x0[1];
  t1 = x0[0];
  t2 = 2 * iv1_10;
  t3 = Uvec[0];
  t4 = w[0];
  X1_30 = t1 + Tp * iv1_10 / 4;
  X1_40 = iv1_10 + Tp * (-t1 - t2 + t3 + t4) / 4;
  t10 = Uvec[3];
  X1_50 = X1_30 + Tp * X1_40 / 4;
  X1_60 = X1_40 + Tp * (-X1_30 - 2 * X1_40 + t10 + t4) / 4;
  t16 = Uvec[6];
  X1_70 = X1_50 + Tp * X1_60 / 4;
  X1_80 = X1_60 + Tp * (-X1_50 - 2 * X1_60 + t16 + t4) / 4;
  t22 = Uvec[9];
  X1_90 = X1_70 + Tp * X1_80 / 4;
  X1_100 = X1_80 + Tp * (-X1_70 - 2 * X1_80 + t22 + t4) / 4;
  t28 = xd[0];
  t29 = t28 * 0.151375238638532444e0;
  t31 = xd[1];
  t32 = t31 * 0.327525008726796081e-15;
  lmd1_90 = X1_90 * 0.151375238638532444e0 - t29 + X1_100 * 0.327525008726796081e-15 - t32;
  t34 = t28 * 0.327525008726796081e-15;
  t36 = t31 * 0.151375238638532250e0;
  lmd1_100 = X1_90 * 0.327525008726796081e-15 - t34 + X1_100 * 0.151375238638532250e0 - t36;
  lmd1_70 = lmd1_90 - Tp * lmd1_100 / 4;
  t40 = 0.2e1 * t31;
  lmd1_80 = lmd1_100 + Tp * (0.2e1 * X1_80 - t40 + lmd1_90 - 2 * lmd1_100) / 4;
  lmd1_50 = lmd1_70 - Tp * lmd1_80 / 4;
  lmd1_60 = lmd1_80 + Tp * (0.2e1 * X1_60 - t40 + lmd1_70 - 2 * lmd1_80) / 4;
  lmd1_30 = lmd1_50 - Tp * lmd1_60 / 4;
  lmd1_40 = lmd1_60 + Tp * (0.2e1 * X1_40 - t40 + lmd1_50 - 2 * lmd1_60) / 4;
  t61 = 0.2e1 * iv1_10;
  t66 = 0.1643203912e-1 * t3;
  t68 = 0.1643203912e-1 * ud[0];
  t69 = Uvec[2];
  t71 = 2 * t69 * t3;
  t72 = Uvec[1];
  oc1_20 = -0.1e-3 + 2 * t69 * t72;
  t75 = t72 * t72;
  oc1_30 = t75 + (t3 - 7) * (t3 + 7);
  t79 = 0.1643203912e-1 * t10;
  t80 = Uvec[5];
  t82 = 2 * t80 * t10;
  t83 = Uvec[4];
  oc1_50 = -0.1e-3 + 2 * t80 * t83;
  t86 = t83 * t83;
  oc1_60 = t86 + (t10 - 7) * (t10 + 7);
  t90 = 0.1643203912e-1 * t16;
  t91 = Uvec[8];
  t93 = 2 * t91 * t16;
  t94 = Uvec[7];
  oc1_80 = -0.1e-3 + 2 * t91 * t94;
  t97 = t94 * t94;
  oc1_90 = t97 + (t16 - 7) * (t16 + 7);
  t101 = 0.1643203912e-1 * t22;
  t102 = Uvec[11];
  t104 = 2 * t102 * t22;
  t105 = Uvec[10];
  oc1_110 = -0.1e-3 + 2 * t102 * t105;
  t108 = t105 * t105;
  oc1_120 = t108 + (t22 - 7) * (t22 + 7);
  t112 = xdot[1];
  t113 = 0.1e-2 * t112;
  t115 = 0.1e-2 * xdot[0];
  t116 = 0.2e-2 * t112;
  X2_30 = t1 + t115 + Tp * (iv1_10 + t113) / 4;
  X2_40 = iv1_10 + t113 + Tp * (-t1 - t115 - t2 - t116 + t3 + t4) / 4;
  X2_50 = X2_30 + Tp * X2_40 / 4;
  X2_60 = X2_40 + Tp * (-X2_30 - 2 * X2_40 + t10 + t4) / 4;
  X2_70 = X2_50 + Tp * X2_60 / 4;
  X2_80 = X2_60 + Tp * (-X2_50 - 2 * X2_60 + t16 + t4) / 4;
  X2_90 = X2_70 + Tp * X2_80 / 4;
  X2_100 = X2_80 + Tp * (-X2_70 - 2 * X2_80 + t22 + t4) / 4;
  lmd2_90 = X2_90 * 0.151375238638532444e0 - t29 + X2_100 * 0.327525008726796081e-15 - t32;
  lmd2_100 = X2_90 * 0.327525008726796081e-15 - t34 + X2_100 * 0.151375238638532250e0 - t36;
  lmd2_70 = lmd2_90 - Tp * lmd2_100 / 4;
  lmd2_80 = lmd2_100 + Tp * (0.2e1 * X2_80 - t40 + lmd2_90 - 2 * lmd2_100) / 4;
  lmd2_50 = lmd2_70 - Tp * lmd2_80 / 4;
  lmd2_60 = lmd2_80 + Tp * (0.2e1 * X2_60 - t40 + lmd2_70 - 2 * lmd2_80) / 4;
  lmd2_30 = lmd2_50 - Tp * lmd2_60 / 4;
  lmd2_40 = lmd2_60 + Tp * (0.2e1 * X2_40 - t40 + lmd2_50 - 2 * lmd2_60) / 4;
  out[0] = -0.20e2 * t66 + 0.20e2 * t68 + 0.980e3 * lmd1_40 - 0.20e2 * t71 - 0.1e4 * lmd2_40;
  out[1] = -0.20e2 * oc1_20;
  out[2] = -0.20e2 * oc1_30;
  out[3] = -0.20e2 * t79 + 0.20e2 * t68 + 0.980e3 * lmd1_60 - 0.20e2 * t82 - 0.1e4 * lmd2_60;
  out[4] = -0.20e2 * oc1_50;
  out[5] = -0.20e2 * oc1_60;
  out[6] = -0.20e2 * t90 + 0.20e2 * t68 + 0.980e3 * lmd1_80 - 0.20e2 * t93 - 0.1e4 * lmd2_80;
  out[7] = -0.20e2 * oc1_80;
  out[8] = -0.20e2 * oc1_90;
  out[9] = -0.20e2 * t101 + 0.20e2 * t68 + 0.980e3 * lmd1_100 - 0.20e2 * t104 - 0.1e4 * lmd2_100;
  out[10] = -0.20e2 * oc1_110;
  out[11] = -0.20e2 * oc1_120;
}
void MPC_Ax (
  double *x0,
  double *Uvec,
  double *w,
  double *Udot,
  double *xd,
  double *ud,
  double *out,
  double Tp)
{
  double X1_100;
  double X1_30;
  double X1_40;
  double X1_50;
  double X1_60;
  double X1_70;
  double X1_80;
  double X1_90;
  double X2_100;
  double X2_30;
  double X2_40;
  double X2_50;
  double X2_60;
  double X2_70;
  double X2_80;
  double X2_90;
  double iv1_10;
  double iv2_10;
  double lmd1_30;
  double lmd1_40;
  double lmd1_50;
  double lmd1_60;
  double lmd1_70;
  double lmd1_80;
  double lmd1_90;
  double lmd2_30;
  double lmd2_40;
  double lmd2_50;
  double lmd2_60;
  double lmd2_70;
  double lmd2_80;
  double lmd2_90;
  double t1;
  double t10;
  double t101;
  double t102;
  double t105;
  double t108;
  double t112;
  double t113;
  double t119;
  double t120;
  double t126;
  double t127;
  double t133;
  double t134;
  double t16;
  double t173;
  double t179;
  double t182;
  double t189;
  double t195;
  double t198;
  double t2;
  double t205;
  double t211;
  double t214;
  double t22;
  double t221;
  double t227;
  double t230;
  double t28;
  double t29;
  double t3;
  double t31;
  double t32;
  double t34;
  double t36;
  double t4;
  double t40;
  double t61;
  double t66;
  double t68;
  double t69;
  double t72;
  double t75;
  double t79;
  double t80;
  double t83;
  double t86;
  double t90;
  double t91;
  double t94;
  double t97;
  double lmd1_100;
  double lmd2_100;
  iv1_10 = x0[1];
  t1 = x0[0];
  t2 = 2 * iv1_10;
  t3 = Uvec[0];
  t4 = w[0];
  X1_30 = t1 + Tp * iv1_10 / 4;
  X1_40 = iv1_10 + Tp * (-t1 - t2 + t3 + t4) / 4;
  t10 = Uvec[3];
  X1_50 = X1_30 + Tp * X1_40 / 4;
  X1_60 = X1_40 + Tp * (-X1_30 - 2 * X1_40 + t10 + t4) / 4;
  t16 = Uvec[6];
  X1_70 = X1_50 + Tp * X1_60 / 4;
  X1_80 = X1_60 + Tp * (-X1_50 - 2 * X1_60 + t16 + t4) / 4;
  t22 = Uvec[9];
  X1_90 = X1_70 + Tp * X1_80 / 4;
  X1_100 = X1_80 + Tp * (-X1_70 - 2 * X1_80 + t22 + t4) / 4;
  t28 = xd[0];
  t29 = t28 * 0.151375238638532444e0;
  t31 = xd[1];
  t32 = t31 * 0.327525008726796081e-15;
  lmd1_90 = X1_90 * 0.151375238638532444e0 - t29 + X1_100 * 0.327525008726796081e-15 - t32;
  t34 = t28 * 0.327525008726796081e-15;
  t36 = t31 * 0.151375238638532250e0;
  lmd1_100 = X1_90 * 0.327525008726796081e-15 - t34 + X1_100 * 0.151375238638532250e0 - t36;
  lmd1_70 = lmd1_90 - Tp * lmd1_100 / 4;
  t40 = 0.2e1 * t31;
  lmd1_80 = lmd1_100 + Tp * (0.2e1 * X1_80 - t40 + lmd1_90 - 2 * lmd1_100) / 4;
  lmd1_50 = lmd1_70 - Tp * lmd1_80 / 4;
  lmd1_60 = lmd1_80 + Tp * (0.2e1 * X1_60 - t40 + lmd1_70 - 2 * lmd1_80) / 4;
  lmd1_30 = lmd1_50 - Tp * lmd1_60 / 4;
  lmd1_40 = lmd1_60 + Tp * (0.2e1 * X1_40 - t40 + lmd1_50 - 2 * lmd1_60) / 4;
  t61 = 0.2e1 * iv1_10;
  t66 = 0.1643203912e-1 * t3;
  t68 = 0.1643203912e-1 * ud[0];
  t69 = Uvec[2];
  t72 = Uvec[1];
  t75 = t72 * t72;
  t79 = 0.1643203912e-1 * t10;
  t80 = Uvec[5];
  t83 = Uvec[4];
  t86 = t83 * t83;
  t90 = 0.1643203912e-1 * t16;
  t91 = Uvec[8];
  t94 = Uvec[7];
  t97 = t94 * t94;
  t101 = 0.1643203912e-1 * t22;
  t102 = Uvec[11];
  t105 = Uvec[10];
  t108 = t105 * t105;
  iv2_10 = iv1_10;
  t112 = Udot[0];
  t113 = 0.1e-2 * t112;
  X2_30 = t1 + Tp * iv2_10 / 4;
  X2_40 = iv2_10 + Tp * (-t1 - t2 + t3 + t113 + t4) / 4;
  t119 = Udot[3];
  t120 = 0.1e-2 * t119;
  X2_50 = X2_30 + Tp * X2_40 / 4;
  X2_60 = X2_40 + Tp * (-X2_30 - 2 * X2_40 + t10 + t120 + t4) / 4;
  t126 = Udot[6];
  t127 = 0.1e-2 * t126;
  X2_70 = X2_50 + Tp * X2_60 / 4;
  X2_80 = X2_60 + Tp * (-X2_50 - 2 * X2_60 + t16 + t127 + t4) / 4;
  t133 = Udot[9];
  t134 = 0.1e-2 * t133;
  X2_90 = X2_70 + Tp * X2_80 / 4;
  X2_100 = X2_80 + Tp * (-X2_70 - 2 * X2_80 + t22 + t134 + t4) / 4;
  lmd2_90 = X2_90 * 0.151375238638532444e0 - t29 + X2_100 * 0.327525008726796081e-15 - t32;
  lmd2_100 = X2_90 * 0.327525008726796081e-15 - t34 + X2_100 * 0.151375238638532250e0 - t36;
  lmd2_70 = lmd2_90 - Tp * lmd2_100 / 4;
  lmd2_80 = lmd2_100 + Tp * (0.2e1 * X2_80 - t40 + lmd2_90 - 2 * lmd2_100) / 4;
  lmd2_50 = lmd2_70 - Tp * lmd2_80 / 4;
  lmd2_60 = lmd2_80 + Tp * (0.2e1 * X2_60 - t40 + lmd2_70 - 2 * lmd2_80) / 4;
  lmd2_30 = lmd2_50 - Tp * lmd2_60 / 4;
  lmd2_40 = lmd2_60 + Tp * (0.2e1 * X2_40 - t40 + lmd2_50 - 2 * lmd2_60) / 4;
  t173 = t69 + 0.1e-2 * Udot[2];
  t179 = t72 + 0.1e-2 * Udot[1];
  t182 = t179 * t179;
  t189 = t80 + 0.1e-2 * Udot[5];
  t195 = t83 + 0.1e-2 * Udot[4];
  t198 = t195 * t195;
  t205 = t91 + 0.1e-2 * Udot[8];
  t211 = t94 + 0.1e-2 * Udot[7];
  t214 = t211 * t211;
  t221 = t102 + 0.1e-2 * Udot[11];
  t227 = t105 + 0.1e-2 * Udot[10];
  t230 = t227 * t227;
  out[0] = 0.1643203912e-1 * t112 + 0.1e4 * lmd2_40 + 0.2e4 * t173 * (t3 + t113) - 0.2e4 * t69 * t3 - 0.1e4 * lmd1_40;
  out[1] = 0.2e4 * t173 * t179 - 0.2e4 * t69 * t72;
  out[2] = 0.1e4 * t182 + 0.1e4 * (t3 + t113 - 7) * (t3 + t113 + 7) - 0.1e4 * t75 - 0.1e4 * (t3 - 7) * (t3 + 7);
  out[3] = 0.1643203912e-1 * t119 + 0.1e4 * lmd2_60 + 0.2e4 * t189 * (t10 + t120) - 0.2e4 * t80 * t10 - 0.1e4 * lmd1_60;
  out[4] = 0.2e4 * t189 * t195 - 0.2e4 * t80 * t83;
  out[5] = 0.1e4 * t198 + 0.1e4 * (t10 + t120 - 7) * (t10 + t120 + 7) - 0.1e4 * t86 - 0.1e4 * (t10 - 7) * (t10 + 7);
  out[6] = 0.1643203912e-1 * t126 + 0.1e4 * lmd2_80 + 0.2e4 * t205 * (t16 + t127) - 0.2e4 * t91 * t16 - 0.1e4 * lmd1_80;
  out[7] = 0.2e4 * t205 * t211 - 0.2e4 * t91 * t94;
  out[8] = 0.1e4 * t214 + 0.1e4 * (t16 + t127 - 7) * (t16 + t127 + 7) - 0.1e4 * t97 - 0.1e4 * (t16 - 7) * (t16 + 7);
  out[9] = 0.1643203912e-1 * t133 + 0.1e4 * lmd2_100 + 0.2e4 * t221 * (t22 + t134) - 0.2e4 * t102 * t22 - 0.1e4 * lmd1_100;
  out[10] = 0.2e4 * t221 * t227 - 0.2e4 * t102 * t105;
  out[11] = 0.1e4 * t230 + 0.1e4 * (t22 + t134 - 7) * (t22 + t134 + 7) - 0.1e4 * t108 - 0.1e4 * (t22 - 7) * (t22 + 7);
}
void LinearSolver (
  double *b,
  double *x,
  double *Err,
  double *xh,
  double *Uvec,
  double *w,
  double *xeq,
  double *ueq,
  double Tp)
{
  int i;
  int j;
  int k;
  double rho;
  double nu;
  double cvec[5];
  double svec[5];
  double gvec[6];
  double tmpvec[12];
  double hmat[6][5];
  double vmat[12][6];
  double vmatk[12];
  double temp;
  double r;
  double r1;
  double r2;
  cvec[0] = 0;
  cvec[1] = 0;
  cvec[2] = 0;
  cvec[3] = 0;
  cvec[4] = 0;
  svec[0] = 0;
  svec[1] = 0;
  svec[2] = 0;
  svec[3] = 0;
  svec[4] = 0;
  gvec[0] = 0;
  gvec[1] = 0;
  gvec[2] = 0;
  gvec[3] = 0;
  gvec[4] = 0;
  gvec[5] = 0;
  tmpvec[0] = 0;
  tmpvec[1] = 0;
  tmpvec[2] = 0;
  tmpvec[3] = 0;
  tmpvec[4] = 0;
  tmpvec[5] = 0;
  tmpvec[6] = 0;
  tmpvec[7] = 0;
  tmpvec[8] = 0;
  tmpvec[9] = 0;
  tmpvec[10] = 0;
  tmpvec[11] = 0;
  hmat[0][0] = 0;
  hmat[0][1] = 0;
  hmat[0][2] = 0;
  hmat[0][3] = 0;
  hmat[0][4] = 0;
  hmat[1][0] = 0;
  hmat[1][1] = 0;
  hmat[1][2] = 0;
  hmat[1][3] = 0;
  hmat[1][4] = 0;
  hmat[2][0] = 0;
  hmat[2][1] = 0;
  hmat[2][2] = 0;
  hmat[2][3] = 0;
  hmat[2][4] = 0;
  hmat[3][0] = 0;
  hmat[3][1] = 0;
  hmat[3][2] = 0;
  hmat[3][3] = 0;
  hmat[3][4] = 0;
  hmat[4][0] = 0;
  hmat[4][1] = 0;
  hmat[4][2] = 0;
  hmat[4][3] = 0;
  hmat[4][4] = 0;
  hmat[5][0] = 0;
  hmat[5][1] = 0;
  hmat[5][2] = 0;
  hmat[5][3] = 0;
  hmat[5][4] = 0;
  vmat[0][0] = 0;
  vmat[0][1] = 0;
  vmat[0][2] = 0;
  vmat[0][3] = 0;
  vmat[0][4] = 0;
  vmat[0][5] = 0;
  vmat[1][0] = 0;
  vmat[1][1] = 0;
  vmat[1][2] = 0;
  vmat[1][3] = 0;
  vmat[1][4] = 0;
  vmat[1][5] = 0;
  vmat[2][0] = 0;
  vmat[2][1] = 0;
  vmat[2][2] = 0;
  vmat[2][3] = 0;
  vmat[2][4] = 0;
  vmat[2][5] = 0;
  vmat[3][0] = 0;
  vmat[3][1] = 0;
  vmat[3][2] = 0;
  vmat[3][3] = 0;
  vmat[3][4] = 0;
  vmat[3][5] = 0;
  vmat[4][0] = 0;
  vmat[4][1] = 0;
  vmat[4][2] = 0;
  vmat[4][3] = 0;
  vmat[4][4] = 0;
  vmat[4][5] = 0;
  vmat[5][0] = 0;
  vmat[5][1] = 0;
  vmat[5][2] = 0;
  vmat[5][3] = 0;
  vmat[5][4] = 0;
  vmat[5][5] = 0;
  vmat[6][0] = 0;
  vmat[6][1] = 0;
  vmat[6][2] = 0;
  vmat[6][3] = 0;
  vmat[6][4] = 0;
  vmat[6][5] = 0;
  vmat[7][0] = 0;
  vmat[7][1] = 0;
  vmat[7][2] = 0;
  vmat[7][3] = 0;
  vmat[7][4] = 0;
  vmat[7][5] = 0;
  vmat[8][0] = 0;
  vmat[8][1] = 0;
  vmat[8][2] = 0;
  vmat[8][3] = 0;
  vmat[8][4] = 0;
  vmat[8][5] = 0;
  vmat[9][0] = 0;
  vmat[9][1] = 0;
  vmat[9][2] = 0;
  vmat[9][3] = 0;
  vmat[9][4] = 0;
  vmat[9][5] = 0;
  vmat[10][0] = 0;
  vmat[10][1] = 0;
  vmat[10][2] = 0;
  vmat[10][3] = 0;
  vmat[10][4] = 0;
  vmat[10][5] = 0;
  vmat[11][0] = 0;
  vmat[11][1] = 0;
  vmat[11][2] = 0;
  vmat[11][3] = 0;
  vmat[11][4] = 0;
  vmat[11][5] = 0;
  vmatk[0] = 0;
  vmatk[1] = 0;
  vmatk[2] = 0;
  vmatk[3] = 0;
  vmatk[4] = 0;
  vmatk[5] = 0;
  vmatk[6] = 0;
  vmatk[7] = 0;
  vmatk[8] = 0;
  vmatk[9] = 0;
  vmatk[10] = 0;
  vmatk[11] = 0;
  MPC_Ax(xh, Uvec, w, x, xeq, ueq, tmpvec, Tp);
  for (i = 1; i <= 12; i++)
    tmpvec[i - 1] = b[i - 1] - tmpvec[i - 1];
  r = 0;
  for (i = 1; i <= 12; i++)
    r = r + tmpvec[i - 1] * tmpvec[i - 1];
  rho = sqrt(r);
  gvec[0] = rho;
  for (i = 2; i <= 5; i++)
    gvec[i - 1] = 0;
  for (i = 1; i <= 12; i++)
    vmat[i - 1][0] = tmpvec[i - 1] / rho;
  for (k = 1; k <= 5; k++)
  {
    for (i = 1; i <= 12; i++)
      vmatk[i - 1] = vmat[i - 1][k - 1];
    MPC_Ax(xh, Uvec, w, vmatk, xeq, ueq, tmpvec, Tp);
    for (i = 1; i <= 12; i++)
      vmat[i - 1][k] = tmpvec[i - 1];
    for (j = 1; j <= k; j++)
    {
      r1 = 0;
      for (i = 1; i <= 12; i++)
        r1 = r1 + vmat[i - 1][j - 1] * vmat[i - 1][k];
      hmat[j - 1][k - 1] = r1;
      for (i = 1; i <= 12; i++)
        vmat[i - 1][k] = -hmat[j - 1][k - 1] * vmat[i - 1][j - 1] + vmat[i - 1][k];
    }
    r2 = 0;
    for (i = 1; i <= 12; i++)
      r2 = r2 + vmat[i - 1][k] * vmat[i - 1][k];
    hmat[k][k - 1] = sqrt(r2);
    if (0.0e0 < hmat[k][k - 1])
      for (i = 1; i <= 12; i++)
        vmat[i - 1][k] = vmat[i - 1][k] / hmat[k][k - 1];
    else
      return;
    for (j = 1; j <= k - 1; j++)
    {
      temp = cvec[j - 1] * hmat[j - 1][k - 1] + svec[j - 1] * hmat[j][k - 1];
      hmat[j][k - 1] = cvec[j - 1] * hmat[j][k - 1] - svec[j - 1] * hmat[j - 1][k - 1];
      hmat[j - 1][k - 1] = temp;
    }
    if (hmat[k][k - 1] == 0.0e0)
    {
      cvec[k - 1] = 0.10e1;
      svec[k - 1] = 0.0e0;
    }
    else if (fabs(hmat[k - 1][k - 1]) < fabs(hmat[k][k - 1]))
    {
      temp = hmat[k - 1][k - 1] / hmat[k][k - 1];
      svec[k - 1] = 0.10e1 / sqrt(0.10e1 + temp * temp);
      cvec[k - 1] = temp * svec[k - 1];
    }
    else
    {
      temp = hmat[k][k - 1] / hmat[k - 1][k - 1];
      cvec[k - 1] = 0.10e1 / sqrt(0.10e1 + temp * temp);
      svec[k - 1] = temp * cvec[k - 1];
    }
    temp = cvec[k - 1] * gvec[k - 1];
    gvec[k] = -svec[k - 1] * gvec[k - 1];
    gvec[k - 1] = temp;
    hmat[k - 1][k - 1] = cvec[k - 1] * hmat[k - 1][k - 1] + svec[k - 1] * hmat[k][k - 1];
    hmat[k][k - 1] = 0;
  }
  for (i = 5; i >= 1; i--)
  {
    nu = gvec[i - 1];
    for (j = i + 1; j <= 5; j++)
      nu = nu - hmat[i - 1][j - 1] * cvec[j - 1];
    cvec[i - 1] = nu / hmat[i - 1][i - 1];
  }
  for (i = 1; i <= 12; i++)
  {
    nu = 0;
    for (j = 1; j <= 5; j++)
      nu = nu + vmat[i - 1][j - 1] * cvec[j - 1];
    x[i - 1] = x[i - 1] + nu;
  }
  MPC_Ax(xh, Uvec, w, x, xeq, ueq, tmpvec, Tp);
  for (i = 1; i <= 12; i++)
    Err[i - 1] = tmpvec[i - 1] - b[i - 1];
}
EXP void M_DECL MPCtrl (
  double *Uvec,
  double *xk,
  double *xdot,
  double *w,
  double *xd,
  double *ud,
  double Tp,
  double t,
  double *dUvec,
  double *Err)
{
  double bvec[12];
  double tp;
  int i;
  bvec[0] = 0;
  bvec[1] = 0;
  bvec[2] = 0;
  bvec[3] = 0;
  bvec[4] = 0;
  bvec[5] = 0;
  bvec[6] = 0;
  bvec[7] = 0;
  bvec[8] = 0;
  bvec[9] = 0;
  bvec[10] = 0;
  bvec[11] = 0;
  for (i = 1; i <= 12; i++)
  {
    dUvec[i - 1] = 0;
    Err[i - 1] = 0;
  }
  tp = Tp * (1 - exp(-0.1e-1 * t));
  MPC_b(xk, Uvec, w, xdot, xd, ud, bvec, tp);
  LinearSolver(bvec, dUvec, Err, xk, Uvec, w, xd, ud, tp);
}
