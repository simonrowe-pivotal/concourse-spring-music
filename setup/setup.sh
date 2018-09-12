#!/bin/bash

#Start up concourse locally
docker-compose up -d

#start up localstack (local version of s3 locally)
docker run -d --name=localstack -e SERVICES=s3 -p9080:8080 -p4567-4583:4567-4583 localstack/localstack

#create s3 buckets + folders and files:
awslocal s3api create-bucket --bucket spring-music-sjr
awslocal s3 sync deployments/ s3://spring-music-sjr/deployments
awslocal s3 sync pipeline-artifacts/ s3://spring-music-sjr/pipeline-artifacts 

#setup pcf-dev spaces
cf login -a https://api.local.pcfdev.io -u admin -p admin --skip-ssl-validation -o pcfdev-org
cf create-space development
cf create-space test
cf create-space uat
cf create-space production

#set pipelines in concourse
fly -t local login -c http://localhost:8080
fly -t local sp -p spring-music -c pipeline-localstack-s3.yml -l spring-music-pcfdev-credentials.yml -v"GIT_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)"
fly -t local up -p spring-music
