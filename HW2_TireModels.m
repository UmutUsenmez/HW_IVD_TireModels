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

% --- 9. FIALA TIRE MODEL - LATERAL FORCE (Fy) & ALIGNING TORQUE (Mz) ---

% Fiala is a physical model. Calculations use radians (alpha_rad) instead of degrees.
Fy_fiala = zeros(length(Fz_kN),length(alpha_rad)) ;            % Empty matrix for  Fiala Fy
Mz_fiala = zeros(length(Fz_kN), length(alpha_rad));            % Empty matrix for  Fiala Mz
fig_Fy_fiala = figure("Name","Fiala Model - Fy","Color","w");     % graphic window settings
hold on;grid on;
fig_Mz_fiala = figure('Name', 'Fiala Model - Mz', 'Color', 'w');  % graphic window settings
hold on; grid on;

% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz_N = Fz_N(i);          
    C_a = C_alpha(i);                % Tıre (Lateral) Stiffness (N/rad) that we found in the previous section
    % Calculation of the critical slip angle (tan axis)
    tan_alpha_crit = (3 * mu_0 * fz_N) / C_a;    % This point is the physical limit where the tire transitions from grip to skidding
    % Since alpha_rad is a vector, we need to check each angle value individually
    for j = 1:length(alpha_rad)
            current_tan_alpha = abs(tan(alpha_rad(j)));
            % STATUS 1: ELASTIC REGION
            if current_tan_alpha < tan_alpha_crit % The tire is still able to grip the road; the cubic parabolic formula works
                H = 1 - (C_a * current_tan_alpha) / (3 * mu_0 * fz_N);
                Fy_fiala(i, j) = mu_0 * fz_N * (1 - H^3) * sign(alpha_rad(j));
                Mz_fiala(i, j) = mu_0 * fz_N * Tw * (1 - H) * (H^3) * sign(alpha_rad(j));
            % STATUS 2: PURE SLIDING REGION    
            else                                  % The tire burst. It gives the maximum friction force it can exert (mu * Fz).
                Fy_fiala(i, j) = mu_0 * fz_N * sign(alpha_rad(j)); 
                Mz_fiala(i, j) = 0;               % The alignment torque resets when the tire bursts.
            end
    end
    % plot of Fiala-Fy & Aligning Torque (Mz)
    figure(fig_Fy_fiala);
    plot(alpha_deg, Fy_fiala(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
    figure(fig_Mz_fiala);
    plot(alpha_deg, Mz_fiala(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end
% Fiala-Fy & Aligning Torque (Mz) Graphics settings
figure(fig_Fy_fiala);
title('Fiala Tire Model - F_y', 'FontWeight', 'bold');
xlabel('Slip angle [deg]', 'FontWeight', 'bold');
ylabel('F_y [N]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-25 25]);
figure(fig_Mz_fiala);
title('Fiala Tire Model - M_z', 'FontWeight', 'bold');
xlabel('Slip angle [deg]', 'FontWeight', 'bold');
ylabel('M_z [Nm]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-25 25]);

% --- 10. FIALA TIRE MODEL - LONGITUDINAL FORCE (Fx) ---

% In Fx calculations, we use slip ratio (kappa).
Fx_fiala = zeros(length(Fz_kN), length(kappa));                      % Empty matrix for  Fiala Fx
fig_Fx_fiala = figure('Name', 'Fiala Model - Fx', 'Color', 'w');     % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz_N = Fz_N(i);          
    c_s_val = C_s(i);         % Longitudinal Stiffness (N/ratio) that we found in the previous section
    % Calculation of the critical slip rate (kappa)
    kappa_crit = (mu_0 * fz_N) / (2 * c_s_val);   % That physical limit where you transition from holding on to sliding (spinning/locking)
    % Since kappa is a vector, we need to check each slip value individually
    for j = 1:length(kappa)
        S_s = abs(kappa(j));
        % STATUS 1: ELASTIC REGION (Linear)
        if S_s <= kappa_crit  % The tire is still gripping the asphalt while accelerating/decelerating
            Fx_fiala(i, j) = c_s_val * S_s * sign(kappa(j));    % Fx = Cs * Ss
        % STATUS 2: PURE SLIDING REGION (Parabolic Drop-off)    
        else                               % Full wheel spin (or brake lock-up). Friction is fixed at its maximum.
            Fx1 = mu_0 * fz_N;
            Fx2 = (mu_0 * fz_N)^2 / (4 * S_s * c_s_val);
            Fx_fiala(i, j) = sign(kappa(j)) * (Fx1 - Fx2);
        end
    end
    % plot of Fiala-Fx
    figure(fig_Fx_fiala);
    plot(kappa * 100, Fx_fiala(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end
% Fiala-Fx Graphics settings
title('Fiala Tire Model - F_x', 'FontWeight', 'bold');
xlabel('Slip %', 'FontWeight', 'bold');
ylabel('F_x [N]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-100 100]);

% --- 11. DUGOFF TIRE MODEL - LATERAL FORCE (Fy) ---

Fy_dugoff = zeros(length(Fz_kN), length(alpha_rad));                 % Empty matrix for  Dugoff Fy
fig_Fy_dugoff = figure('Name', 'Dugoff Model - Fy', 'Color', 'w');   % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz_N = Fz_N(i);
    C_a = C_alpha(i);
    c_s_val = C_s(i);           % Longitudinal Stiffness (N/ratio)
    % Since alpha_rad is a vector, we need to check each angle value individually
    for j = 1:length(alpha_rad)
        alpha = alpha_rad(j);
        s = 0;                  % slip (s) is zero because no accelerator/brake is applied.
        % 1. Calculation of Sliding Speed ​​(Vs) and Dynamic Friction (mu)
        V_s = U * sqrt(s^2 + tan(alpha)^2);
        mu = mu_0 * (1 - A_s * V_s);
        % 2. Lambda (Critical Limit) Calculation
        den = 2 * sqrt((c_s_val * s)^2 + (C_a * tan(alpha))^2); 
        % If the denominator is zero (at the origin), it shouldn't go to infinity:
        if den == 0
            lambda = 1000; % If the denominator is 0, it means the tire has 100% grip.
        else
            lambda = (mu * fz_N * (1 + s)) / den;
        end
        % 3. Piecewise f(lambda) Function
        if lambda < 1
            f_lambda = (2 - lambda) * lambda;
        else
            f_lambda = 1;
        end
        % 4. Final Dugoff Lateral Force (Fy) Formula
        Fy_dugoff(i, j) = C_a * (tan(alpha) / (1 + s)) * f_lambda;
    end
    % Plot of Dugoff-Fy 
    figure(fig_Fy_dugoff);
    plot(alpha_deg, Fy_dugoff(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end
% Dugoff-Fy Graphics settings
title('Dugoff Tire Model - F_y', 'FontWeight', 'bold');
xlabel('Slip angle [deg]', 'FontWeight', 'bold');
ylabel('F_y [N]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-25 25]);

% --- 12. DUGOFF TIRE MODEL - LONGITUDINAL FORCE (Fx) ---

Fx_dugoff = zeros(length(Fz_kN), length(kappa));                    % Empty matrix for  Dugoff Fx
fig_Fx_dugoff = figure('Name', 'Dugoff Model - Fx', 'Color', 'w');  % graphic window settings
hold on; grid on;
% for loop instead of calculating them separately using empty matrix
for i = 1:length(Fz_kN)
    fz_N = Fz_N(i);
    c_s_val = C_s(i);
    % Since kappa is a vector, we need to check each slip value individually
    for j = 1:length(kappa)
        s = kappa(j);
        s_mag = abs(s);
        % 1. Calculation of Sliding Speed ​​(Vs) and Dynamic Friction (mu)
        V_s = U * s_mag;
        mu = mu_0 * (1 - A_s * V_s);
        % 2. Lambda (Critical Limit) Calculation
        den = 2 * c_s_val * s_mag;
        % If the denominator is zero (at the origin), it shouldn't go to infinity:
        if den == 0
            lambda = 1000;         % If the denominator is 0, it means the tire has 100% grip.
        else
            lambda = (mu * fz_N * (1 + s_mag)) / den;
        end
         % 3. Piecewise f(lambda) Function
        if lambda < 1
            f_lambda = (2 - lambda) * lambda;
        else
            f_lambda = 1;
        end
        % 4. Final Dugoff Longitudinal Force (Fx) Formula
        Fx_dugoff(i, j) = c_s_val * (s / (1 + s_mag)) * f_lambda;
    end
    % Plot of Dugoff-Fx
    figure(fig_Fx_dugoff);
    plot(kappa * 100, Fx_dugoff(i, :), 'LineWidth', 2, 'DisplayName', sprintf('F_z = %d kN', Fz_N(i)/1000));
end
% Dugoff-Fx Graphics settings
title('Dugoff Tire Model - F_x', 'FontWeight', 'bold');
xlabel('Slip %', 'FontWeight', 'bold');
ylabel('F_x [N]', 'FontWeight', 'bold');
legend('Location', 'best');
xlim([-100 100]);

% --- 13. TIRE FORCE ELLIPSE (FRICTION ELLIPSE / CARPET PLOT) ---

% Based on Dugoff Tire Model with constant vertical load Fz = 4000 N
Fz_ellipse = 4000;                        % Constant vertical load [N]
alpha_ellipse_deg = [0, 2, 5, 10, 20];    % Given constant slip angles [deg]
alpha_ellipse_rad = deg2rad(alpha_ellipse_deg);   % conversion from degrees to radians
% We already have the stiffness values for Fz = 4000 N 
% It is the 2nd index in our Fz array (2000, 4000, 6000, 8000)
Cs_ellipse = C_s(2); 
Ca_ellipse = C_alpha(2);
fig_Ellipse = figure('Name', 'Tire Force Ellipse (Dugoff)', 'Color', 'w');  % graphic window settings
hold on; grid on;
% Friction Circle Boundary (Theoretical Limit: mu * Fz)
F_max = mu_0 * Fz_ellipse;
theta = linspace(0, 2*pi, 100);
plot(F_max * sin(theta), F_max * cos(theta), 'k--', 'LineWidth', 2, 'DisplayName', 'Friction Limit (\mu F_z)');
set(gca, 'ColorOrderIndex', 1);
% Loop for each constant slip angle
for i = 1:length(alpha_ellipse_rad)
    alpha = alpha_ellipse_rad(i);
    Fx_combined = zeros(1, length(kappa));
    Fy_combined = zeros(1, length(kappa));
     % Since kappa is a vector, we need to check each slip value individually
     for j = 1:length(kappa)
        s = kappa(j);
        % 1. Calculation of Sliding Speed ​​(Vs) and Dynamic Friction (mu)
        V_s = U * sqrt(s^2 + tan(alpha)^2);
        mu = mu_0 * (1 - A_s * V_s);
        % 2. Lambda (Critical Limit) Calculation
        den = 2 * sqrt((Cs_ellipse * s)^2 + (Ca_ellipse * tan(alpha))^2);
        % If the denominator is zero (at the origin), it shouldn't go to infinity:
        if den == 0
            lambda = 1000;               % If the denominator is 0, it means the tire has 100% grip.
        else
            lambda = (mu * Fz_ellipse * (1 + abs(s))) / den;
        end
        % 3. Piecewise f(lambda) Function
        if lambda < 1
            f_lambda = (2 - lambda) * lambda;
        else
            f_lambda = 1;
        end
        % Combined slip forces calculation
        Fx_combined(j) = Cs_ellipse * (s / (1 + abs(s))) * f_lambda;
        Fy_combined(j) = Ca_ellipse * (tan(alpha) / (1 + abs(s))) * f_lambda;
     end
     % Plot Fy vs Fx for the current constant slip angle
     % (Lateral force on X-axis, Longitudinal force on Y-axis is standard for Carpet Plots)
     figure(fig_Ellipse);
     plot(Fy_combined, Fx_combined, 'LineWidth', 2, 'DisplayName', sprintf('\\alpha = %d^o', alpha_ellipse_deg(i)));
end
% Ellipse Graphics settings
title('Tire Force Ellipse (Carpet Plot) - Dugoff Model', 'FontWeight', 'bold');
xlabel('Lateral Force, F_y [N]', 'FontWeight', 'bold');
ylabel('Longitudinal Force, F_x [N]', 'FontWeight', 'bold');
legend('Location', 'eastoutside');
axis equal;                      % Makes the friction limit look like a perfect circle.
xlim([-4500 4500]);
ylim([-4500 4500]);

% --- 14. SIMULINK DATA PREPARATION ---

% This section prepares the calculated matrices into a format (Fz x Slip) that Simulink Lookup Table blocks can read.
% 1. Axis Definitions (Breakpoints)
slip_axis_pct = kappa * 100;
slip_axis = kappa;         % Longitudinal slip axis (-1 to 1)
alpha_axis = alpha_deg;    % Lateral slip angle axis (-25 to 25)
fz_axis = Fz_N;            % Vertical load axis (2000, 4000, 6000, 8000)
% 2. Magic Formula Data
Fx_magic_sim = Fx_magic';    
Fy_magic_sim = Fy_magic';    
Mz_magic_sim = Mz_magic';
% 3. Fiala Data
Fx_fiala_sim = Fx_fiala';
Fy_fiala_sim = Fy_fiala';
Mz_fiala_sim = Mz_fiala';
% 4. Dugoff Data
Fx_dugoff_sim = Fx_dugoff';
Fy_dugoff_sim = Fy_dugoff';
