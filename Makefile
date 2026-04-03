.PHONY: compose
compose: clean
	docker compose -f ./local/docker-compose.yaml up -d

.PHONY: decompose
decompose:
	docker compose -f ./local/docker-compose.yaml down

.PHONY: clean
clean:
	docker image rm olegdayo/mlist-backend:latest || true
	docker image rm olegdayo/mlist-frontend:latest || true

.PHONY: vault
vault:
	docker compose -f ./local/vault.docker-compose.yaml up -d

.PHONY: devault
devault:
	docker compose -f ./local/vault.docker-compose.yaml down
