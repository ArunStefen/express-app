#!/bin/sh

VERSION=$1

EB_BUCKET=express-test
SOURCE_BUNDLE="${VERSION}.zip"
S3_KEY="ET/${SOURCE_BUNDLE}"

sed -i -e "s/:TAGNAME/:$VERSION/" Dockerrun.aws.json
zip -r "$SOURCE_BUNDLE"  Dockerrun.aws.json .ebextensions/
sed -i -e "s/:$VERSION/:TAGNAME/" Dockerrun.aws.json

aws s3 cp "$SOURCE_BUNDLE" s3://$EB_BUCKET/$S3_KEY
aws elasticbeanstalk create-application-version --application-name ExpressTest --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$S3_KEY