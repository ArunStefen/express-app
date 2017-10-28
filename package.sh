#! /bin/bash

SHA1=$1


# Create new Elastic Beanstalk version
EB_BUCKET=ovc-cc
DOCKERRUN_FILE=beanstalk/Dockerrun.aws.json

VERSION=${SHA1}
echo $VERSION

export AWS_DEFAULT_REGION=us-east-1

sed "s/TAGNAME/$VERSION/" $DOCKERRUN_FILE > Dockerrun.aws.json
zip -X CC_${SHA1}.zip Dockerrun.aws.json

aws s3 cp CC_${SHA1}.zip s3://$EB_BUCKET/$VERSION/CC_${SHA1}.zip

aws elasticbeanstalk create-application-version --application-name CrossChannel  --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=${VERSION}/CC_${SHA1}.zip

# Update Elastic Beanstalk environment for dtrc to new version
aws elasticbeanstalk update-environment --environment-name dt-cross-channel-rc --version-label $VERSION