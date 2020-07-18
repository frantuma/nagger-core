SC_LAST_RELEASE = $1
SC_VERSION = $2

#####################
### excecute updateV1Readme
#####################
$CUR/CI/trigger-updateV1Readme-Action.py "$SC_LAST_RELEASE" "$SC_VERSION"
