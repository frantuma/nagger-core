#!/bin/bash
#export SC_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#export SC_NEXT_VERSION=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#SC_QUALIFIER=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${parsedVersion.qualifier}' --non-recursive build-helper:parse-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
#SC_LAST_RELEASE=`./mvnw -q -Dexec.executable="echo" -Dexec.args='${releasedVersion.version}' --non-recursive build-helper:released-version org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`

##################################
##################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!! removE !!!!!!!!!!!!!!!!!!!!!
# SC_LAST_RELEASE=2.1.3
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
TMPDIR="$(dirname -- "${0}")"

SC_RELEASE_TAG="v$SC_VERSION"

echo "CUR $CUR"
echo "SCRIPTDIR $SCRIPTDIR"
echo "BASEDIR $BASEDIR"
#####################
### publish javadocs
#####################

git status

ls $CUR/modules/swagger-annotations/target
ls $CUR/modules/swagger-annotations/target/javadocprep
ls $CUR/modules/swagger-annotations/target/javadocprep/swagger-core

cp -aR $CUR/modules/swagger-annotations/target/javadocprep/swagger-core/${SC_VERSION}/apidocs $TMPDIR
cp -a $CUR/CI/publish-javadocs.sh $TMPDIR/publish-javadocs.sh

