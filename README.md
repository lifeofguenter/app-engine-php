# app-engine-php

[![Build Status](https://travis-ci.org/lifeofguenter/docker-app-engine-php.svg?branch=master)](https://travis-ci.org/lifeofguenter/docker-app-engine-php)
[![Docker Pulls](https://img.shields.io/docker/pulls/lifeofguenter/app-engine-php.svg)](https://hub.docker.com/r/lifeofguenter/app-engine-php)

Expiremental docker image to run google-app-engine php5 (standard) in a docker container for local development which would require:

* PHP5.5
* google-sdk
* gae php component
* gae php extension

## Usage

```bash
docker run -it --rm -p 8080:8080 -p 8000:8000 -v "${PWD}:/app" lifeofguenter/app-engine-php:5.5 -A projectname app.yaml
```

Alternatively you want to also mount `/storage` for persistent datastore, blob, etc.
