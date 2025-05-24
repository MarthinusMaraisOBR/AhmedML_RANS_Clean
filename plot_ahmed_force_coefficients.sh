#!/bin/bash

echo "Creating Ahmed Body force coefficient plots..."

# Define the coefficient data file
COEFF_FILE="/home/marthinus/OpenFOAM/run/postProcessing/forceCoeffs1/0/coefficient_0.dat"

if [ ! -f "$COEFF_FILE" ]; then
    echo "Error: coefficient_0.dat not found at expected location!"
    exit 1
fi

echo "Using data file: $COEFF_FILE"

# Count data points (excluding header lines)
DATA_POINTS=$(grep -v "^#" "$COEFF_FILE" | wc -l)
echo "Number of data points: $DATA_POINTS"

# Show reference values from header
echo ""
echo "Reference values from simulation:"
grep "# magUInf\|# lRef\|# Aref" "$COEFF_FILE"

# Create gnuplot script for Ahmed body force coefficients
cat > plot_ahmed_coefficients.gnuplot << 'PLOTEOF'
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
plot 'DATAFILE' using 1:2 with lines ls 1 title 'Drag (Cd)', \
     'DATAFILE' using 1:5 with lines ls 2 title 'Lift (Cl)', \
     'DATAFILE' using 1:8 with lines ls 3 title 'Pitching Moment (CmPitch)'

# Final convergence plot (last 20% of simulation)
set output 'ahmed_force_coefficients_final.png'
set title 'Ahmed Body Simulation - Final Force Coefficients Convergence' font ',16'

# Calculate final 20% range
stats 'DATAFILE' using 1 nooutput
start_time = STATS_max * 0.8
set xrange [start_time:STATS_max]

plot 'DATAFILE' using 1:2 with lines ls 1 title 'Drag (Cd)', \
     'DATAFILE' using 1:5 with lines ls 2 title 'Lift (Cl)', \
     'DATAFILE' using 1:8 with lines ls 3 title 'Pitching Moment (CmPitch)'

# Individual coefficient plots
set autoscale x
set autoscale y

# Drag coefficient
set output 'ahmed_drag_coefficient.png'
set title 'Ahmed Body - Drag Coefficient (Cd) Convergence' font ',16'
set ylabel 'Drag Coefficient (Cd)' font ',14'
plot 'DATAFILE' using 1:2 with lines ls 1 notitle

# Lift coefficient
set output 'ahmed_lift_coefficient.png'
set title 'Ahmed Body - Lift Coefficient (Cl) Convergence' font ',16'
set ylabel 'Lift Coefficient (Cl)' font ',14'
plot 'DATAFILE' using 1:5 with lines ls 2 notitle

# Pitching moment coefficient
set output 'ahmed_moment_coefficient.png'
set title 'Ahmed Body - Pitching Moment Coefficient (CmPitch) Convergence' font ',16'
set ylabel 'Pitching Moment Coefficient (CmPitch)' font ',14'
plot 'DATAFILE' using 1:8 with lines ls 3 notitle

# Additional plot with front/rear decomposition
set output 'ahmed_drag_components.png'
set title 'Ahmed Body - Drag Coefficient Components' font ',16'
set ylabel 'Drag Coefficient' font ',14'
set style line 4 lc rgb "#ff8c00" lt 1 lw 1.5  # orange for front
set style line 5 lc rgb "#4b0082" lt 1 lw 1.5  # indigo for rear

plot 'DATAFILE' using 1:2 with lines ls 1 title 'Total Cd', \
     'DATAFILE' using 1:3 with lines ls 4 title 'Cd(front)', \
     'DATAFILE' using 1:4 with lines ls 5 title 'Cd(rear)'

# Lift components
set output 'ahmed_lift_components.png'
set title 'Ahmed Body - Lift Coefficient Components' font ',16'
set ylabel 'Lift Coefficient' font ',14'

plot 'DATAFILE' using 1:5 with lines ls 2 title 'Total Cl', \
     'DATAFILE' using 1:6 with lines ls 4 title 'Cl(front)', \
     'DATAFILE' using 1:7 with lines ls 5 title 'Cl(rear)'

# Side force coefficient (for completeness)
set output 'ahmed_side_coefficient.png'
set title 'Ahmed Body - Side Force Coefficient (Cs) Convergence' font ',16'
set ylabel 'Side Force Coefficient (Cs)' font ',14'
set style line 6 lc rgb "#8b4513" lt 1 lw 2  # brown for side force

plot 'DATAFILE' using 1:11 with lines ls 6 notitle
PLOTEOF

# Replace DATAFILE placeholder with actual file path
sed -i "s|DATAFILE|$COEFF_FILE|g" plot_ahmed_coefficients.gnuplot

# Run gnuplot
gnuplot plot_ahmed_coefficients.gnuplot

echo ""
echo "Ahmed Body force coefficient plots created:"
echo "  - ahmed_force_coefficients.png (main coefficients)"
echo "  - ahmed_force_coefficients_final.png (final convergence)"
echo "  - ahmed_drag_coefficient.png (drag only)"
echo "  - ahmed_lift_coefficient.png (lift only)"
echo "  - ahmed_moment_coefficient.png (pitching moment only)"
echo "  - ahmed_drag_components.png (drag front/rear breakdown)"
echo "  - ahmed_lift_components.png (lift front/rear breakdown)"
echo "  - ahmed_side_coefficient.png (side force)"

# Display final values
echo ""
echo "Final force coefficient values:"
tail -1 "$COEFF_FILE" | awk '{
    printf "Time = %.1f\n", $1
    printf "Cd (Drag)    = %.6f\n", $2
    printf "Cl (Lift)    = %.6f\n", $5
    printf "CmPitch      = %.6f\n", $8
    printf "Cs (Side)    = %.6f\n", $11
    printf "\nDrag breakdown:\n"
    printf "  Cd(front)  = %.6f\n", $3
    printf "  Cd(rear)   = %.6f\n", $4
    printf "\nLift breakdown:\n"
    printf "  Cl(front)  = %.6f\n", $6
    printf "  Cl(rear)   = %.6f\n", $7
}'

# Calculate statistics for final 10% of simulation
echo ""
echo "Statistics for final 10% of simulation:"
tail -n $(echo "$DATA_POINTS/10" | bc) "$COEFF_FILE" | awk '
BEGIN { sum_cd=0; sum_cl=0; sum_cm=0; count=0 }
{
    if (NF >= 8) {
        sum_cd += $2; sum_cl += $5; sum_cm += $8; count++
    }
}
END {
    if (count > 0) {
        printf "Average Cd = %.6f\n", sum_cd/count
        printf "Average Cl = %.6f\n", sum_cl/count
        printf "Average CmPitch = %.6f\n", sum_cm/count
    }
}'

# List created plots
echo ""
echo "Generated plot files:"
ls -la ahmed_*.png

