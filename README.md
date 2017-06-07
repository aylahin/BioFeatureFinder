﻿# biofeatures

## Description.


## Warnings


## Scripts:


./biofeatures/scripts/accessory_scripts/convert_annotations.py

./biofeatures/scripts/accessory_scripts/random_sampling_test.py

./biofeatures/scripts/accessory_scripts/reduce_matrix.sh

A script for selecting random lines from the data_matrix.
It's supposed to be used if a computer doesn't have enough RAM
to load the entire matrix as a DataFrame in python.

./biofeatures/scripts/analyze_features.py

Main script used for analyzing biological features associated with groups of exons. Uses .bed files of exon coordinates to compare with annotated exons in the data matrix (created by build_datamatrix.py), runs KS statistic to filter non-significant differences and then uses GradientBoost classifier to determine wich features are more “important” in group separation (input vs background).

./biofeatures/scripts/build_datamatrix.py

Script used for creating the data matrix for biological features associated with exons and their neighouring regions. Uses a .GTF annotation, genome FASTA, .BW and .BED files as input for BioFeatures. Can also use MaxEntScan for calculating splice site score.

## Dependency Installation

### With anaconda (recommended):

    conda install -c bioconda pysam pybedtools matplotlib pandas pybedtools scikit-learn matplotlib scipy rpy2

## Scripts installation

### Install scripts
    pip install .

### Development install, local changes are reflected in command-line calls

    pip install -e .


## Authors


## Funding


## Pylint

    pylint biofeatures/ > lint_result && git commit -m "ran pylint" lint_result
