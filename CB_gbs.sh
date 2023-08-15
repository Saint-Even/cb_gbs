#!/bin/bash

#requires an input and output dir
#input dir must contain these dirs,
#barcodeLinks readLinks refgenome

echo "Begin: cassetteBuilder for cassetteGBS"

: <<'BLOCK'
BLOCK

echo "Names must be formatted:"
echo -e "<runName>_barcodes.txt, \n<runName>_R1.fastq.gz, \n<runName>_R2.fastq.gz"
echo "Files in refgenome, barcodeLinks and readLinks must be symlinks"

#clear output dir
rm -r output/
mkdir output

#report input contents for user reference
echo "Files currently in input:"
cd input

echo "============refgenome ============"
cd refgenome
ls -1 *
cd ..
echo "========================"

echo "============barcodeLinks============"
cd barcodeLinks
ls -1 *
cd ..
echo "========================"

echo "=============readLinks==========="
cd readLinks
ls -1 *
cd ..
echo "========================"

cd ..



#make runName manifest from R1 files
declare -a manf
for f in $(ls -1 input/readLinks/*_R1.fastq.gz); do
    manf+=($(echo "${f}" | sed s:"_R1.fastq.gz":"":g | sed s:"input/readLinks/":"":g))
done

echo "Cassettes will be created for the following runNames"
echo "========================="
for i in "${manf[@]}"; do
    echo $i
done
echo "========================="

#assemble cassettes: barcode file, read symlinks, refgen symlinks, key file
for i in "${manf[@]}"; do
    mkdir -p output/cassette_${i}
    cp input/barcodeLinks/${i}_barcodes.txt output/cassette_${i}/
    cp -a input/readLinks/${i}*.fastq.gz output/cassette_${i}/
    cp -ra input/refgenome output/cassette_${i}
    touch output/cassette_${i}/key_${i}
done

: <<'BLOCK'
BLOCK

# end of script
exit 0

#example contents of a cassette_runName
key_NS.1726.002.B717---B503.GBS_AAFC-Brandon_2021_P01
NS.1726.002.B717---B503.GBS_AAFC-Brandon_2021_P01_barcodes.txt
NS.1726.002.B717---B503.GBS_AAFC-Brandon_2021_P01_R1.fastq.gz
NS.1726.002.B717---B503.GBS_AAFC-Brandon_2021_P01_R2.fastq.gz
refgenome
runConfig.yaml
