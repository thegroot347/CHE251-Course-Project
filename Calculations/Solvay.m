clear all; clc;

%intial guess
F2  = 2400;
F3  = 1500;
F4  = 520;
F5  = 500;
F6  = 120;
F7  = 200;

F8  = 230;
F9  = 150;
F10 = 115;
F11 = 280;

F13 = 180;
F14 = 120;
F15 = 170;
F16 = 190;
F17 = 30;

F18 = 110;
F19 = 135;
F20 = 130;
F21 = 115;
F22 = 65;

F23 = 270;
F    = 1900;

F25 = 270;
F26 = 65;
F27 = 110;
F28 = 80;

F29 = 55;
F30 = 120;
F31 = 350;
F32 = 110;
F33 = 115;
F34 = 25;

x1  = 0.22;
x2  = 0.04;
x3  = 0.30;
x4  = 0.38;
x5  = 0.27;
x6  = 0.28;

x7  = 0.40;
x8  = 0.12;
x9  = 0.32;
x10 = 0.48;
x11 = 0.39;
x13 = 0.17;

y2  = 0.24;
y5  = 0.33;
y6  = 0.29;
y9  = 0.29;
y11 = 0.30;

z2  = 0.20;
z6  = 0.14;
z9  = 0.000006;
z11 = 0.21;

u6  = 0.08;
u9  = 0.13;
w6  = 0.09;

e1  = 18;
e2  = 44;

x0 = [F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F13,F14,F15,F16,F17,F18,F19,F20,F21,...
      F22,F23,F,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,...
      x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x13,...
      y2,y5,y6,y9,y11,z2,z6,z9,z11,u6,u9,w6,e1,e2];

opts = optimoptions('fsolve','Display','off','MaxFunctionEvaluations',20000);
[x, fval, exitflag] = fsolve(@solvay,x0,opts);

%% ============================================================
% SOLUTION SUMMARY
%% ============================================================

names = {...
'F2','F3','F4','F5','F6','F7','F8','F9','F10','F11',...
'F13','F14','F15','F16','F17','F18','F19','F20','F21','F22',...
'F23','F','F25','F26','F27','F28','F29','F30','F31','F32',...
'F33','F34',...
'x1','x2','x3','x4','x5','x6','x7','x8','x9','x10','x11','x13',...
'y2','y5','y6','y9','y11',...
'z2','z6','z9','z11',...
'u6','u9','w6',...
'e1','e2'};

fprintf('\n');
fprintf('============================================================\n');
fprintf('SOLVAY PROCESS MATERIAL BALANCE RESULTS\n');
fprintf('============================================================\n');

fprintf('------------------------------------------------------------\n');
fprintf('| %-10s | %-30s |\n','Variable','Value');
fprintf('------------------------------------------------------------\n');

for i=1:length(names)
    fprintf('| %-10s | %-30.12g |\n',names{i},x(i));
end

fprintf('------------------------------------------------------------\n');

fprintf('\n');
fprintf('Reaction Extents\n');
fprintf('------------------------------------------------------------\n');
fprintf('| %-20s | %-15.6f |\n','e1',x(57));
fprintf('| %-20s | %-15.6f |\n','e2',x(58));
fprintf('------------------------------------------------------------\n');

%% ENERGY BALANCE 
F2  = x(1);  F3  = x(2);  F4  = x(3);  F5  = x(4);  F6  = x(5);
F7  = x(6);  F8  = x(7);  F9  = x(8);  F10 = x(9);  F11 = x(10);
F13 = x(11); F14 = x(12); F15 = x(13); F16 = x(14); F17 = x(15);
F18 = x(16); F19 = x(17); F20 = x(18); F21 = x(19); F22 = x(20);
F23 = x(21); F = x(22); F25 = x(23); F26 = x(24); F27 = x(25);
F28 = x(26); F29 = x(27); F30 = x(28); F31 = x(29); F32 = x(30);
F33 = x(31); F34 = x(32);x6=x(38);x9 = x(41);y9 = x(48);
z9 = x(52);
u9 = x(55);e1=x(57);

