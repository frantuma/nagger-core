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


#####################
### build and test maven ###
#####################
./mvnw --no-transfer-progress -B install --file pom.xml

#####################
### build and test gradle ###
#####################
cd ./modules/swagger-gradle-plugin
./gradlew build --info
cd ../..

#####################
### deploy maven release TODO moved to acttion because of GPG issue
#####################
#./mvnw -Dgpg.passphrase=${GPG_PASSPHRASE} --no-transfer-progress -B deploy -Prelease --file pom.xml
#./mvnw --no-transfer-progress -B install -Prelease --file pom.xml
