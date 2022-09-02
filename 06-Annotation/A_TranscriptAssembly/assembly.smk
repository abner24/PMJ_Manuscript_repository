import os

fqdir = "fastq/"
read1 = [read for read in os.listdir(fqdir) if read.endswith('_1.fq.gz')]
SAMPLES = [sample[:-8] for sample in read1]

rule all:
    input: "stringtie/merged.fa"

rule trimmomatic_PE:
    input:
        r1 = 'fastq/{sample}_1.fq.gz',
        r2 = 'fastq/{sample}_2.fq.gz'
    output:
        r1 = 'trimmed/{sample}_1.fq.gz',
        r2 = 'trimmed/{sample}_2.fq.gz',
        r1_unpaired = 'trimmed/{sample}_1.unpaired.fq.gz',
        r2_unpaired = 'trimmed/{sample}_2.unpaired.fq.gz'
    log:
        "logs/trimmomatic/{sample}.log"
    params:
        trimmer = ['ILLUMINACLIP:TruSeq3-PE.fa:2:30:10', 'SLIDINGWINDOW:4:5', 'LEADING:5', 'TRAILING:5', 'MINLEN:25'],
        extra = '',
        compression_level='-5'
    threads: 8
    wrapper:
        "0.72.0/bio/trimmomatic/pe"

rule hisat2_align:
    input:
      index=directory("index_VMJ/"),
      reads=["trimmed/{sample}_1.fq.gz", "trimmed/{sample}_2.fq.gz"]
    output:
      "mapped/{sample}.bam"
    log:
        "logs/hisat2_align_{sample}.log"
    params:
      extra="",
      idx="index_VMJ/",
    threads: 16
    wrapper:
      "0.78.0/bio/hisat2/align"

rule sort:
    input:
        unSrt = "mapped/{sample}.bam"
    output:
        srt = "mapped/{sample}.sort.bam"
    log:
        "logs/sort/samtools_{sample}.log"
    threads: 16
    shell:
        """
        (samtools sort \
            -@ {threads} \
            -o {output.srt} \
            {input.unSrt} )2> {log}
        """

rule stringtie:
    input:
        bam = "mapped/{sample}.sort.bam"
    output:
        gtf = "stringtie/{sample}/{sample}.gtf"
    params:
        st = stringtie,
        label = "{sample}"
    log:
        "logs/stringtie/stringtie_{sample}.log"
    threads: 16
    shell:
        "({params.st} "
            "-p {threads} "
            "-o {output.gtf} "
            "-l {params.label} "
            "{input.bam} )"
        "2> {log}"

rule stringtie_merge:
    input: expand("stringtie/{sample}/{sample}.gtf", sample = SAMPLES)
    output: "stringtie/merged.gtf"
    params:
        st = stringtie
    log:
        "logs/stringtie/merge.log"
    threads: 4
    shell:
        """
        {params.st} --rf --merge -p {threads} -o {output} {input}
        """

rule extract_fa:
    input:
        fasta = "PMJ.final.fa",
        gtf = "stringtie/merged.gtf"
    output: "stringtie/merged.fa"
    log: "logs/stringtie/agat.log"
    shell:
        """
        agat_sp_extract_sequences.pl \
            --cdna \
            --gff {input.gtf} \
            --fasta {input.fasta} \
            -o {output}
        """
    

