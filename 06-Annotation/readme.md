# Genome Annotation
The following pre-requisites is required for the annotation of PMJ genome. Which is then passed in as options to MAKER using the CTL file.
1. A set of non-redundant transcripts from various tissue sites. In this project various floral tissues, leaves and roots of the matured orchid was used to identify as many transcripts as possible. The transcripts were assembled using StringTie.
2. A database of repeat library, generated de-novo using RepeatModeler
3. A protein set of closely related species (In this project the following protein sets were used: A.thaliana, O.sativa, D.officinale, A.shenzhenica, V.planifolia)

The following workflow is used to train gene models using Augustus and SNAP:
- Select AED < 0.3.
- keep a set of non-rendundant isoforms.
- Partially gene models are removed.
- Blast protien sequences to filter out similar sequences.
- Create a training and test dataset for SNAP and Augustus.

Annotation Results are in is folder:
- PMJ.gff.gz: Contains a list of non-redundant annotation models created by Maker corresponding to the genome deposited in NCBI.
- PMJ.aa.gz: Contains the translated protein sequences.
- PMJ.cds.gz: Coding sequences.
