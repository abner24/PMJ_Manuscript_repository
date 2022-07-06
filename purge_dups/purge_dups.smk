import pandas as pd
from pathlib import Path
import sys
import glob
import os

configfile: "config.yaml"

assembly = config['assembly']
purgeDup_bin = config['purgeDups']
ref = assembly.split('.')[0]

rule target:
    input: 
        'purged.fa', 
        'hap.fa'

rule index_ref:
    input: assembly
    output: '{}.idx'.format(ref)
    conda: "/fs/abner/workflows/env/minimap2.yml"
    message: "minimap2 -t {threads}"
    params:
        preset = 'map-ont'
    threads: 16
    log:
        "logs/minimap2/index_ref.log"
    shell:
        """
            minimap2 -t {threads} -x {params.preset} -d {output} {input} 2> {log}
        """

rule split_fa:
    input: config['assembly']
    output: '{}.split.fa'.format(ref)
    message: "Preparing reference for self alignment."
    threads: 1
    log: "logs/purge_dups/split_fa.log"
    params: 
        bin = '{}/split_fa'.format(purgeDup_bin)
    shell:
        """
            {params.bin} {input} > {output}
        """

rule minimap_self:
    input: '{}.split.fa'.format(ref)
    output: '{}.split.paf.gz'.format(ref)
    conda: '/fs/abner/workflows/env/minimap2.yml'
    message: 'Performing self alignment with minimap2.'
    threads: 16
    params:
        preset = 'asm5'
    log: 'logs/minimap2/self_alignment.log'
    shell:
        """
        ( minimap2 -x{params.preset} -DP -t {threads} \
            {input} {input} | pigz -p 8 - > {output} ) 2> {log}
        """

fq = [Path(i).name.replace('.fq.gz','') for i in glob.glob('fastq/*.fq.gz')]

rule minimap2:
    input: 
        idx = '{}.idx'.format(ref),
        fq = 'fastq/{sample}.fq.gz'
    output: 'paf/{sample}.read.paf.gz' 
    conda: '/fs/abner/workflows/env/minimap2.yml'
    message: 'aligning minimap2 in {wildcards.sample}'
    threads: 16
    params:
        preset = 'map-ont'
    log: 'logs/minimap2/{sample}.log'
    shell:
        """
            (minimap2 -x{params.preset} -t {threads} {input.idx} {input.fq} |\
                pigz -p8 - > {output}) 2> {log}
        """

rule purge_dups:
    input:
        asm = assembly,
        self_asm = '{}.split.paf.gz'.format(ref),
        fastq = expand('paf/{sample}.read.paf.gz', sample = fq)
    output: 'purged.fa', 'hap.fa'
    message: 'Running purge duplicates'
    threads: 1
    params:
        bin = purgeDup_bin
    log: 'logs/purge_dups.log'
    shell:
        """
            {params.bin}/pbcstat paf/*.read.paf.gz
            {params.bin}/calcuts PB.stat > cutoffs 2> calcults.log
            {params.bin}/purge_dups -a 75 -2 -T cutoffs -c PB.base.cov {input.self_asm} > dups.bed 2> purge_dups.log

            {params.bin}/get_seqs dups.bed {input.asm} > purged.fa 2> hap.fa
        """


    

