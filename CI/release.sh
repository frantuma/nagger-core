#!/bin/bash
# get next release (from maven?, from last release? parseVersion..
mvn build-helper:parse-version
#SC_CUR_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${projects.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#SC_CUR_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${projects.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_NEXT_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_QUALIFIER=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.qualifier}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_LAST_RELEASE=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${releasedVersion.version}' --non-recursive build-helper:released-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#export MY_POM_MAJOR_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.minorVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#export MY_POM_MAJOR_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.incrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#export MY_POM_MAJOR_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${releasedVersion.version}' --non-recursive build-helper:released-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`


##################################
#####################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!! removE !!!!!!!!!!!!!!!!!!!!!
SC_LAST_RELEASE=2.1.3

echo "version $SC_VERSION"
echo "qual $SC_QUALIFIER"
echo "last $SC_LAST_RELEASE"
echo "next $SC_NEXT_VERSION"

CUR=$(pwd)
SCRIPTDIR="$(dirname -- "${0}")/"
BASEDIR="$SCRIPTDIR/../"

echo "cur $CUR"
echo "basedir $BASEDIR"
echo "scriptdir $SCRIPTDIR"

SC_RELEASE_TITLE="Swagger-core $SC_VERSION released!"
SC_RELEASE_TAG="v$SC_VERSION"
echo "title $SC_RELEASE_TITLE"
echo "tag $SC_RELEASE_TAG"
# draft release Notes with next release after last release, with tag
#$SCRIPTDIR/releaseNotes.py "$SC_LAST_RELEASE" "$SC_RELEASE_TITLE" "$SC_RELEASE_TAG"
$CUR/CI/releaseNotes.py "$SC_LAST_RELEASE" "$SC_RELEASE_TITLE" "$SC_RELEASE_TAG"
#echo $SC_RELEASE_TITLE
#echo $SC_RELEASE_NOTES

# update the version to release in maven project with set version and backup using parseVersion maybe..
./mvnw versions:set -DnewVersion=$SC_VERSION
./mvnw versions:commit

#####################
### update all other versions in files around to the new release, including readme and gradle ###
#####################
sc_find="currently $SC_VERSION-SNAPSHOT"
sc_replace="currently $SC_NEXT_VERSION-SNAPSHOT"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/README.md

sc_find="$SC_LAST_RELEASE (\*\*current stable\*\*)"
sc_replace="$SC_LAST_RELEASE                     "
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/README.md

# update readme with a line for the new release replacing the previous
CURDATE=$(date +"%Y-%m-%d")
sc_find="------------------------- | ------------ | -------------------------- | ----- | ----"
sc_add="$SC_VERSION (**current stable**)| $CURDATE   | 3.0           | [tag v$SC_VERSION](https:\/\/github.com\/swagger-api\/swagger-core\/tree\/v$SC_VERSION) | Supported"
sc_replace="$sc_find\n$sc_add"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/README.md

sc_find="\"ft.nagger.core.v3.swagger-gradle-plugin\" version \"$SC_LAST_RELEASE\""
sc_replace="\"ft.nagger.core.v3.swagger-gradle-plugin\" version \"$SC_VERSION\""
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/README.md

sc_find="classpath \"ft.nagger.core.v3:swagger-gradle-plugin:$SC_LAST_RELEASE\""
sc_replace="classpath \"ft.nagger.core.v3:swagger-gradle-plugin:$SC_VERSION\""
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/README.md

sc_find="version=$SC_VERSION\-SNAPSHOT"
sc_replace="version=$SC_VERSION"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/gradle.properties

sc_find="ft.nagger.core.v3:swagger-jaxrs2:$SC_VERSION-SNAPSHOT"
sc_replace="ft.nagger.core.v3:swagger-jaxrs2:$SC_VERSION"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/src/main/java/io/swagger/v3/plugins/gradle/SwaggerPlugin.java

sc_find="name: 'swagger-jaxrs2', version:'$SC_VERSION-SNAPSHOT"
sc_replace="name: 'swagger-jaxrs2', version:'$SC_VERSION"
sed -i -e "s/$sc_find/$sc_replace/g" $CUR/modules/swagger-gradle-plugin/src/test/java/io/swagger/v3/plugins/gradle/SwaggerResolveTest.java

#####################
### build and test maven ###
#####################
./mvnw -B install --file pom.xml

#####################
### build and test gradle ###
#####################
cd ./modules/swagger-gradle-plugin
./gradlew build --info
cd ../..


#	checkout banch prepare-release-2.x.x
#	add and commit to that branch
#	push pR
#	e magari manually MERGE

# add and commit
# create PR
# push PR

#when merged and if release run release action
#		javadocs etc, update releasenotes, publish maven gradle, e finale metti next snapshot e fai PR e push PR direi
# at this point master will run build, and possibly, as we are not in snapshot
    # build and test the thing
    # build and test gradle
    # create javadocs and add to GH pages for annotations?
    # publish maven central
    # publish gradle
    # publish prepared release
    # update wiki
    # update 1.5/master readme
    # bump next snapshot
