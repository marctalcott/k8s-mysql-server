# config.sh
#!/bin/bash


echo ""
echo "Setting variables."

NAMESPACE="default"
INTERNAL_MYSQL_PORT="3306"
EXTERNAL_MYSQL_PORT="60000"
APP_NAME="mysql"

TEMPFOLDER="temp" # we use this folder to put generated files and deploy. Then we delete it.


# ********** Edit the variables above as needed ****************

echo ""
echo "Checking folder so we don't accidentally overwrite."
 
if [ -d "$TEMPFOLDER" ]; then
  # Take action if $DIR exists. #
  echo ""
  echo "ABORTING because /${TEMPFOLDER} exists. Either delete the /${TEMPFOLDER} folder or change the config.sh file."
  echo ""
  exit 1
fi
 

#copy the yaml files in this folder to a temp subfolder
echo ""
echo "Creating folder."
mkdir $TEMPFOLDER

echo ""
echo "Copy files to temp folder."
cp *.yaml $TEMPFOLDER

# You also need to set values in the secrets.yaml
echo ""
echo "Replace variables in the yaml files."
# Replace CONFIG_NAMESPACE with $NAMESPACE
find $TEMPFOLDER -name '*.yaml' -exec sed -i '.bak' "s/CONFIG_NAMESPACE/${NAMESPACE}/g" {} +
find $TEMPFOLDER -name '*.yaml' -exec sed -i '.bak' "s/CONFIG_APP_NAME/${APP_NAME}/g" {} +
find $TEMPFOLDER -name '*.yaml' -exec sed -i '.bak' "s/CONFIG_INTERNAL_MYSQL_PORT/${INTERNAL_MYSQL_PORT}/g" {} +
find $TEMPFOLDER -name '*.yaml' -exec sed -i '.bak' "s/CONFIG_EXTERNAL_MYSQL_PORT/${EXTERNAL_MYSQL_PORT}/g" {} +
 
echo ""
echo "Apply files."
kubectl apply -f $TEMPFOLDER

 
# remove temp directory
echo ""
echo "Remove the directory."

rm -r $TEMPFOLDER
 
echo ""
echo "Completed updating Kubernetes."
echo ""
