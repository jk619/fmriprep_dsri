#!/bin/bash

printf "starting\n"
subj='retsubj01'
ses='7t01'
data_dir='/data'

/opt/conda/envs/fmriprep/bin/fmriprep /data /data/derivatives participant --fs-license-file /tmp/license.txt  --output-space func --participant_label $subj --skip_bids_validation --output-layout legacy 



fun_runs=$(find "${data_dir}/derivatives/fmriprep/sub-$subj/ses-7t01/func" -type f -name "*run*_bold.nii.gz" | sort -t '\0' -n)

first_run=`echo "${fun_runs}" | head -1`
echo $first_run

#fun_runs=$(echo "$fun_runs" | sed 1d)

for file in $fun_runs
do
    filename_with_ext=$(basename "$file")
    filename="${filename_with_ext%.*}"

    filename_with_ext=$(basename "$filename")
    filename="${filename_with_ext%.*}"

    echo "$filename"
        dir=$(dirname "$file")
        echo "$dir"

    3dvolreg -cubic -base "$first_run[0]" -prefix "${dir}/${filename}_mc.nii.gz" $file

done


mypRFdir="${data_dir}/derivatives/pRF/sub-$subj/ses-$ses/"
mkdir -p $mypRFdir
odd_runs=$(find "${data_dir}/derivatives/fmriprep/sub-$subj/ses-$ses/func" -type f -name "*run*_bold_mc.nii.gz" | sort -t '\0' -n | sed -n 'p;n')
echo $odd_runs
first_string="/3dMean -prefix ${mypRFdir}sub-${subj}_ses-${ses}_task-pRF_desc-bar_bold.nii.gz"

for file in $odd_runs
do
    first_string="$first_string $file[0:294]"
done

eval $first_string


even_runs=$(find "${data_dir}/derivatives/fmriprep/sub-$subj/ses-$ses/func" -type f -name "*run*_bold_mc.nii.gz" | sort -t '\0' -n | sed -n 'n;p')
echo $even_runs


first_string="/3dMean -prefix ${mypRFdir}sub-${subj}_ses-${ses}_task-pRF_desc-wedgering_bold.nii.gz"
for file in $even_runs
do
    first_string="$first_string $file[0:294]"
done

eval $first_string


filename="${data_dir}/derivatives/fmriprep/sub-${subj}.html"

if grep -R "No errors to report" "$filename"
then
    printf 'complete\n' 
    while :; do sleep 2073600; done
else
    printf 'fail\n' 
    while :; do sleep 2073600; done
fi