samtools faidx PMJ.draft.polished.fa
cut -f1,2 PMJ.draft.polished.fa.fai > PMJ.draft.polished.fa.sizes

mkdir fastq
ln -s PMJ3_OmC_R1_001.fq.gz fastq/
ln -s PMJ3_OmC_R2_001.fq.gz fastq/

juicer/juicer.sh -g genomeID -s none -S early -p PMJ.draft.polished.fa.sizes \
    -z PMJ.draft.polished.fa

3d-dna/run-assembly-pipeline.sh --editor-repeat-coverage 5 \
    PMJ.draft.polished.fa aligned/merged_nodups.txt 

