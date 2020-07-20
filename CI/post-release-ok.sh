#!/bin/bash
export SC_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
export SC_NEXT_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_QUALIFIER=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.qualifier}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
SC_LAST_RELEASE=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${releasedVersion.version}' --non-recursive build-helper:released-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`

##################################
##################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!! removE !!!!!!!!!!!!!!!!!!!!!
SC_LAST_RELEASE=2.1.3
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##################################
##################################


echo "GPG_PASSPHRASE $GPG_PASSPHRASE"
echo "GHUSER $GH_USER"
echo "version $SC_VERSION"
echo "qual $SC_QUALIFIER"
echo "last $SC_LAST_RELEASE"
echo "next $SC_NEXT_VERSION"

CUR=$(pwd)
SCRIPTDIR="$(dirname -- "${0}")/"
BASEDIR="$SCRIPTDIR/../"

SC_RELEASE_TAG="v$SC_VERSION"

echo "CUR $CUR"
echo "SCRIPTDIR $SCRIPTDIR"
echo "BASEDIR $BASEDIR"
#####################
### publish javadocs
#####################

git status
git diff

ls $CUR/modules/swagger-annotations/target
ls $CUR/modules/swagger-annotations/target/javadocprep

git checkout gh-pages

mkdir -p $CUR/swagger-core/${SC_RELEASE_TAG}/apidocs
cp -a $CUR/modules/swagger-annotations/target/javadocprep/ $CUR/swagger-core/${SC_RELEASE_TAG}/apidocs/
git add -A
git commit -m "apidocs for release ${SC_RELEASE_TAG}"
git checkout master

#cd modules/swagger-annotations

# ../../mvnw org.apache.maven.plugins:maven-scm-publish-plugin:publish-scm \
#   -Dscmpublish.username="${GH_USER}" \
#   -Dscmpublish.password="${GH_TOKEN}" \
#   -Dscmpublish.skipDeletedFiles=true \
#   -Dscmpublish.checkoutDirectory=target/scmpublish \
#   -Dscmpublish.checkinComment="Publishing javadoc for swagger-annotations:$SC_VERSION" \
#   -Dscmpublish.content=target/javadocprep \
#   -Dscmpublish.pubScmUrl=scm:git:https://github.com/frantuma/nagger-core \
#   -Dscmpublish.scmBranch=gh-pages

#cd ../..

#####################
### update wiki
#####################



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