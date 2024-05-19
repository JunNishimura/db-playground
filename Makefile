include .env

.PHONY: up down migrations migrate-up migrate-down migrate-force

up:
	docker compose up --build -d

down:
	docker compose down

migrations:
	docker compose exec migration migrate create -ext sql -dir ./database/migrations -seq ${NAME}

migrate-up:
	docker compose exec migration migrate -database "mysql://$(DB_USER):$(DB_PASSWORD)@tcp($(DB_HOST):$(DB_PORT))/$(DB_NAME)?charset=utf8mb4&parseTime=True&loc=Local" -path "./database/migrations" up ${STEP}

migrate-down:
	docker compose exec migration migrate -database "mysql://$(DB_USER):$(DB_PASSWORD)@tcp($(DB_HOST):$(DB_PORT))/$(DB_NAME)?charset=utf8mb4&parseTime=True&loc=Local" -path "./database/migrations" down ${STEP}

migrate-force:
	docker compose exec migration migrate -database "mysql://$(DB_USER):$(DB_PASSWORD)@tcp($(DB_HOST):$(DB_PORT))/$(DB_NAME)?charset=utf8mb4&parseTime=True&loc=Local" -path "./database/migrations" force ${VERSION}