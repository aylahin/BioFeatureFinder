#!/bin/bash
#Creator: Felipe Eduardo Ciamponi
#Objective: Reduce the matrix size created by build_datamatrix.py to reduce RAM usage
#WARNING: Reducing the size of input matrix can lead to bias in the classification, try running multiple times for more accurate results

usage="$(basename "$0") [-h] print help message and exit [-m/--matrix] data matrix for reduction [-ref/--refference] refference bed file with exons in matrix [-i/--input] input bed with exons of interest [-o/--outfile] prefix for output matrix [-f/--bedtools_f] -f option in Bedtools [-F/--bedtools_F] -F option in Bedtools [-s/--sample] number of times to multiply the input size for random sampling"
example="$(basename "$0") -m hg19.middle.exons.tsv -ref hg19.middle.exons.bed -i hg19.skipped.exons.bed -o hg19.middle -f 1 -F 1 -s 5"
explanation="The above line will take the data matrix generated by middle exons, extract all data from input exons (with 100% overlap with refference) and randomly sample (from the non-overlaping exons) 5 times the amount of exons (ex. if your input is 100 exons, it will randomly sample 500 exons). The output will be saved in a table called hg19.middle.matrix.reduced.tsv"

if [ "$1" == "-h" ]; then
  echo 
  echo $usage
  echo 
  echo "Example:"
  echo $example
  echo
  echo $explanation
  echo
  exit 0
fi

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -m|--matrix)
    matrix=$2
    shift
    ;;
    -ref|--refference)
    ref_bed=$2
    shift
    ;;
    -i|--input)
    bed_file=$2
    shift
    ;;
    -o|--outfile)
    out_prefix=$2
    shift
    ;;
    -f|--bedtools_f)
    f=$2
    shift
    ;;
    -F|--bedtools_F)
    F=$2
    shift
    ;;
    -s|--sample)
    samp=$2
    shift
    ;;
esac
shift
done

#matrix="$1"
#ref_bed="$2"
#bed_file="$3"
#out_prefix="$4"
#f="$5"
#F="$6"
#samp="$7"

export LC_ALL=C

echo
echo "Loading bed files with annotations and finding positive/negative intersections in the refference annotation."
echo

bedtools intersect -f ${f} -F ${F} -s -a ${ref_bed} -b ${bed_file} > intersect_true.bed
bedtools intersect -f ${f} -F ${F} -s -v -a ${ref_bed} -b ${bed_file} > intersect_false.bed

n_lines=$(wc -l intersect_true.bed | cut -f 1 -d ' ')
rand_lines=$(expr $n_lines \* ${samp})
total_lines=$(expr $n_lines + $rand_lines)

echo "Number of positive lines to be extracted:" $n_lines
echo "Number of random lines to be extracted:" $rand_lines
echo "Number of total lines to be extracted:" $total_lines
echo 
echo "Selecting random exons from the BED file and merging with positive exons"

shuf -n $rand_lines intersect_false.bed | cut -f 4 > false_id_list.txt
cut -f 4 intersect_true.bed > true_id_list.txt

cat false_id_list.txt true_id_list.txt > id_list.txt

echo
echo "Filtering original dataframe to extract selected and random exons"

awk 'FNR==NR {a[$1]; next}; $1 in a' id_list.txt ${matrix} > matrix_reduced.txt

head -n 1 ${matrix} > matrix_header.txt

cat matrix_header.txt matrix_reduced.txt > ${out_prefix}.matrix.reduced.tsv

rm intersect_true.bed intersect_false.bed false_id_list.txt true_id_list.txt id_list.txt matrix_header.txt matrix_reduced.txt

echo
echo "Saved new matrix as:" ${out_prefix}.matrix.reduced.tsv
echo
echo "WARNING: Reducing the size of input matrix can lead to bias in the classification, try running multiple times for more accurate results"
echo
