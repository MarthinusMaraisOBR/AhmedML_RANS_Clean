set terminal pngcairo enhanced size 1600,900 font ",12"
set output 'residuals_initial_new.png'
set logscale y
set grid
set title 'Ahmed Body Simulation - Initial Residuals (1000 Iterations)' font ',16'
set xlabel 'PISO Iteration' font ',14'
set ylabel 'Initial Residual (log scale)' font ',14'
set key outside right top font ",12"
set yrange [1e-6:2]
set xrange [1:1000]  # Set range for 1000 iterations

# Define line styles
set style line 1 lc rgb "#0060ad" lt 1 lw 1.5  # blue for p
set style line 2 lc rgb "#dd181f" lt 1 lw 1.5  # red for Ux
set style line 3 lc rgb "#5e9c36" lt 1 lw 1.5  # green for Uy
set style line 4 lc rgb "#9400d3" lt 1 lw 1.5  # purple for Uz
set style line 5 lc rgb "#ff8c00" lt 1 lw 1.5  # orange for k
set style line 6 lc rgb "#4b0082" lt 1 lw 1.5  # indigo for omega

# Plot initial residuals with line number as x
plot '< nl -ba p_residuals_fixed.dat' using 1:2 with lines ls 1 title 'p', \
     '< nl -ba Ux_residuals_fixed.dat' using 1:2 with lines ls 2 title 'Ux', \
     '< nl -ba Uy_residuals_fixed.dat' using 1:2 with lines ls 3 title 'Uy', \
     '< nl -ba Uz_residuals_fixed.dat' using 1:2 with lines ls 4 title 'Uz', \
     '< nl -ba k_residuals_fixed.dat' using 1:2 with lines ls 5 title 'k', \
     '< nl -ba omega_residuals_fixed.dat' using 1:2 with lines ls 6 title 'omega'

# Create a second plot for final residuals
set output 'residuals_final_new.png'
set title 'Ahmed Body Simulation - Final Residuals (1000 Iterations)' font ',16'
set xrange [1:1000]  # Set range for 1000 iterations

# Plot final residuals with line number as x
plot '< nl -ba p_residuals_fixed.dat' using 1:3 with lines ls 1 title 'p', \
     '< nl -ba Ux_residuals_fixed.dat' using 1:3 with lines ls 2 title 'Ux', \
     '< nl -ba Uy_residuals_fixed.dat' using 1:3 with lines ls 3 title 'Uy', \
     '< nl -ba Uz_residuals_fixed.dat' using 1:3 with lines ls 4 title 'Uz', \
     '< nl -ba k_residuals_fixed.dat' using 1:3 with lines ls 5 title 'k', \
     '< nl -ba omega_residuals_fixed.dat' using 1:3 with lines ls 6 title 'omega'
