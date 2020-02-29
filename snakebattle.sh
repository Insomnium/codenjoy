#!/bin/bash

ROOT="$(pwd)/CodingDojo"
GAME=snakebattle

export OAUTH2_CLIENT_ID=dojo
export OAUTH2_CLIENT_SECRET=secret
export OAUTH2_AUTH_SERVER_URL=https://login-staging.telescopeai.com/core
export OAUTH2_AUTH_URI=/connect/authorize
export OAUTH2_TOKEN_URI=/connect/token
export OAUTH2_USERINFO_URI=/connect/userinfo
export OAUTH2_JWKS_URI=/.well-known/jwks
export CLIENT_NAME=dojo

function log() {
    echo "###################################################"
    echo "#  $1                                              "
    echo "###################################################"
}


cd "$ROOT/games/engine"
log "Building engine"
$ROOT/mvnw clean install -DskipTests

cd "$ROOT/games"
log "Refreshing games pom.xml"
$ROOT/mvnw clean install -N -DskipTests 

cd "$ROOT/games/$GAME"
log "Building $GAME"
$ROOT/mvnw clean install -DskipTests -q

cd "$ROOT/server"
log "Running game server"
$ROOT/mvnw clean spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005 -Dmaven.test.skip=true -Dspring.profiles.active=sqlite,$GAME,debug -Dserver.port=8080 -Dadmin.password=supersecurepassword" "-P$GAME"


#cd ./CodingDojo/server
#mvn spring-boot:run -Dmaven.test.skip=true -Dspring.profiles.active=sqlite,loderunner,debug -Dserver.port=8888 -Ploderunner
#cd ../../
