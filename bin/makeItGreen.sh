#!/usr/bin/env bash

#cd ~/repos/concourse-spring-music
cp src/main/webapp/assets/css/green-app.css src/main/webapp/assets/css/app.css
git add src/main/webapp/assets/css/app.css
git commit -m 'making banner green'
git push
