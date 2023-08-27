#!/bin/bash
set -eu
aws cloudformation package --template-file ./main.yml --s3-bucket laravel-templete --output-template-file ./output/main-stack.yml

rain deploy ./output/main-stack.yml laravel-templete
