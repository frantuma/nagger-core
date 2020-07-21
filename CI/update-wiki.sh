#!/bin/bash

CUR=$(pwd)

echo $CUR
ls -la $CUR

#####################
### update Wiki
#####################
cd wiki
sc_find="$SC_LAST_RELEASE\/"
sc_replace="$SC_VERSION\/"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/Swagger-2.X---Annotations.md
git add -A
git commit -m "update javadocs links to ${SC_VERSION}"
git push -u origin master
cd ..

