#Retrieve things from TSV
import sys
    
if __name__=="__main__":
    ids_file = sys.argv[1]
    tsv_file = sys.argv[2]
    new_tsv = sys.argv[3]
    
    with open(new_tsv, "w") as write:
        with open(ids_file, "r") as ids:
            for i in ids:
                i = i.rstrip()
                with open(tsv_file, "r") as tsv:
                    for line in tsv:
                        if i in line:
                            print(line.rstrip(), file=write)
                            break
                tsv.close
        ids.close
    write.close
    
    