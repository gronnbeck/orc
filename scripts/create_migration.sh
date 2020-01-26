#/bin/bash

PREFIX=`date '+%Y%m%d%H%M%S'`

FILE_CREATED=migrations/${PREFIX}_$1.sql

touch $FILE_CREATED

echo "Migration file created: $FILE_CREATED"