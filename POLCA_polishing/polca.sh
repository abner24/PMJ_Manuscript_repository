#!/bin/bash

#POLCA version 4.0.3 was used for polishing the draft assembly post duplicate removal with purge_dups.

polca.sh -a PMJ.draft.fa \
    -r 'PMJ_SR_1.fq.gz PMJ_SR_2.fq.gz' \
    -t 32
    -m 4G