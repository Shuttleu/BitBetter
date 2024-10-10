#! /bin/bash

docker run --rm --network=docker_default -v .:/output mcr.microsoft.com/mssql/server:2022-CU11-ubuntu-22.04 /opt/mssql-tools/bin/sqlcmd -S mssql -U sa -P HgpDYGaK0MGo6LpSfQfuQfI9Wo1Lscxj -d vault -s "," -h -1 -o /output/out.csv -y 36 -Q "SET NOCOUNT ON; SELECT Id, Name, Email, Premium FROM UserView"

while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
do
  id=`echo $rec_column1 | tr -d '[:blank:]'`
  name=`echo $rec_column2 | tr -d '[:blank:]'`
  email=`echo $rec_column3 | tr -d '[:blank:]'`
  premium=`echo $rec_column4 | tr -d '[:blank:]'`

  if [ $premium == 1 ]; then
    echo "$name has premium"
  else
    echo "$name does not have premium, adding now:"
    ./generateAndAssign.sh $email $id
  fi
  echo ""
done < out.csv
