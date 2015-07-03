#!/usr/bin/bash
while test 1 -gt 0; do
        case "$1" in
                -h)
                        echo "Script to randomly sample a fastq file to the same number of lines as another fastq."
                        echo "options:"
                        echo "-h,       Show brief help."
                        echo "-f1,      First, larger, input fastq."
                        echo "-f2,      Second, smaller, input fastq."
                        echo "-o,       Name of output file"
                        exit 0
                        ;;
                -f1)
                        shift
                        if test $# -gt 0; then
                                export FQ_ONE=$1
                                echo "Using "$QA_ONE" as first, larger fastq file."
                        fi
                        shift
                        ;;
                -f2)
                        shift
                        if test 1 -gt 0; then
                                export FQ_TWO=$1
                                echo "Using "$FQ_TWO" as second, smaller fastq file."
                        fi
                        shift
                        ;;

                -o)
                        shift
                        if test 1 -gt 0; then
                                export OUTPUT=$1
                                echo "Writing to: "$OUTPUT
                        else
                                echo "No output file provided."
                                break
                        fi
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done

if [ -z $FQ_ONE ]; then
        echo "First fastq missing, exiting."
        exit
fi
if [ -z $FQ_TWO ]; then
        echo "Second fastq missing, exiting."
        exit
fi
if [ -z $OUTPUT ]; then
        echo "output file missing, exiting."
        exit
fi

#write line counts for both files

WC_FQ_ONE="$(wc -l $FQ_ONE | sed 's/[^0-9]*//g')"
WC_FQ_TWO="$(wc -l $FQ_TWO | sed 's/[^0-9]*//g')"

LITTLE=$"$((WC_FQ_TWO / 4))"
BIG=$"$((WC_FQ_ONE / 4))"

#generate the random reads to be pulled for subsample

ID=$"`shuf -i 1-$BIG -n $LITTLE`"
#echo $ID | sed 's/ /,/g' > macfarll_temp
rm macfarll_temp $OUTPUT 2> /dev/null
touch macfarll_temp
#for i in $((ID * 4)); do echo $i >> macfarll_temp; done
for i in $ID; do echo $((i * 4)) >> macfarll_temp; done


#Next, use awk to print these lines, plus their subsequent 4 lines to the new file...
for i in `cat macfarll_temp`; do awk 'NR>='$((i - 3))'&&NR<='$i'' $FQ_ONE >> $OUTPUT; done

rm macfarll_temp 2> /dev/null
