for d in ./target/azure-functions/*/ 
do
echo $d
rm -f $d/lib/*-entity.jar
cp -r ./db/dbjars/$1-entity-$2.jar $d/lib/$1-entity.jar
done