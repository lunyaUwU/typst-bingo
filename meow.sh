
for i in $(seq 1 100);
do
  (time --format=%e typst c --input seed=$i main.typ) 2>> time.txt 
done
