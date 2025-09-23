# Northoff_Lab_Code

## 3LT
Shell scripts to extract the ROIs for the Three Layers of Self, from Qin et al. 2020 (Table 2).

These scripts require AFNI to be installed. They take as input the MNI152_2009_template.nii.gz and the sample EPI image. The template is resampled to the sample EPI image. Then, the ROIs are extracted using 3dcalc.

## Sensory Regions (Yasir)
!TODO: Add script that extracts the sensory regions

## ACW
Python script to calculate the Autocorrelation Width (ACW) of a signal. Fits an exponential decay to the autocorrelation function.

## TimeSeries_Analysis
Python class to perform time-series analysis using various measures often used in the Northoff lab.