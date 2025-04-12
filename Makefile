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
	huggingface-cli upload joeyfeng/Drug_Classification App/drug_app.py --repo-type=space --commit-message="Upload app"
	huggingface-cli upload joeyfeng/Drug_Classification App/requirements.txt --repo-type=space --commit-message="Upload requirements"
	huggingface-cli upload joeyfeng/Drug_Classification App/README.md --repo-type=space --commit-message="Upload app metadata"
	huggingface-cli upload joeyfeng/Drug_Classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload joeyfeng/Drug_Classification ./Results /Metrics --repo-type=space --commit-message="Sync Results"

deploy: hf-login push-hub

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	# Add files, ignore missing ones with || true
	git add App/drug_app.py App/requirements.txt App/README.md || true
	git add Model/ Results/ || true
	git add report.md || true
	git commit -am "Update with new results" || echo "Nothing to commit"
	git push --force origin HEAD:update

