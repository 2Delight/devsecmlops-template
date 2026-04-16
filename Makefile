.PHONY: compose
compose: clean
	docker compose -f ./local/compose/docker-compose.yaml up -d

.PHONY: decompose
decompose:
	docker compose -f ./local/compose/docker-compose.yaml down

.PHONY: clean
clean:
	docker image rm olegdayo/mlist-backend:latest || true
	docker image rm olegdayo/mlist-frontend:latest || true

.PHONY: kind
kind:
	kind create cluster --name 'mlops' --config ./local/kind/cluster.yaml
	$(MAKE) setup-kind

.PHONY: setup-kind
setup-kind:
	helm install kyverno-policies kyverno/kyverno-policies -n kyverno
# 	kubectl -n kyverno patch deploy kyverno-admission-controller --patch-file k8s/manifests/kyverno-patch.yaml
# 	kubectl apply -f k8s/manifests/signature.yaml
	kubectl apply -f k8s/manifests/mlist.yaml

.PHONY: dekind
dekind:
	kind delete clusters 'mlops'

.PHONY: vault
vault:
	docker compose -f ./local/compose/vault.docker-compose.yaml up -d

.PHONY: devault
devault:
	docker compose -f ./local/compose/vault.docker-compose.yaml down
