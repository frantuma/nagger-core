#!/bin/bash

CUR=$(pwd)
SCRIPTDIR="$(dirname -- "${0}")/"
BASEDIR="$SCRIPTDIR/../"

SC_LAST_RELEASE = $1
SC_VERSION = $2

#####################
### update Wiki
#####################
sc_find="currently $SC_VERSION-SNAPSHOT"
sc_replace="currently $SC_NEXT_VERSION-SNAPSHOT"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/README.md

sc_find="$SC_LAST_RELEASE\/"
sc_replace="SC_VERSION\/"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/Swagger-2.X---Annotations.md