extent_kiln   = F;   % extent of CaCO3 -> CaO + CO2 (mol/h)
extent_lime   = F18;   % lime dissolution / CaO consumption (mol/h)
extent_NH3abs = F7;    % NH3 absorption into brine (mol/h)
extent_CO2abs = e1;   % CO2 absorption (mol/h) (to CO2 absorber / carbonator)
extent_solvay = F11*x6;   % main Solvay tower reaction extent (NaHCO3 produced) (mol/h)
extent_filter = F29;   % NaHCO3 washed/filtered (mol/h)
extent_calc   = F20;   % calciner extent (2 NaHCO3 -> Na2CO3 + CO2) (mol/h)
extent_mon    = F22;   % monohydrate step extent (mol/h)
extent_dist   = F16*(1-x9-y9-z9-u9);   % distiller extent (recovery of NH3) (mol/h)
%  Na2CO3 production stream is F24 
Na2CO3_prod_mol_per_h = 1000;    % mol/h of Na2CO3 produced (assumption)


% Cp (J/mol·K)
Cp = struct('CaCO3',115,'CaO',68,'CO2',50,'NaHCO3',102,'Na2CO3',120,...
            'H2O',75,'NH3',37,'NaCl',50,'NH4Cl',84);

% ΔH°r at 25 °C (kJ/mol) to J/mol below
dH25 = struct(...
    'kiln',       +178, ...
    'lime',       -64,  ...
    'NH3abs',     -35,  ...
    'CO2abs',     -45,  ...
    'solvay',     -85,  ...
    'filter',     -10,  ...
    'calciner',   +135, ...
    'monohyd',    -41,  ...
    'distiller',  +75,  ...
    'compressor', +10   ...
);
fields = fieldnames(dH25);
for k = 1:length(fields)
    dH25.(fields{k}) = dH25.(fields{k})*1e3; % J/mol
end

% Temperatures (C) used for Kirchhoff correction 
T = struct('kiln',1000,'lime',100,'NH3abs',30,'CO2abs',40,'tower',50,...
           'filter',25,'calciner',200,'monohyd',40,'distiller',100,'compressor',50);

% Kirchhoff correction: dH(T) = dH25 + sum(nu*Cp)*(T-25)
corr_dH = @(dH0,nu,Cp_arr,Tunit) dH0 + sum(nu.*Cp_arr)*(Tunit-25);

% nu=stoichometric coefficients
% Kiln: CaCO3 -> CaO + CO2
nu_kiln = [-1 +1 +1];
Cp_kiln = [Cp.CaCO3 Cp.CaO Cp.CO2];

% Lime dissolver: CaO + H2O -> Ca(OH)2  (approx treated)
nu_lime = [-1 -1 +1]; % (CaO, H2O, Ca(OH)2)
Cp_lime = [Cp.CaO Cp.H2O 90];

% NH3 absorption (NH3 + H2O -> NH4OH)
nu_NH3 = [-1 -1 +1]; % (NH3, H2O, NH4OH)
Cp_NH3 = [Cp.NH3 Cp.H2O 70];

% CO2 absorption (CO2 + NH3 + H2O -> NH4HCO3)
nu_CO2 = [-1 -1 -1 +1];
Cp_CO2 = [Cp.CO2 Cp.NH3 Cp.H2O Cp.NaHCO3];

% Solvay tower (NaCl + NH3 + CO2 + H2O -> NaHCO3 + NH4Cl)
nu_tower = [-1 -1 -1 -1 +1 +1];
Cp_tower = [Cp.NaCl Cp.NH3 Cp.CO2 Cp.H2O Cp.NaHCO3 Cp.NH4Cl];

% Filter/crystallizer (NaHCO3 crystallization)
nu_filter = [-1 +1];
Cp_filter = [Cp.NaHCO3 Cp.NaHCO3];

% Calciner: 2 NaHCO3 -> Na2CO3 + H2O + CO2  
nu_calc = [-2 +1 +1 +1];
Cp_calc = [Cp.NaHCO3 Cp.Na2CO3 Cp.H2O Cp.CO2];

% Monohydrate mixer: Na2CO3 + H2O -> Na2CO3·H2O
nu_mon = [-1 -1 +1];
Cp_mon = [Cp.Na2CO3 Cp.H2O 130];

