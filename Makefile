SHELL=/bin/bash
PATH := .venv/bin:$(PATH)
export TEST?=./tests
export LAMBDA?=webapp-store
export REPO=lambda-${LAMBDA}
export ENV?=dev
export AWS_REGION=us-west-2
export AWS_ACCOUNT_ID=789524919849
export ECR_URL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
export TAG_NAME=${LAMBDA}-${ENV}
export VERSION=latest
export AWS_DEFAULT_REGION=${AWS_REGION}

install:
	@( \
		if [ ! -d .venv ]; then python3 -m venv --copies .venv; fi; \
		source .venv/bin/activate; \
		pip install -qU pip; \
		pip install -r requirements-dev.txt; \
		pip install -r requirements.txt; \
	)

setup:
	@if [ ! -f .env ] ; then cp .env.mock .env ; fi;
	@make install;

autoflake:
	@autoflake . --check --recursive --remove-all-unused-imports --remove-unused-variables --exclude .venv;

black:
	@black . --check --exclude '.venv|build|target|dist|.cache|node_modules';

isort:
	@isort . --check-only;

lint: black isort autoflake

lint-fix:
	@black . --exclude '.venv|build|target|dist';
	@isort .;
	@autoflake . --in-place --recursive --exclude .venv --remove-all-unused-imports --remove-unused-variables;

docs:
	@if [ ! -f ./docs/make.bat ]; then (cd docs && sphinx-quickstart); fi;
	@(cd docs && make html);
	@if command -v open; then open ./docs/*build/html/index.html; fi;

tests:
	@python -B -m pytest -l --color=yes \
		--cov=src \
		--cov-config=./tests/.coveragerc \
		--cov-report term \
		--cov-report html:coverage \
		--junit-xml=junit.xml \
		--rootdir=. $${TEST};

build:
	@docker build --platform=linux/amd64 -t ${LAMBDA} .

local-build:
	@docker build -t ${LAMBDA} .

run:
	@docker run -d -p 8000:8000  ${LAMBDA}


mac-run:
	@docker run -d -p 8000:8000  ${LAMBDA}

stop:
	@docker stop $$(docker ps -a -q)

run-dev:
	@(\
		if [ ! -d .venv ]; then make install; fi; \
		source .venv/bin/activate; \
		python manage.py collectstatic --noinput; \
		python manage.py runserver 0.0.0.0:8000; \
	)

.PHONY: tests docs

create-ecr:
	@aws --profile moove-it lightsail create-container-service --service-name ${LAMBDA} --power small --scale 1

push-app:
	@aws --profile moove-it lightsail push-container-image --service-name ${LAMBDA} --label ${LAMBDA} --image ${LAMBDA}

deploy:
	@aws --profile moove-it lightsail create-container-service-deployment --service-name ${LAMBDA} --containers file://containers.json --public-endpoint file://public-endpoint.json

check-state:
	@aws --profile moove-it lightsail get-container-services --service-name ${LAMBDA}

cleanup:
	@aws --profile moove-it lightsail delete-container-service --service-name ${LAMBDA}

aws-deployment:
	@make build
	@make create-ecr
	@make push-app
	@make deploy
	@make check-state
