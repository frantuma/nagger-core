#!/bin/bash

CUR=$(pwd)
SCRIPTDIR="$(dirname -- "${0}")/"
BASEDIR="$SCRIPTDIR/../"

SC_RELEASE_TAG="v$SC_VERSION"


#####################
### deploy gradle plugin release
#####################
cd modules/swagger-gradle-plugin
#./gradlew publishPlugins --info
./gradlew build --info
cd ../..

#####################
### publish pre-prepared release (tag is created)
#####################
$CUR/CI/publishRelease.py "$SC_RELEASE_TAG"

#####################
### update the version to next snapshot in maven project with set version
#####################
./mvnw versions:set -DnewVersion=SC_NEXT_VERSION-SNAPSHOT
./mvnw versions:commit

#####################
### update all other versions in files around to the next snapshot or new release, including readme and gradle ###
#####################

sc_find="version=$SC_VERSION"
sc_replace="version=$SC_NEXT_VERSION-SNAPSHOT"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/gradle.properties

sc_find="ft.nagger.core.v3:swagger-jaxrs2:$SC_VERSION"
sc_replace="ft.nagger.core.v3:swagger-jaxrs2:$SC_NEXT_VERSION-SNAPSHOT"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/src/main/java/io/swagger/v3/plugins/gradle/SwaggerPlugin.java

sc_find="name: 'swagger-jaxrs2', version:'$SC_VERSION"
sc_replace="name: 'swagger-jaxrs2', version:'$SC_NEXT_VERSION-SNAPSHOT"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/src/test/java/io/swagger/v3/plugins/gradle/SwaggerResolveTest.java


#####################
### update wiki links
#####################
