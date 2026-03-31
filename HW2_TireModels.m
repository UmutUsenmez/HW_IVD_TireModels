% --- 1. General Input Parameters ---

Fz_N = [2000, 4000, 6000, 8000]; % Vertical loads [N]
Fz_kN = Fz_N / 1000;             % Vertical loads [kN]
alpha_deg = linspace(-25, 25, 201); % Slip angle range [deg]
alpha_rad = deg2rad(alpha_deg);     % Slip angle range [rad]
kappa = linspace(-1, 1, 201);       % Slip ratio range [-1 to 1]

% --- 2. Magic Formula Parameters (from Bakker et al. 1987) ---

% Lateral force parameters
a_Fy = [-22.1, 1011, 1078, 1.82, 0.208, 0.000, -0.354, 0.707]; 
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

% --- 4. MAGIC FORMULA LONGITUDINAL FORCE (Fx) ---

Fx_magic = zeros(length(Fz_kN),length(kappa));    % empty matrix filled with zeros 
fig_Fx = figure('Name','Magic Formula - Fx', 'Color','w'); % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)    
    fz = Fz_kN(i);        
    % Calculation of coefficients D, E, and B.
    D_fx = a_Fx(1)*fz^2 + a_Fx(2)*fz;
    E_fx = a_Fx(6)*fz^2 + a_Fx(7)*fz + a_Fx(8);
    B_fx = (a_Fx(3) * fz^2 + a_Fx(4) * fz) / (c_Fx * D_fx * exp(a_Fx(5)*fz));
    % Calculation of Phi (Φ) ( we use .* because of kappa is a vector)
    kappa_pct = kappa * 100;
    Phi_fx = (1 - E_fx) .* kappa_pct + (E_fx / B_fx) .* atan(B_fx .* kappa_pct);
    % Calculation of Fx
    Fx_magic(i, :) = D_fx .* sin(c_Fx .* atan(B_fx .* Phi_fx));
    % plotting the graph
    plot(kappa*100,Fx_magic(i,:),"LineWidth",2,'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end

% --- 5. MAGIC FORMULA - LATERAL FORCE (Fy) ---

Fy_magic = zeros(length(Fz_kN), length(alpha_deg));          % empty matrix filled with zeros 
fig_Fy = figure('Name', 'Magic Formula - Fy', 'Color', 'w'); % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz = Fz_kN(i);
    % Calculation of coefficients D, E, and B.
    D_fy = a_Fy(1)*fz^2 + a_Fy(2)*fz;
    E_fy = a_Fy(6)*fz^2 + a_Fy(7)*fz + a_Fy(8);
    B_fy = (a_Fy(3)*sin(a_Fy(4)*atan(a_Fy(5)*fz))) / (c_Fy * D_fy);
    % Calculation of Phi (Φ) ( we use .* because alpha_deg is a vector)
    Phi_fy = (1 - E_fy) .* alpha_deg + (E_fy / B_fy) .* atan(B_fy .* alpha_deg);
    % Calculation of Fy
    Fy_magic(i, :) = D_fy .* sin(c_Fy .* atan(B_fy .* Phi_fy));
    % plotting the graph
    plot(alpha_deg, Fy_magic(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end

% --- 6. MAGIC FORMULA - TORQUE (Mz) ---

Mz_magic = zeros(length(Fz_kN), length(alpha_deg));           % empty matrix filled with zeros
fig_Mz = figure('Name', 'Magic Formula - Mz', 'Color', 'w');  % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz = Fz_kN(i);
    % Calculation of coefficients D, E, and B.
    D_mz = a_Mz(1)*fz^2 + a_Mz(2)*fz;
    E_mz = a_Mz(6)*fz^2 + a_Mz(7)*fz + a_Mz(8);
    B_mz = (a_Mz(3)*fz^2 + a_Mz(4)*fz) / (c_Mz * D_mz * exp(a_Mz(5)*fz));
    % Calculation of Phi (Φ) ( we use .* because alpha_deg is a vector)
    Phi_mz = (1 - E_mz) .* alpha_deg + (E_mz / B_mz) .* atan(B_mz .* alpha_deg);
    % Calculation of Mz
    Mz_magic(i, :) = D_mz .* sin(c_Mz .* atan(B_mz .* Phi_mz));
    % plotting the graph
    plot(alpha_deg, Mz_magic(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end

% --- 7. Graphics Settings ---

% For Fx
figure(fig_Fx);
title ('Magic Formula Tire Model - Fx',"FontWeight","bold");
xlabel ("Slip %","FontWeight","bold");
ylabel ("F_x [N]","FontWeight","bold");
legend("Location","best");
xlim([-100,100])
% For Fy
figure(fig_Fy);
title('Magic Formula Tire Model - Fy', 'FontWeight', 'bold');
xlabel('Slip angle [deg]', 'FontWeight', 'bold');
ylabel('F_y [N]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-25 25]);
% For Mz
figure(fig_Mz);
title('Magic Formula Tire Model - Mz', 'FontWeight', 'bold');
xlabel('Slip angle [deg]', 'FontWeight', 'bold');
ylabel('M_z [Nm]', 'FontWeight', 'bold'); % Since it is torque, its unit is Nm.
legend('Location', 'best');
xlim([-25 25]);

% --- 8. TIRE STIFFNESS CALCULATIONS (Cs and C_alpha) ---
% Stiffness/Resistance values ​​required for Fiala and Dugoff models
% Derived from the slope of the Magic Formula at the origin (B*C*D)

% Empty arrays to hold the results for 4% different loads
C_s = zeros(1, length(Fz_kN));           
C_alpha = zeros(1, length(Fz_kN));
disp('======================================================');
disp('   TIRE STIFFNESS VALUES DERIVED FROM MAGIC FORMULA   ');
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz = Fz_kN(i);
    % 1. Longitudinal Stiffness (C_s)
    % The simplified form of the multiplication B_fx * c_Fx * D_fx in the article is  :
    C_s(i) = ((a_Fx(3) * fz^2 + a_Fx(4) * fz) / exp(a_Fx(5) * fz)) * 100;
    % 2. Lateral / Cornering Stiffness (C_alpha)
    % The simplified form of the multiplication B_fy * c_Fy * D_fy in the article is:
    C_alpha(i) = (a_Fy(3) * sin(a_Fy(4) * atan(a_Fy(5) * fz))) * (180/pi);
    % Printing the results to the Command Window
    fprintf('Fz = %d kN  |  C_s = %8.2f [N/ratio]  |  C_alpha = %8.2f [N/rad]\n',Fz_N(i)/1000, C_s(i), C_alpha(i));
end
disp('======================================================');