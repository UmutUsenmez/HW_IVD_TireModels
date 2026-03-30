% --- 1. General Input Parameters ---
Fz_N = [2000, 4000, 6000, 8000]; % Vertical loads [N]
Fz_kN = Fz_N / 1000;             % Vertical loads [kN]

alpha_deg = linspace(-25, 25, 201); % Slip angle range [deg]
alpha_rad = deg2rad(alpha_deg);     % Slip angle range [rad]

kappa = linspace(-1, 1, 201);       % Slip ratio range [-1 to 1]

% --- 2. Magic Formula Parameters (from Bakker et al. 1987) ---

% Lateral force parameters
a_Fy = [-22.1, 1011, 1078, 1.82, 0.208, 0.000, 0.-354, 0.707]; 
c_Fy = 1.30;
% Longitudinal force parameters
a_Fx = [-21.3, 1144, 49.6, 226, 0.069, -0.006, 0.056, 0.486];
c_Fx = 1.65;
% Self-aligning torque parameters
a_Mz = [-2.72, -2.28, -1.86, -2.73, 0.110, -0.070, 0.643, -4.04];
c_Mz = 2.40;

% --- 3. Dugoff & Fiala Model Parameters ---
mu_0 = 0.85;               % Peak static tire/road friction coeff.
U = 60/3.6 ;               % Longitudinal velocity [m/s]
A_s  = 0.0115;             % Friction reduction factor
Tw = 0.284 ;               % Fiala's tire model parameter