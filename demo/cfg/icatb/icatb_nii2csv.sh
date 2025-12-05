#!/bin/bash

# converts 2d nii file into csv file
# Cyrus Eierud, TReNDS 112325 

# Init variables
DIR_PREV=$(pwd)
mkdir /out/tmp_dir

# find project prefix
S_PREFIX_AND_FILE=$(echo /out/*_group_loading_coeff_.nii)
S_PREFIX="${S_PREFIX_AND_FILE##*/}"    # strip path
S_PREFIX="${S_PREFIX%_group_loading_coeff_.nii}"

# Exporting NII to csv
find /out -iname ${S_PREFIX}"_group_loading_coeff_.nii" -exec cp {} /out/tmp_dir/icatb_group_loading_coeff.nii \;
cd /out/tmp_dir
fsl2ascii icatb_group_loading_coeff.nii icatb_tmp_text_file
cat icatb_tmp_text_file* | sed 's/ \+/,/g' > input.csv

# transposes the csv file results so each row is a subject
awk -F',' '
{
    for (i=1; i<=NF; i++) {
        a[NR,i] = $i
    }
    if (NF > max) max = NF
}
END {
    for (i=1; i<=max; i++) {
        for (j=1; j<=NR; j++) {
            printf "%s%s", a[j,i], (j==NR ? ORS : OFS)
        }
    }
}
' OFS=',' input.csv > output.csv

mv output.csv "/out/"${S_PREFIX}"_group_loading_coeff_.csv"

cd "$DIR_PREV"
rm -rf /out/tmp_dir

# change name of file from previous script if possible
mv /out/subject_file_name_order_read_in.txt /out/${S_PREFIX}"_subject_order.txt"
