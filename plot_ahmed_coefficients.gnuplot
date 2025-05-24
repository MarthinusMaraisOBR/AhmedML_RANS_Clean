set terminal pngcairo enhanced size 1600,900 font ",12"

# Main force coefficients plot
set output 'ahmed_force_coefficients.png'
set grid
set title 'Ahmed Body Simulation - Force Coefficients Convergence' font ',16'
set xlabel 'Time' font ',14'
set ylabel 'Coefficient Value' font ',14'
set key outside right top font ",12"

# Define line styles
set style line 1 lc rgb "#0060ad" lt 1 lw 2  # blue for Drag (Cd)
set style line 2 lc rgb "#dd181f" lt 1 lw 2  # red for Lift (Cl)
set style line 3 lc rgb "#5e9c36" lt 1 lw 2  # green for Pitching Moment (CmPitch)

# Plot main coefficients: Time(1) Cd(2) Cl(5) CmPitch(8)
plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:2 with lines ls 1 title 'Drag (Cd)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:5 with lines ls 2 title 'Lift (Cl)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:8 with lines ls 3 title 'Pitching Moment (CmPitch)'

# Final convergence plot (last 20% of simulation)
set output 'ahmed_force_coefficients_final.png'
set title 'Ahmed Body Simulation - Final Force Coefficients Convergence' font ',16'

# Calculate final 20% range
stats '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1 nooutput
start_time = STATS_max * 0.8
set xrange [start_time:STATS_max]

plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:2 with lines ls 1 title 'Drag (Cd)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:5 with lines ls 2 title 'Lift (Cl)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:8 with lines ls 3 title 'Pitching Moment (CmPitch)'

# Individual coefficient plots
set autoscale x
set autoscale y

# Drag coefficient
set output 'ahmed_drag_coefficient.png'
set title 'Ahmed Body - Drag Coefficient (Cd) Convergence' font ',16'
set ylabel 'Drag Coefficient (Cd)' font ',14'
plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:2 with lines ls 1 notitle

# Lift coefficient
set output 'ahmed_lift_coefficient.png'
set title 'Ahmed Body - Lift Coefficient (Cl) Convergence' font ',16'
set ylabel 'Lift Coefficient (Cl)' font ',14'
plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:5 with lines ls 2 notitle

# Pitching moment coefficient
set output 'ahmed_moment_coefficient.png'
set title 'Ahmed Body - Pitching Moment Coefficient (CmPitch) Convergence' font ',16'
set ylabel 'Pitching Moment Coefficient (CmPitch)' font ',14'
plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:8 with lines ls 3 notitle

# Additional plot with front/rear decomposition
set output 'ahmed_drag_components.png'
set title 'Ahmed Body - Drag Coefficient Components' font ',16'
set ylabel 'Drag Coefficient' font ',14'
set style line 4 lc rgb "#ff8c00" lt 1 lw 1.5  # orange for front
set style line 5 lc rgb "#4b0082" lt 1 lw 1.5  # indigo for rear

plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:2 with lines ls 1 title 'Total Cd', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:3 with lines ls 4 title 'Cd(front)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:4 with lines ls 5 title 'Cd(rear)'

# Lift components
set output 'ahmed_lift_components.png'
set title 'Ahmed Body - Lift Coefficient Components' font ',16'
set ylabel 'Lift Coefficient' font ',14'

plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:5 with lines ls 2 title 'Total Cl', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:6 with lines ls 4 title 'Cl(front)', \
     '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:7 with lines ls 5 title 'Cl(rear)'

# Side force coefficient (for completeness)
set output 'ahmed_side_coefficient.png'
set title 'Ahmed Body - Side Force Coefficient (Cs) Convergence' font ',16'
set ylabel 'Side Force Coefficient (Cs)' font ',14'
set style line 6 lc rgb "#8b4513" lt 1 lw 2  # brown for side force

plot '/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:11 with lines ls 6 notitle
