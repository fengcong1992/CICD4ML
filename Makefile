install:
	pip install --upgrade pip
	pip install -r requirements.txt
format:
	black *.py
train:
	python train.py
eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	cml comment create report.md
hf-login:
	git fetch origin update
	git checkout origin/update
	git switch update
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload joeyfeng/CICD4ML ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload joeyfeng/CICD4ML ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload joeyfeng/CICD4ML ./Results /Metrics --repo-type=space --commit-message="Sync Results"

deploy: hf-login push-hub
