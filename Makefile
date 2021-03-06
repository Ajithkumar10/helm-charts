NAMESPACE ?= octoperf
CHART ?= enterprise-edition
HELM_PARAMS=--name $(CHART) --namespace $(NAMESPACE)
HELM_REPO="https://helm.octoperf.com"

default: debug

dependency-update:
	helm dependency update ./$(CHART)

package:
	helm package ./$(CHART)

lint:
	helm lint ./$(CHART)

debug:
	helm install --debug --dry-run --namespace $(NAMESPACE) $(CHART) ./$(CHART) > debug.log


# helm repo add octoperf https://myuser:mypass@helm.octoperf.com
push:
	-helm plugin install https://github.com/chartmuseum/helm-push
	helm push --force $(CHART)/ octoperf

install:
	-kubectl create namespace $(NAMESPACE)
	helm install --namespace $(NAMESPACE) $(CHART) ./$(CHART)

kraken-clean:
	-helm delete kraken --namespace $(NAMESPACE)
	-kubectl delete namespace $(NAMESPACE)
	-kubectl delete ClusterRole kraken-runtime
	-kubectl delete ClusterRoleBinding kraken-runtime
	-kubectl delete PodSecurityPolicy kraken-grafana kraken-grafana-test
	-kubectl delete ClusterRole kraken-grafana-clusterrole
	-kubectl delete ClusterRoleBinding kraken-grafana-clusterrolebinding