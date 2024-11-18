"""
SAMPLING
Positive: 2887 filtered (2904 total)
Negative: 20210 (2392 ‘True’ transmembrane)
"""

mmseqs easy-cluster negative.fasta neg-cluster-results tmp --min-seq-id 0.3 -c 0.4 --cov-mode 0 --cluster-mode 1
mmseqs easy-cluster positive.fasta pos-cluster-results tmp --min-seq-id 0.3 -c 0.4 --cov-mode 0 --cluster-mode 1

#After the mmseqs

grep ">" pos-cluster-results_rep_seq.fasta | wc
#   1085    1085    9817
grep ">" neg-cluster-results_rep_seq.fasta | wc
#   8789    8789   79397

#Retrieve the ids
grep ">" pos-cluster-results_rep_seq.fasta | tr -d ">" > pos.ids
grep ">" neg-cluster-results_rep_seq.fasta | tr -d ">" > neg.ids

wc *ids
# 8789  8789 70608 neg.ids
# 1085  1085  8732 pos.ids

#get the new TSV
python get_TSV.py pos.ids positive.tsv pos-cluster.tsv
python get_TSV.py neg.ids negative.tsv neg-cluster.tsv

wc pos-cluster.tsv
# 1085  6936 44359 pos-cluster.tsv
wc neg-cluster.tsv
#  8789  66240 463642 neg-cluster.tsv

#shuffle
shuf pos-cluster.tsv -o pos-cluster.tsv
shuf neg-cluster.tsv -o neg-cluster.tsv


#split in the train and the benchmark sets, add a column on the train file to identify the cross-validation set


"""
	#add a column for the sets
	python get_sets.py pos-cluster.tsv pos-sets.tsv 1085

	#NOTE:
	#0 -> benchmark (test set) 
	#1-5 -> cross-validation

	wc pos-sets.tsv
	# 1085  8021 46529 pos-sets.tsv
	cut -f 6 pos-sets.tsv | grep '0'|wc
	# 217     217     434
	cut -f 6 pos-sets.tsv | grep '1'|wc
	# 174     174     348
	cut -f 6 pos-sets.tsv | grep '2'|wc
	# 174     174     348
	cut -f 6 pos-sets.tsv | grep '3'|wc
	# 173     173     346
	cut -f 6 pos-sets.tsv | grep '4'|wc
	# 174     174     348
	cut -f 6 pos-sets.tsv | grep '5'|wc
	# 173     173     346

	python get_sets.py neg-cluster.tsv neg-sets.tsv 8789
	wc neg-cluster.tsv neg-sets.tsv
	# 8789  66240 463642 neg-cluster.tsv
	# 8789  75029 481220 neg-sets.tsv
	cut -f 6 neg-sets.tsv | grep '5'|wc
	# 1407    1407    2814
	cut -f 6 neg-sets.tsv | grep '4'|wc
	# 1406    1406    2812
	cut -f 6 neg-sets.tsv | grep '3'|wc
	# 1406    1406    2812
	cut -f 6 neg-sets.tsv | grep '2'|wc
	# 1406    1406    2812
	cut -f 6 neg-sets.tsv | grep '1'|wc
	# 1406    1406    2812
	cut -f 6 neg-sets.tsv | grep '0'|wc
	# 1758    1758    3516
"""

python get_sets.py pos-cluster.tsv pos-train.tsv pos-bench.tsv 1085
python get_sets.py neg-cluster.tsv neg-train.tsv neg-bench.tsv 8789

wc *bench.tsv *train.tsv
  # 1758  13270  93402 neg-bench.tsv
   # 217   1369   8846 pos-bench.tsv
  # 7031  60001 384302 neg-train.tsv
   # 868   6435  37249 pos-train.tsv


cut -f 6 neg-train.tsv | grep '1'|wc
#   1406    1406    2812
cut -f 6 neg-train.tsv | grep '2'|wc
#   1406    1406    2812
cut -f 6 neg-train.tsv | grep '3'|wc
#   1406    1406    2812
cut -f 6 neg-train.tsv | grep '4'|wc
#   1406    1406    2812
cut -f 6 neg-train.tsv | grep '5'|wc
#   1407    1407    2814
cut -f 6 neg-train.tsv | grep '0'|wc
#      0       0       0
	  
cut -f 6 pos-train.tsv | grep '0'|wc
#      0       0       0
cut -f 6 pos-train.tsv | grep '1'|wc
#    174     174     348
cut -f 6 pos-train.tsv | grep '2'|wc
#    174     174     348
cut -f 6 pos-train.tsv | grep '3'|wc
#    173     173     346
cut -f 6 pos-train.tsv | grep '4'|wc
#    174     174     348
cut -f 6 pos-train.tsv | grep '5'|wc
#    173     173     346


#Training set (pos+neg) = 7899
#Benchmark set (pos+neg) = 1975
#in the training and in the benchmark there is a ration between pos and neg equal to the one before the splitting 

#pos and neg are unbalance so for the evaluation of the method you will take it into account, you can't use accuracy because is affected by the class imbalance
#is not sure that you have an equal distribution of organisms in the different sets. when you split data randomly there is the possibility to have an uneven distribution of the organism (high abundance of a species, this is a problem if you have to use this data to test the generalization performance of the method because you will test the method only in a specific condition). we will check this things with some statistics and visualization to know if there are some biases in our datasets.

