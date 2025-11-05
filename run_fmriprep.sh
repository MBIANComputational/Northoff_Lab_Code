#!/bin/bash

#--here we set ressource sharing settings (may not work properly)--#
np=0
maxjobs=2

subjects=("sub-NTHC1098" "sub-NTS3077")

# subjects=("sub-NTS3074" "sub-NTHC1029")

#--here we define fmriprep settings--#
bids_root_dir="/BICNAS2/group-northoff"
fs_subj_dir="/usr/local/freesurfer/7.4.1"
work_dir="/BICNAS2/group-northoff/ds005498_derivatives/work"
nthreads=16
ompnthreads=8

#--here we define fmriprep settings--#

for subject in ${subjects[@]}; do

    log_file="fmriprep_${subject}.log"
    start_time=$(date +%s)

    unset PYTHONPATH; singularity run -B $HOME/.cache/templateflow:/opt/templateflow,$bids_root_dir:/mnt/group,$fs_subj_dir:/mnt/fs_dir,$work_dir:/mnt/work /group/singularity-SIF/fmriprep_24.0.0.sif \
    /mnt/group/ds005498-2.0.0/ /mnt/group/ds005498_derivatives/iteration1  \
    participant \
    --participant-label ${subject} \
    --task-id resting \
    --skip_bids_validation \
    -w /mnt/work \
    --fs-license-file /mnt/fs_dir/license.txt \
    --write-graph \
    --nthreads $nthreads \
    --omp-nthreads $ompnthreads \
    --mem-mb 16000 \
    --verbose \
    > "${log_file}" 2>&1 &

    pid=$!
    (( np++ ))
    if [ $np == $maxjobs ]; then
        wait $pid
        status=$?
        end_time=$(date +%s)
        elapsed=$((end_time - start_time))
        echo "Elapsed time: ${elapsed} seconds" >> "${log_file}"
        if [ $status -ne 0 ]; then
            echo "Error: fmriprep failed for ${subject} (see ${log_file})" >> error.log
        fi
        np=0
    fi

done

wait  # Wait for any remaining background jobs

# To look at the QC files, run the command "python3 -m http.server 8080"