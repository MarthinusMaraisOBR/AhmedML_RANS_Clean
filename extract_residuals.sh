#!/bin/bash

# Extract initial residuals
echo "Extracting initial residuals..."
grep "Solving for p" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > p_init.tmp
grep "Solving for Ux" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > Ux_init.tmp
grep "Solving for Uy" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > Uy_init.tmp
grep "Solving for Uz" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > Uz_init.tmp
grep "Solving for k" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > k_init.tmp
grep "Solving for omega" log.simpleFoam | grep "Initial residual" | cut -d "=" -f2 | cut -d "," -f1 > omega_init.tmp

# Extract final residuals
echo "Extracting final residuals..."
grep "Solving for p" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > p_final.tmp
grep "Solving for Ux" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > Ux_final.tmp
grep "Solving for Uy" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > Uy_final.tmp
grep "Solving for Uz" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > Uz_final.tmp
grep "Solving for k" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > k_final.tmp
grep "Solving for omega" log.simpleFoam | grep "Final residual" | cut -d "=" -f2 | cut -d "," -f1 > omega_final.tmp

# Combine initial and final residuals
echo "Combining initial and final residuals..."
paste p_init.tmp p_final.tmp > p_residuals_fixed.dat
paste Ux_init.tmp Ux_final.tmp > Ux_residuals_fixed.dat
paste Uy_init.tmp Uy_final.tmp > Uy_residuals_fixed.dat
paste Uz_init.tmp Uz_final.tmp > Uz_residuals_fixed.dat
paste k_init.tmp k_final.tmp > k_residuals_fixed.dat
paste omega_init.tmp omega_final.tmp > omega_residuals_fixed.dat

# Clean up temporary files
rm -f *.tmp

echo "Data extraction complete."
