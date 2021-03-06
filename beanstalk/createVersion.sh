#!/bin/sh

VERSION=$1
BRANCH=$2

echo "VERSION: $VERSION"
echo "BRANCH: $BRANCH"

if [ "$BRANCH" ]
then
	VERSION=${VERSION}_${BRANCH}
fi

EB_BUCKET=express-test-ovc
SOURCE_BUNDLE="${VERSION}.zip"
S3_KEY="ET/${SOURCE_BUNDLE}"

sed -i -e "s/:TAGNAME/:$VERSION/" beanstalk/Dockerrun.aws.json
zip -r "$SOURCE_BUNDLE"  beanstalk/Dockerrun.aws.json beanstalk/.ebextensions/
sed -i -e "s/:$VERSION/:TAGNAME/" beanstalk/Dockerrun.aws.json

export AWS_DEFAULT_REGION=us-east-1
# cp "$SOURCE_BUNDLE" "beanstalk/$SOURCE_BUNDLE"

aws s3 cp "$SOURCE_BUNDLE" s3://$EB_BUCKET/$S3_KEY
aws elasticbeanstalk create-application-version --application-name ExpressTest --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$S3_KEY
