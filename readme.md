# PMJ Manuscript repository

This is a repository for the codes and parameter used in the assembly of PMJ genome which uses a combination of Oxford Nanopore long-reads, Illumina short reads and Dovetail Omni-C for proximity ligation. The assembly process goes through iterations: 

1. Genome survey (KMC3 and Genomescope 2)
1. assembly (Flye v2.9)
2. duplicate purging (purge_dups)
3. polishing (PoLCA)
4. scaffolding (3D-DNA)
5. gap-filling  (TGS-GapCloser)
6. final polishing round (PoLCA)

Genome annotation follows the assembly process using RNA-Seq from the various mature PMJ tissue such as the leaves, root and flower. The genome annotation process is done with the following manner:

1. De novo identification of repeat families (RepeatModeler)
2. Masking of low complexity and interspersed repeat elements (RepeatMasker v4.03)
3. Mapping of RNA-Seq reads onto the PMJ Genome (HiSAT2)
4. Transcript assembly using evidence of aligned RNA-Seq (StringTie)
5. Merging of transcript assembly from different sets of RNA-Seq libraries (StringTie)
6. Combining evidence from RepeatMasking, transcript assembly and protein evicence from closely related species into a final set of evidence based annotation (MAKER3)

Scripts used for differential expression can be found in the analysis folder.
The purpose of these scripts is for analysis reproduction so the parameters, script execution can be documented. This set of scripts might not be portable and might require the user to thinker with computing environments.