% Distiller (approx. heat for NH3 recovery/distillation)
nu_dist = [-2 -1 +2 +1 +2];
Cp_dist = [Cp.NH4Cl 90 Cp.NH3 70 Cp.H2O];

% Compressor (CO2 compression work approx.)
nu_comp = [1];
Cp_comp = [Cp.CO2];


% Compute Q (J/h) for each unit using extents from mass balance
Q_kiln  = extent_kiln * corr_dH(dH25.kiln,  nu_kiln, Cp_kiln, T.kiln);
Q_lime  = extent_lime * corr_dH(dH25.lime,  nu_lime, Cp_lime, T.lime);
Q_NH3   = extent_NH3abs * corr_dH(dH25.NH3abs,nu_NH3, Cp_NH3, T.NH3abs);
Q_CO2   = extent_CO2abs * corr_dH(dH25.CO2abs,nu_CO2, Cp_CO2, T.CO2abs);
Q_tower = extent_solvay * corr_dH(dH25.solvay, nu_tower, Cp_tower, T.tower);
Q_filter= extent_filter * corr_dH(dH25.filter, nu_filter, Cp_filter, T.filter);
Q_calc  = extent_calc * corr_dH(dH25.calciner,nu_calc, Cp_calc, T.calciner);
Q_mon   = extent_mon * corr_dH(dH25.monohyd,nu_mon, Cp_mon, T.monohyd);
Q_dist  = extent_dist * corr_dH(dH25.distiller,nu_dist, Cp_dist, T.distiller);

%COMPRESSOR
Q_comp  = F10 * corr_dH(dH25.compressor, nu_comp, Cp_comp, T.compressor);

%FINAL ENERGY VALUES
Q_units = [Q_kiln, Q_lime, Q_NH3, Q_CO2, Q_tower, Q_filter, Q_calc, Q_mon, Q_dist, Q_comp];
names = {'Kiln','Lime Dissolver','NH3 Absorber','CO2 Absorber','Solvay Tower','Filter','Calciner','Monohydrate','Distiller','CO2 Compressor'};

fprintf('\nEnergy Duties by Unit (GJ/h):\n');
for i=1:length(Q_units)
    fprintf('%-18s : %+10.4f\n', names{i}, Q_units(i)/1e9);
end

Q_total = sum(Q_units);
disp(Q_total)
% Heat recovery assumption (40% of exothermic heat recovered)
Q_exo = sum(Q_units(Q_units<0));
Q_recovery = 0.4 * abs(Q_exo);
Q_net = Q_total + Q_recovery;

% Compute energy per tonne Na2CO3 produced ( Na2CO3 production is F24 mol/h)
M_Na2CO3 = 105.99; % g/mol
t_per_h = Na2CO3_prod_mol_per_h * M_Na2CO3 / 1e6; % t/h
Q_total_GJh = Q_total/1e9;
Q_net_GJh = Q_net/1e9;
energy_per_tonne_gross = Q_total_GJh / t_per_h;
energy_per_tonne_net   = Q_net_GJh / t_per_h;

fprintf('---------------------------------------------\n');
fprintf('Total gross energy duty (GJ/h): %+10.4f\n', Q_total_GJh);
fprintf('Recovered heat (40%% exotherm) (GJ/h): %+10.4f\n', Q_recovery/1e9);
fprintf('Net energy duty (GJ/h): %+10.4f\n', Q_net_GJh);
fprintf('Na2CO3 production rate (t/h): %+10.4f\n', t_per_h);
fprintf('Energy per tonne Na2CO3 (gross): %+10.4f GJ/t\n', energy_per_tonne_gross);
fprintf('Energy per tonne Na2CO3 (net):   %+10.4f GJ/t\n', energy_per_tonne_net);
fprintf('---------------------------------------------\n');
%SOLVAY MASS BALANCE
function S = solvay(x)

% Unpack
F2=x(1); F3=x(2); F4=x(3); F5=x(4); F6=x(5); F7=x(6); F8=x(7); F9=x(8);
F10=x(9); F11=x(10); F13=x(11); F14=x(12); F15=x(13); F16=x(14); F17=x(15);
F18=x(16); F19=x(17); F20=x(18); F21=x(19); F22=x(20); F23=x(21); F=x(22);
F25=x(23); F26=x(24); F27=x(25); F28=x(26); F29=x(27); F30=x(28); F31=x(29);
F32=x(30); F33=x(31); F34=x(32);

