docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 200915316788.dkr.ecr.us-east-1.amazonaws.com
	docker build -t  200915316788.dkr.ecr.us-east-1.amazonaws.com/frontend:$(image_tag) .
	docker push 200915316788.dkr.ecr.us-east-1.amazonaws.com/frontend:$(image_tag)

eks-deploy:
	git pull
	aws eks update-kubeconfig --name wmp-dev
	helm upgrade -i frontend helm -f helm/values/frontend.yaml --set image_tag=$(image_tag)