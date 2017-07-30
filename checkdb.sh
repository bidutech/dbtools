#!/bin/bash
echo "************************************start check the online  and test db**************************************"
echo "************************************start get online db info*************************************************"

HOSTNAME="82.92.52.10"
PORT="3306"
UNAME="uc"
PASSWORD="uccim"
DBNAME="uc"
outfolderonline="./""$DBNAME"
echo $outfolderonline
if [ ! -d $outfolderonline ]; then
  mkdir $outfolderonline
fi
cd $outfolderonline
pwd
rm -rf *
sqlcommand="show tables;"
TABLESKIP="TABLES_IN_UC"
mysql -h${HOSTNAME}  -P${PORT}  -u${UNAME} -p${PASSWORD} ${DBNAME} -e "${sqlcommand}" |
while read line ;
do
   # echo "$line" ;
    if [ "$line"_x  !=  "$TABLESKIP"_x ] 
    then
    echo "$line" ;
    mysqldump -h${HOSTNAME} -P${PORT} -u${UNAME} -p${PASSWORD} ${DBNAME} -d $line >$line.sql
    fi
done
cd ../
pwd
echo "************************************start get test db info*************************************************"

HOSTNAME_TEST="89.97.52.108"
PORT_TEST="3306"
UNAME_TEST="uc_test"
PASSWORD_TEST="iim"
DBNAME_TEST="uc_test"
outfoldertest="./""$DBNAME_TEST"
echo $outfoldertest
if [ ! -d $outfoldertest ]; then
  mkdir $outfoldertest
fi
cd $outfoldertest
pwd
rm -rf *
sqlcommand="show tables;"
TABLESKIP="TABLES_IN_UC_TEST"
mysql -h${HOSTNAME_TEST}  -P${PORT_TEST}  -u${UNAME_TEST} -p${PASSWORD_TEST} ${DBNAME_TEST} -e "${sqlcommand}" |
while read line ;
do
   # echo "$line" ;
    if [ "$line"_x  !=  "$TABLESKIP"_x ]
    then
    echo "$line" ;
    mysqldump -h${HOSTNAME_TEST} -P${PORT_TEST} -u${UNAME_TEST} -p${PASSWORD_TEST} ${DBNAME_TEST} -d $line >$line.sql
    fi
done
cd ../
pwd
OUTDIFFNAME="db_""$DBNAME""_and_""$DBNAME_TEST""_diff.txt"
echo  $OUTDIFFNAME

if [  -f "$OUTDIFFNAME" ];
then
  rm -rf  "$OUTDIFFNAME"
fi

diff  $outfolderonline $outfoldertest  > $OUTDIFFNAME

path=`pwd`"$OUTDIFFNAME"
echo "$DBNAME_and_$DBNAME_TEST diff result file path:""$path"
echo ""
echo "*****************************diff  end******************************************"
echo "please view the file:""$path"
echo "******************************end**************************************************"
echo ""
echo ""
#if [  -f "$OUTDIFFNAME" ]; 
#then
 # echo  "$OUTDIFFNAME"
#fi
