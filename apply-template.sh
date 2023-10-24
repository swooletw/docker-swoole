#!/usr/bin/env bash

template=Dockerfile.template
dockerfiles_path=dockerfiles
versions="
5.0.3@8.1
5.0.3@8.2
"

for version in ${versions}; do
  swoole=`echo ${version} | awk -F'@' '{print $1}'`
  php=`echo ${version} | awk -F'@' '{print $2}'`
  path=${dockerfiles_path}/${swoole}/php${php}
  dockerfile_path=${path}/Dockerfile

  mkdir -p ${path}

  cat ${template} | sed "s/{{SWOOLE_VERSION}}/${swoole}/g" | sed "s/{{PHP_VERSION}}/${php}/g" > ${dockerfile_path}

  echo ${dockerfile_path} built
done

echo done
