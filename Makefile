.PHONY: compose
compose:
	docker compose -f ./local/docker-compose.yaml up -d

.PHONY: decompose
decompose:
	docker compose -f ./local/docker-compose.yaml down

.PHONY: clean
clean:
	docker image rm olegdayo/mlist-backend:latest
	docker image rm olegdayo/mlist-frontend:latest
