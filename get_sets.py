#Add the column with the benchmarking 
import sys
    
def dividing(total, num):
    end = [round(total/100*20)]
    while num>1:
        end.append(end[-1]+round((total-end[-1])/num))
        num -= 1
    end.append(total)
    return end

if __name__=="__main__":
    start_file = sys.argv[1]
    train_file = sys.argv[2]
    bench_file = sys.argv[3]
    total = int(sys.argv[4])
    
    with open(train_file, "w") as write:
        with open(bench_file, "w") as bench:
            with open(start_file, "r") as read:
                inde = dividing(total, 5) 
                print(inde)
                i=1
                for line in read:
                    line = line.rstrip()
                    for j in range(6):
                        if i<=inde[0]:
                            print(line, file=bench)
                            break 
                        if i<=inde[j]:
                            line = line+'\t'+str(j)
                            print(line, file=write)
                            break                            
                    i+=1                         
            read.close
        bench.close
    write.close
    
#python get_sets.py pos-cluster.tsv pos-train.tsv pos-bench.tsv 1085
#python get_sets.py neg-cluster.tsv neg-train.tsv neg-bench.tsv 8789