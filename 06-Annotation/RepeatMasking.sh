#!/bin/bash
BuildDatabase -name PMJ PMJ.final.fa
RepeatModeler -pa 16 -database PMJ -LTRStruct