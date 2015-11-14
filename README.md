# Finding Articles for Meta-Analysis

> Finding the right articles for a systematic review or meta-analysis is the most challenging part. Janssens et. al has published a novel algorithm to expedite the process of finding eligible studies for meta-analysis based on the degree of co-citation. I have written a small shell script to implement the algorithm for PubMed using Entrez Direct. 

## How to install:
- Get hold of a Linux box. 
- Install Entrez Direct from NCBI by cutting and pasting the code below.
```sh
cd ~
  perl -MNet::FTP -e \
    '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1); $ftp->login;
     $ftp->binary; $ftp->get("/entrez/entrezdirect/edirect.zip");'
  unzip -u -q edirect.zip
  rm edirect.zip
  export PATH=$PATH:$HOME/edirect
  ./edirect/setup.sh

```
- In the terminal window
```sh
sudo apt-get install xml-twig-tools 
```
- Download this script to a writable folder.
- Find the PMID of your key articles.
```sh
./ma.sh <PMID> <PMID> <PMID>   
```
- Example: ./ma.sh 18032878
- Grab a coffee and wait :)
- The results will be written to results.txt in the same folder
- Results include degree of co-citation along with corresponding PMID in each line.
- Enjoy! 

## Contact US
[Send an email](http://nuchange.ca/contact) OR [Join us on PRO{DENTS}](http://prodents.com)

### For more information visit [NuChange Blog](http://nuchange.ca)

### Meet Us on the IRC Channel ##ehealth 
[![Visit our IRC channel](https://kiwiirc.com/buttons/irc.freenode.net/ehealth.png)](https://kiwiirc.com/client/irc.freenode.net/?nick=nuchange|?##ehealth)

### Contribute
pull-requests welcome

## Disclaimer
> THE AUTHOR MAKES NO CLAIM WHATSOEVER, EXPRESSED OR IMPLIED, ABOUT THE AUTHENTICITY, ACCURACY, RELIABILITY, COMPLETENESS OR TIMELINESS OF THE MATERIAL, SOFTWARE, TEXT, GRAPHICS AND LINKS GIVEN. IN NO EVENT SHALL THE AUTHOR BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE AUTHORS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. THE AUTHORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN 'AS IS' BASIS, AND THE AUTHOR HAVE NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.