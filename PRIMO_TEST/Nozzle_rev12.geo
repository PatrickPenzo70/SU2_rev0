// SetFactory("OpenCASCADE");

// =====================================================
// Geometria SinplexPro per SU2 / NEMO
// Unità: metri
// =====================================================

// -------------------------
// Parametri geometrici
// -------------------------
L_in   = 0.020;
L_conv = 0.015;
L_div  = 0.025;
L_out  = 0.020;
L_far  = 0.0055;

x0 = 0.0;
x1 = x0 + L_in;
x2 = x1 + L_conv;
x3 = x2 + L_div;
x4 = x3 + L_out;
x5 = x4;
x6 = x5 + L_far;
x7 = x6 + 6*L_far;

xL = 0.006;

H_in  = 0.006;
H_th  = 0.0035;
H_out = 0.0055;

// -------------------------
// Parametri elettrodo
// -------------------------
L_elec = 0.010;
R_elec = 0.004;
L_tip  = 0.005;

// Posizione iniziale elettrodo
x_elec = 0.012;

x_e0   = x0 + x_elec;
x_etip = x_e0 + L_elec;

// Distanza tra punta e punto di suddivisione dell'asse
gap_tip = 0.001;

// Il punto 3 deve essere davanti alla punta,
// ma non deve essere spostato di x_elec rispetto a x1
x_axis1 = x_etip + gap_tip;

// Controlli geometrici
If (x_etip >= x2)
  Error("La punta dell'elettrodo supera la gola.");
EndIf

If (x_axis1 >= x2)
  Error("Il punto 3 deve trovarsi prima del punto 5.");
EndIf

// -------------------------
// Parametri arco
// -------------------------
R_arc = 0.0008;

// -------------------------
// Dimensioni mesh
// -------------------------
lc_in  = 0.0012;
lc_th  = 0.0004;
lc_tip = 0.00015;
lc_out = 0.0010;

// -------------------------
// Parete superiore
// -------------------------
Point(2)  = {x_e0,    H_in,  0, lc_in};
Point(4)  = {x1-xL,   H_in,  0, lc_in};
Point(6)  = {x2-xL,   H_th,  0, lc_th};
Point(8)  = {x3,      H_out, 0, lc_out};
Point(10) = {x4,      H_out, 0, lc_out};

// -------------------------
// Dominio esterno
// -------------------------
Point(11) = {x5, 2*H_out, 0, lc_out};
Point(12) = {x6, 2*H_out, 0, lc_out};
Point(13) = {x7, 2*H_out, 0, lc_out};
Point(14) = {x7, 0.0,     0, lc_out};

Point(9) = {x4, 0.0, 0, lc_out};
Point(7) = {x3, 0.0, 0, lc_out};

// -------------------------
// Elettrodo
// -------------------------
Point(20) = {x_e0, 0.0,    0, lc_th};
Point(21) = {x_e0, R_elec, 0, lc_th};

// Inizio punta arrotondata
x_tip0 = x_etip - L_tip;

Point(22) = {x_tip0, R_elec, 0, lc_tip};
Point(24) = {x_tip0, 0.0,    0, lc_tip};
Point(23) = {x_etip, 0.0,    0, lc_tip};

// Punto ausiliario sull'asse maggiore dell'ellisse
Point(25) = {x_etip, 0.0, 0, lc_tip};

// -------------------------
// Arco e asse
// -------------------------
Point(50) = {x_etip, R_arc, 0, lc_tip};
Point(51) = {x3,     R_arc, 0, lc_th};

Point(3) = {x_axis1, 0.0, 0, lc_tip};
Point(5) = {x2,      0.0, 0, lc_th};

// -------------------------
// Pareti ugello
// -------------------------
Line(5) = {2, 4};
Line(6) = {4, 6};
Line(7) = {6, 8};
Line(8) = {8, 10};

// -------------------------
// Elettrodo
// -------------------------
Line(21) = {21, 22};

// Ellisse: inizio, centro, punto asse maggiore, fine
Ellipse(22) = {22, 24, 25, 23};

Line(9) = {21, 2};

// -------------------------
// Zona arco
// -------------------------
Line(50) = {23, 50};
Line(51) = {50, 51};
Line(53) = {51, 7};

Line(54) = {23, 3};
Line(55) = {3, 5};
Line(56) = {5, 7};

// -------------------------
// Dominio esterno
// -------------------------
Line(10) = {9, 10};
Line(11) = {7, 9};

Circle(12) = {10, 11, 12};

Line(13) = {12, 13};
Line(14) = {13, 14};
Line(15) = {9, 14};

// -------------------------
// Superficie zona arco
// -------------------------
Curve Loop(101) = {
  50,
  51,
  53,
  -56,
  -55,
  -54
};

Plane Surface(501) = {101};

// -------------------------
// Superficie fluido interno
// -------------------------
Curve Loop(100) = {
  9,
  5,
  6,
  7,
  8,
  -10,
  -11,
  -53,
  -51,
  -50,
  -22,
  -21
};

Plane Surface(200) = {100};

// -------------------------
// Plume esterno
// -------------------------
Curve Loop(300) = {
  10,
  12,
  13,
  14,
  -15
};

Plane Surface(400) = {300};

// Rende conformi le superfici adiacenti
Coherence;

// -------------------------
// Raffinamento arco e punta
// -------------------------
Field[1] = Distance;
Field[1].CurvesList = {22, 50, 51};

Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = 0.00012;
Field[2].SizeMax = 0.0012;
Field[2].DistMin = 0.0003;
Field[2].DistMax = 0.004;

// -------------------------
// Raffinamento gola
// -------------------------
Field[3] = Distance;
Field[3].CurvesList = {6, 7};

Field[4] = Threshold;
Field[4].InField = 3;
Field[4].SizeMin = 0.00025;
Field[4].SizeMax = 0.001;
Field[4].DistMin = 0.0005;
Field[4].DistMax = 0.003;

Field[5] = Min;
Field[5].FieldsList = {2, 4};

Background Field = 5;

// -------------------------
// Gruppi fisici
// -------------------------
Physical Surface("FLUID") = {200, 400, 501};

Physical Curve("INFLOW")    = {9};
Physical Curve("OUTFLOW")   = {13, 14};
Physical Curve("WALL1")     = {5, 6, 7, 8};
Physical Curve("SYMMETRY")  = {11, 15, 54, 55, 56};
Physical Curve("ELECTRODE") = {21, 22};
Physical Curve("WALL2")     = {12};

// -------------------------
// Opzioni mesh
// -------------------------
Mesh.Algorithm = 6;
Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.CharacteristicLengthFromPoints = 1;
Mesh.CharacteristicLengthFromCurvature = 1;

Mesh 2;

