SC_LAST_RELEASE = $1
SC_VERSION = $2

#####################
### excecute updateWiki
#####################
$CUR/CI/trigger-updateWiki-Action.py "$SC_LAST_RELEASE" "$SC_VERSION"
