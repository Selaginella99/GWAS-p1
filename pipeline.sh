cd data2/RESULTS/ml/pipeline/
chmod -R 777 Rcode/
ls -l Rcode/
# cd data2/RESULTS/ml/pipeline/Rcode; chmod -R 777 *; ls -l; cd ..
./pipeline.sh CHS
./pipeline.sh CHS REMOVE
chmod 755 pipeline.sh
# https://en.wikipedia.org/wiki/Chmod
