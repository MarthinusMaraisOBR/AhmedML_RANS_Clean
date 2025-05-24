# Return to the main case directory
cd /home/marthinus/OpenFOAM/run

# Create an improved gnuplot script
cat > plotForceCoeffs.gnuplot << 'EOF'
set terminal pngcairo enhanced size 1600,900 font ",12"
set output 'ahmed_force_coefficients.png'
set grid
set title 'Ahmed Body Force Coefficients Convergence' font ',16'
set xlabel 'Iteration' font ',14'
set ylabel 'Coefficient Value' font ',14'
set key outside right top font ",12"

# Define line styles for better visualization
set style line 1 lc rgb "#0060ad" lt 1 lw 2 pt 7 ps 0.5  # blue for Cd
set style line 2 lc rgb "#dd181f" lt 1 lw 2 pt 7 ps 0.5  # red for Cl
set style line 3 lc rgb "#5e9c36" lt 1 lw 2 pt 7 ps 0.5  # green for CmPitch

# Plot the main coefficients
plot 'postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:2 with lines ls 1 title 'Drag (Cd)', \
     '' using 1:5 with lines ls 2 title 'Lift (Cl)', \
     '' using 1:8 with lines ls 3 title 'Pitching Moment (CmPitch)'

# Create a second plot with front/rear components
set output 'ahmed_force_components.png'
set title 'Ahmed Body Force Components Convergence' font ',16'

# Define more line styles
set style line 4 lc rgb "#89cff0" lt 1 lw 1.5 pt 7 ps 0.5  # light blue for Cd(f)
set style line 5 lc rgb "#000080" lt 1 lw 1.5 pt 7 ps 0.5  # navy for Cd(r)
set style line 6 lc rgb "#ffcccb" lt 1 lw 1.5 pt 7 ps 0.5  # light red for Cl(f)
set style line 7 lc rgb "#8b0000" lt 1 lw 1.5 pt 7 ps 0.5  # dark red for Cl(r)

# Plot the component coefficients
plot 'postProcessing/forceCoeffs1/0/coefficient_0.dat' using 1:3 with lines ls 4 title 'Front Drag Cd(f)', \
     '' using 1:4 with lines ls 5 title 'Rear Drag Cd(r)', \
     '' using 1:6 with lines ls 6 title 'Front Lift Cl(f)', \
     '' using 1:7 with lines ls 7 title 'Rear Lift Cl(r)'
EOF

# Run gnuplot to create both plots
gnuplot plotForceCoeffs.gnuplot

# Show that the plots were created
ls -la ahmed_force_*.png
