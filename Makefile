argocd_server = $(shell kubectl get svc argo-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
argocd_password = $(shell kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)


docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 565122144984.dkr.ecr.us-east-1.amazonaws.com
	docker build -t  565122144984.dkr.ecr.us-east-1.amazonaws.com/frontend:$(image_tag) .
	docker push 565122144984.dkr.ecr.us-east-1.amazonaws.com/frontend:$(image_tag)

eks-deploy:
	git pull
	aws eks update-kubeconfig --name wmp-dev
	helm upgrade -i frontend helm -f helm/values/frontend.yaml --set image_tag=$(image_tag)

argocd-deploy:
	git pull
	aws eks update-kubeconfig --name wmp-dev

	argocd login $(argocd_server) \
		--insecure \
		--username admin \
		--password $(argocd_password)

	argocd app create frontend \
		--repo https://github.com/Wealth-Management-Project-v1/helm-v1.git \
		--path . \
		--revision main \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace default \
		--sync-policy auto \
		--upsert \
		--values values/frontend.yaml \
		--helm-set-string image_tag=$(image_tag)
