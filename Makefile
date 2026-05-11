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
	$(MAKE) setup-k8s

.PHONY: setup-argocd
setup-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	sleep 30
	kubectl port-forward svc/argocd-server -n argocd 8080:443
	echo 'argocd password'
	argocd admin initial-password -n argocd

.PHONY: setup-kyverno
setup-kyverno:
	helm repo add kyverno https://kyverno.github.io/kyverno/
	helm repo update
	helm install kyverno kyverno/kyverno -n kyverno --create-namespace \
		--set admissionController.replicas=3 \
		--set backgroundController.replicas=2 \
		--set cleanupController.replicas=2 \
		--set reportsController.replicas=2
	kubectl -n kyverno patch deploy kyverno-admission-controller --patch-file k8s/manifests/kyverno-patch.yaml
	sleep 5
	helm install kyverno-policies kyverno/kyverno-policies -n kyverno

.PHONY: setup-policies
setup-policies:
	kubectl apply -f k8s/manifests/mlist.yaml
	kubectl apply -f k8s/manifests/image-verifier-cpol.yaml
	kubectl apply -f k8s/manifests/deploy-verifier.yaml

.PHONY: setup-k8s
setup-k8s:
	kubectl apply -f k8s/manifests/secrets.yaml
	$(MAKE) setup-argocd
	$(MAKE) setup-kyverno
	$(MAKE) setup-policies

.PHONY: dekind
dekind:
	kind delete clusters 'mlops'

.PHONY: vault
vault:
	docker compose -f ./local/compose/vault.docker-compose.yaml up -d

.PHONY: devault
devault:
	docker compose -f ./local/compose/vault.docker-compose.yaml down

.PHONY: s3
s3:
	docker compose -f ./local/compose/s3.docker-compose.yaml up -d

.PHONY: des3
des3:
	docker compose -f ./local/compose/s3.docker-compose.yaml down