x1=x(33); x2=x(34); x3=x(35); x4=x(36); x5=x(37); x6=x(38); x7=x(39);
x8=x(40); x9=x(41); x10=x(42); x11=x(43); x13=x(44);

y2=x(45); y5=x(46); y6=x(47); y9=x(48); y11=x(49);
z2=x(50); z6=x(51); z9=x(52); z11=x(53);
u6=x(54); u9=x(55); w6=x(56);
e1=x(57); e2=x(58);



x12=0.25; y12=0.25; z12=0.25;

S = zeros(58,1);

%REACTIONS
F24=1000;%basis
% Air + NaCl
S(1)= x1 - 0.5;
S(2)= 0.21*F2 - F*(1-x1) - F3*z2;
S(3)= F*x1 - F3*x2;
S(4)= 2*F*x1 - F3*y2;
S(5)= F7*x4 - F8*x5;
S(6)= F3*(1-x2-y2-z2) - 0.79*F2;

% Kiln separator
S(7)= F3*x2 - F27;
S(8)= F3*y2 - F5;
S(9)= F3*z2 - F4*x3;
S(10)=F3*(1-x2-y2-z2) - F4*(1-x3);

% CaO recycle
S(11)=F6 - F27;
S(12)=F18 - F27;

% Lime dissolver
S(13)=3*58.44*x4 - 18.01528*(1-x4);

% Absorber
S(14)=F17*x8 + F18 - F28*x13;
S(15)=F7*(1-x4) - F8*y5;
S(16)=F33 - F8*(1-x5-y5);

% CO2 path
S(17)=F5 + F10 - F9;

% Solvay tower
S(18)=F28*x13 - e1 - F16*z9;
S(19)=F28*(1-x13) - 2*e1 - F16*u9;
S(20)=F16*(1-x9-y9-z9-u9) - 2*e1;
S(21)=F16*x9 - e1;
S(22)=F16*y9 - e1;
S(23)=0.95*F28*(1-x13) - 2*e1;

% NH4Cl / NaCl separator
S(24)=F16 - F14 - F29 - F33;
S(25)=F16*x9 - F14*x7;
S(26)=F16*y9 - F14*(1-x7);
S(27)=F16*z9 - F29*x8;
S(28)=F16*u9 - F29*(1-x8);

% Calciner feed
S(29)=F29 - F17 - F30;

% Monohydrate loop
S(30)=F17 + F18 + F19 - F28;
S(31)=F17*x8 + F18 - F28*x13;

% Distiller
S(32)=F31*z12 - e2 - F11*u6;
S(33)=F31*y12 - e2 - F11*w6;
S(34)=F31*(1-x12-y12-z12) - e2 - F11*(1-x6-y6-z6-w6-u6);
S(35)=F31*x12 - e2 - F11*z6;
S(36)=F11*x6 - e2;
S(37)=F11*y6 - e2;
S(38)=0.90*F31*x12 - e2;

% NH3 recycle
S(39)=F11 - F15 - F32;
S(40)=F11*x6 - F15*x10;
S(41)=F11*y6 - F15*(1-x10);
S(42)=F11*z6 - F32*x11;
S(43)=F11*w6 - F32*y11;
S(44)=F11*u6 - F32*z11;

% CaCl2 path
S(45)=F13 + F34 - F32;

% Water balance
S(46)=F8 + F13 + F9 - F31;
S(47)=F8*x5 + F13*x11 - F31*x12;
S(48)=F8*y5 + F13*y11 - F31*y12;
S(49)=F8*(1-x5-y5) + F13*z11 - F31*z12;

% Na2CO3 loop
S(50)=F15 - F19 - F20;
S(51)=F15*x10 - F19;

% Calcination stoich
S(52)=F20 - 2*F22;
S(53)=2*F21 - F20;
S(54)=F20 - 2*F10;

% Soda ash section
S(55)=F22 - F24;
S(56)=F23 - 10*F22;
S(57)=F24 - F26;
S(58)=F25 - 10*F24;

end
