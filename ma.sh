#!/bin/bash
##############################################################################
# This is an experimental shell script implementing the 
# algorithm explained in this article:
# Janssens, A. C. J. W., & Gwinn, M. (2015). 
# Novel citation-based search method for scientific literature: 
# application to meta-analyses. BMC Medical Research Methodology, 15, 84. 
# http://doi.org/10.1186/s12874-015-0077-z
#
# This is for Unix/Linux based systems with bash and Entrez Direct (Not tested on Mac) 
# Follow Instructions here to install Entrez Direct
# http://www.ncbi.nlm.nih.gov/books/NBK179288/
# Also refer the page above for terms and conditions of use of Entrez Direct
# Install xml-twig-tools using the command: sudo apt-get install xml-twig-tools
#
# By
# Bell R Eapen
# http://nuchange.ca
# Date: November 14, 2015
# IRC: ##ehealth
###############################################################################
echo "Finding Articles citing the given reference....."
for var in "$@"
do 
    # To prevent querying pubmed too fast
    sleep 3
    
    # Message
    echo "Processing" $var
    
    # Finding the articles citing the key article in STEP 1
    # https://www.biostars.org/p/106301/   
    # Why </dev/null See this: http://stackoverflow.com/questions/13800225/shell-script-while-read-line-loop-stops-after-the-first-line
    esearch -db pubmed -query $var </dev/null | elink -related -name pubmed_pubmed_citedin | efetch -mode xml > $var.xml
    
    # On ubuntu/debian, xml_grep is in the xml-twig-tools package.
    # Find PMIDs from the xml file
    xml_grep 'PMID' $var.xml > $var.001
    # Remove tags
    sed -e 's/<[^>]*>//g' $var.001 > $var.002
    # Remove Blank Lines
    sed '/^\s*$/d' $var.002 > $var.003
    # Remove duplicates
    sort -u $var.003 >> static.txt
    # Remove Temporary Files
    rm $var.xml
    rm $var.001
    rm $var.002
    rm $var.003
done
    # Final Sorting
    # final.txt contains the articles citing the given articles in the command line.
    sort  -u static.txt > final.txt
    #save number of articles for loop
    article_no=$(cat final.txt | wc -l)	
    #save for percentage calculation
    article_count=$(cat final.txt | wc -l) 
    # Delete static file
    rm static.txt


echo "Finding Co-citations. This may take several hours..........."
while read -r var; do
    # To prevent querying pubmed too fast
    sleep 3
    # Message
    article_no=$((article_no-1))
    echo "Processing" $var $article_no " more to process.."
    # https://www.biostars.org/p/106301/
    esearch -db pubmed -query $var </dev/null | elink -related -name pubmed_pubmed_refs | efetch -mode xml > $var.xml

# If the xml output file is not empty
if [ -s $var.xml ]
    then
    # On ubuntu/debian, xml_grep is in the xml-twig-tools package.
    xml_grep 'PMID' $var.xml > $var.001
    # Remove tags
    sed -e 's/<[^>]*>//g' $var.001 > $var.002
    # Remove Blank Lines
    sed '/^\s*$/d' $var.002 > $var.003
    # Remove duplicates
    sort -u $var.003 >> static.txt

    # Remove Temporary Files
    rm $var.001
    rm $var.002
    rm $var.003
fi
    rm $var.xml
done < final.txt

# If the static.txt file is not empty
if [ -s static.txt ]
    then
    # Count occurences
    # results txt contains the co-citation frequency
    sort static.txt | uniq -c > temp.txt
    # Final sorting of results
    sort -nr temp.txt > results.txt
    # Delete static file
    rm static.txt
    rm temp.txt
else
    echo "No Co-Citation found"
fi
    rm final.txt

echo "Finding Details of top articles. This may take few minutes..........."
rm details.txt
while read -r var; do
    # To prevent querying pubmed too fast
    sleep 3
    # Message
    echo "Processing" $var
    IFS='   ' read -a counts <<< "$var"
    cocite = ${counts[0]}
    pmid = ${counts[1]}
    cocite_index = $((cocite*100/article_count))
if ["$cocite_index" -gt 10]
    # https://www.biostars.org/p/106301/
    echo "---------------------" >> details.txt
    echo "PMID: " $pmid "Co-Citations: " $cocite "Co-Citation Index: " $cocite_index >> details.txt
    esearch -db pubmed -query $pmid </dev/null | efetch -mode txt >> details.txt
fi
done < results.txt