#!/bin/bash

#Need to load bowtie and samtools
module load bowtie2
module load samtools 
##script to map and call snps
##build an index of cassava_virus.fna . the name of the index is cassava_virus

bowtie2-build cassava_virus.fna cassava_virus

##map with bowtie2 Results are in sam format. resulta.sam

bowtie2  -x cassava_virus -1 cassava1.fq -2 cassava2.fq -S results.sam

#use samtools for post-processing
#convert sam to bam format

samtools view -bS -o results.bam results.sam

#sort results
samtools sort results.bam -o results.sorted.bam

#index results
samtools index results.sorted.bam



##the file results.sorted.bam contains the binary information of the mapping results. Use this to call snps

### Use freebayes
#need to load freebayes
module load freebayes

freebayes -f cassava_virus.fna results.sorted.bam > possible_SNPs.vcf

##parse the results snps in the vcf file
grep 'gi|' possible_SNPs.vcf | cut -f 1,2,3,4,5,6



#check the aligments using tview

samtools tview results.sorted.bam cassava_virus.fna

 
