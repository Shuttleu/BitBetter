#!/bin/bash

EMAIL=$1
ID=$2

LOWER_ID=`echo ${ID,,}`
UPPER_ID=`echo ${ID^^}`
DB_PASS=`grep -o 'DB_PASS="[^"]*' secrets.env | grep -o '[^"]*$'`
DATA_FOLDER=`grep -o 'DATA_FOLDER="[^"]*' secrets.env | grep -o '[^"]*$'`

./run.sh user "Name" "$EMAIL" "$LOWER_ID" > temp.json

tail -c +8 temp.json > trunc.json

dos2unix trunc.json

LICENSE=`grep -o '"LicenseKey": "[^"]*' trunc.json | grep -o '[^"]*$'`
EXPIRE=`grep -o '"Expires": "[^"]*' trunc.json | grep -o '[^"]*$' | tr T " " | tr -d Z`

cp trunc.json $DATA_FOLDER/core/licenses/user/$LOWER_ID.json

docker run -i --rm --network=docker_default mcr.microsoft.com/mssql/server:2022-CU11-ubuntu-22.04 /opt/mssql-tools/bin/sqlcmd -S mssql -U sa -P $DB_PASS -d vault -N -C -Q "UPDATE UserView SET MaxStorageGb=10240, PremiumExpirationDate='$EXPIRE', Premium=1, LicenseKey='$LICENSE' WHERE Id = '$UPPER_ID';"