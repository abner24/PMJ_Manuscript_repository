samtools faidx PMJ.polished.fa
cut -f1,2 PMJ.polished.fa.fai > PMJ.polished.fa.sizes

mkdir fastq
ln -s PMJ3_OmC_R1_001.fq.gz fastq/
ln -s PMJ3_OmC_R2_001.fq.gz fastq/

juicer/juicer.sh -g genomeID -s none -S early -p PMJ.polished.fa.sizes \
    -z PMJ.polished.fa

3d-dna/run-assembly-pipeline.sh --editor-repeat-coverage 5 \
    PMJ.polished.fa aligned/merged_nodups.txt 

