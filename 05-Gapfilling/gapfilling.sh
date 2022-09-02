#!/bin/bash
# Perform gapfilling using TGS-GapCloser followed by polishing using PoLCA.

TGS-GapCloser.sh  \
        --scaff  PMJ.polished_HiC.fa \
        --reads  PMJ.fastq.gz \
        --output PMJ.gapfilled  \
        --threads 32 \
        --ne \
        >pipe.log 2>pipe.err

polca.sh -a PMJ.polished_HiC.fa \
    -r 'PMJ_SR_1.fq.gz PMJ_SR_2.fq.gz' \
    -t 32
    -m 4G

mv PMJ.polished_HiC.PolcaCorrected.fa PMJ.final.fa