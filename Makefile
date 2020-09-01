# Makefile
# Copyright (C) 2020 chenliang <chenliang3@cmcm.com>
# Distributed under terms of the GPL license.

REPO=https://github.com/Kong/kong.git
TAG=1.2.1

PREFIX=
IMAGE=${PREFIX}/mykong:${TAG}
BASE_IMAGE=${PREFIX}/openresty:centos

.PHONY: base prod push

base:
	docker build -f ./Dockerfile.base -t ${BASE_IMAGE}  .

prod:
	#./checkcodes.sh ${REPO} ${TAG} kong
	docker build -f ./Dockerfile_dev -t ${IMAGE}  .

push:
	docker push ${IMAGE}
