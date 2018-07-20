#!/bin/bash

WAR_NAME=`ls $1 | cut -d'.' -f1`
TOMCAT_PATH=`cat $1 | grep "tomcat.dir" | cut -d'=' -f2`
PLUGIN_DIR=`cat $1 | grep "plugin.dir" | cut -d'=' -f2`
BACKUP_DIR=$(date +%d%B%Y)
CURRENT_PATH=$(pwd)

echo "War name : $WAR_NAME";

echo "Creating folder with today's date";
mkdir bkp_$BACKUP_DIR

echo "creating backup folders for plugins and war";
mkdir bkp_$BACKUP_DIR/war bkp_$BACKUP_DIR/plugins

echo "Taking backup of plugin";
cp $PLUGIN_DIR/*.jar bkp_$BACKUP_DIR/plugins
//mv insted of cp

echo "Taking war backup";
cd $TOMCAT_PATH
WAR_NAME=$WAR_NAME.war
cp webapps/$WAR_NAME $CURRENT_PATH/bkp_$BACKUP_DIR/war
//Sri: instead of cp use mv. then you have to rm later

echo "Server Down";
bin/./shutdown.sh -force
//sri: always use pid based start/stop

echo "Removing plugins";
rm $PLUGIN_DIR/*.jar
//sri: remove as per above comment

echo "Removing war"
rm webapps/$WAR_NAME
// sri: why is this not backed?

echo "adding .properties file into tomcat/conf";
cp $CURRENT_PATH/$1 conf/

echo "Adding new plugins";
cp $CURRENT_PATH/plugin_build/*.jar $PLUGIN_DIR

echo "Adding new war";
cp  $CURRENT_PATH/openspecimen.war webapps/

mv webapps/openspecimen.war webapps/$WAR_NAME
//sri: why is this needed?

echo "Server Up..";
bin/./startup.sh
//sri: always start with pid
