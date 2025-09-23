# This is a script to extract the ROIs for the Three Layers of Self, from Qin et al. 2020 (Table 2)
current_dir=$(pwd)

template_image=$current_dir/MNI152_2009_template.nii.gz
sample_epi_image=/Users/fdjim/Desktop/PDS_FULL/sub-003P/func/sub-003P_task-pds_bold.nii
output_dir=$current_dir/ROIs
mkdir $output_dir

3dresample \
-input $template_image \
-master $sample_epi_image \
-prefix $output_dir/Resample_MNI152_2009
echo "Resampling template image to sample EPI image"

# ROI creation from MNI152_2009
# step(9- ...) = sqrt 9 = radius 3mm sphere
# step(16- ...) = sqrt 16 = radius 4mm sphere

cd $output_dir
echo "Processing ..."

a=34; b=14; c=12
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_R_Insula

a=0; b=4; c=48
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Dorsal_anterior_cingulate_cortex

a=12; b=-14; c=4
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_R_Thalamus

a=30; b=-4; c=-24
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_R_Parahippocampal_gyrus

a=-20; b=-4; c=-20
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Parahippocampal_gyrus

a=-40; b=-2; c=2
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Insula_1

a=-36; b=24; c=4
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Insula_2

a=56; b=-26; c=26
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_R_Inferior_parietal_lobule

a=4; b=24; c=48
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_R_Superior_frontal_gyrus

a=-56; b=6; c=6
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Superior_temporal_gyrus

a=-48; b=-16; c=32
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Interoception_L_Postcentral_gyrus

a=48; b=-58; c=-12
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Fusiform_gyrus

a=48; b=40; c=8
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Inferior_frontal_gyrus

a=50; b=8; c=26
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Premotor_cortex

a=40; b=8; c=0
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Insula

a=-44; b=-68; c=-6
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_L_Fusiform_gyrus

a=26; b=-72; c=44
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Superior_parietal_lobule

a=58; b=-22; c=38
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Postcentral_gyrus

a=36; b=-50; c=56
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Inferior_parietal_lobule

a=-36; b=18; c=-4
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_L_Insula

a=38; b=-80; c=-2
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Inferior_occipital_gyrus

a=-46; b=-34; c=40
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_L_Inferior_parietal_lobule

a=-22; b=-64; c=50
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_L_Superior_parietal_lobule

a=4; b=8; c=38
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_R_Cingulate_gyrus

a=-6; b=60; c=22
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Exteroception_L_Medial_prefrontal_cortex

a=-6; b=48; c=0
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Anterior_cingulate_cortex

a=-4; b=-54; c=28
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Posterior_cingulate_cortex

a=-36; b=22; c=-2
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Insula

a=-48; b=-66; c=28
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Middle_temporal_gyrus

a=-8; b=2; c=8
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Thalamus

a=-20; b=36; c=46
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Superior_frontal_gyrus_1

a=0; b=-18; c=40
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_Cingulate_gyrus

a=-62; b=-6; c=-18
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Inferior_temporal_gyrus

a=54; b=-60; c=24
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_R_Middle_temporal_gyrus

a=52; b=10; c=-6
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_R_Insula

a=-24; b=50; c=22
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_L_Superior_frontal_gyrus_2

a=46; b=6; c=24
3dcalc \
-a $output_dir/Resample_MNI152_2009+orig \
-expr "step(16-(x+$a)*(x+$a)-(y+$b)*(y+$b)-(z-$c)*(z-$c))" \
-prefix Cognition_R_Premotor_cortex

3dcalc \
-a Interoception_R_Insula+orig \
-b Interoception_L_Dorsal_anterior_cingulate_cortex+orig \
-c Interoception_R_Thalamus+orig \
-d Interoception_R_Parahippocampal_gyrus+orig \
-e Interoception_L_Parahippocampal_gyrus+orig \
-f Interoception_L_Insula_1+orig \
-g Interoception_L_Insula_2+orig \
-h Interoception_R_Inferior_parietal_lobule+orig \
-i Interoception_R_Superior_frontal_gyrus+orig \
-j Interoception_L_Superior_temporal_gyrus+orig \
-k Interoception_L_Postcentral_gyrus+orig \
-expr 'step(a+b+c+d+e+f+g+h+i+j+k)' \
-prefix Interoception

3dcalc \
-a Exteroception_R_Fusiform_gyrus+orig \
-b Exteroception_R_Inferior_frontal_gyrus+orig \
-c Exteroception_R_Premotor_cortex+orig \
-d Exteroception_R_Insula+orig \
-e Exteroception_L_Fusiform_gyrus+orig \
-f Exteroception_R_Superior_parietal_lobule+orig \
-g Exteroception_R_Postcentral_gyrus+orig \
-h Exteroception_R_Inferior_parietal_lobule+orig \
-i Exteroception_L_Insula+orig \
-j Exteroception_R_Inferior_occipital_gyrus+orig \
-k Exteroception_L_Inferior_parietal_lobule+orig \
-l Exteroception_L_Superior_parietal_lobule+orig \
-m Exteroception_R_Cingulate_gyrus+orig \
-n Exteroception_L_Medial_prefrontal_cortex+orig \
-expr 'step(a+b+c+d+e+f+g+h+i+j+k+l+m+n)' \
-prefix Exteroception

3dcalc \
-a Cognition_L_Anterior_cingulate_cortex+orig \
-b Cognition_L_Posterior_cingulate_cortex+orig \
-c Cognition_L_Insula+orig \
-d Cognition_L_Middle_temporal_gyrus+orig \
-e Cognition_L_Thalamus+orig \
-f Cognition_L_Superior_frontal_gyrus_1+orig \
-g Cognition_Cingulate_gyrus+orig \
-h Cognition_L_Inferior_temporal_gyrus+orig \
-i Cognition_R_Middle_temporal_gyrus+orig \
-j Cognition_R_Insula+orig \
-k Cognition_L_Superior_frontal_gyrus_2+orig \
-l Cognition_R_Premotor_cortex+orig \
-expr 'step(a+b+c+d+e+f+g+h+i+j+k+l)' \
-prefix Cognition
