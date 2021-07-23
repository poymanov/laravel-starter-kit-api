.DEFAULT_GOAL := restart

init: docker-down-clear docker-pull docker-build docker-up app-init
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

wait-db:
	docker-compose run --rm php-cli wait-for-it db:3306 -t 60

permissions:
	docker run --rm -v ${PWD}:/app -w /app alpine chmod 777 -R storage bootstrap

composer-install:
	docker-compose run --rm php-cli composer install

app-init: permissions composer-install copy-env generate-key wait-db migrations create-storage

copy-env:
	cp .env.example .env

create-storage:
	docker-compose run --rm php-cli php artisan storage:link

test:
	docker-compose run --rm php-cli php artisan test

shell:
	docker-compose run --rm php-cli bash

migrations:
	docker-compose run --rm php-cli php artisan migrate

seed:
	docker-compose run --rm php-cli php artisan migrate:fresh --seed

generate-key:
	docker-compose run --rm php-cli php artisan key:generate
