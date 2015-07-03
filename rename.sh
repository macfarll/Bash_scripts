#FASTA=enter name of file to process below
FASTA=input.fa
cat ${FASTA} | awk '{if (substr($0,1,1)==">"){if (p) {print "\n";} print $0} else printf("%s",$0);P++;}END{print"\n"}' > 1l_fasta_temp.fa
FASTA=1l_fasta_temp.fa
grep ">" ${FASTA} | awk '{printf ">%d\n", NR}' > headers
grep -v ">" ${FASTA} > seqs
paste -d"\n" headers seqs > renumbered.fa
rm seqs headers 1l_fasta_temp.fa
