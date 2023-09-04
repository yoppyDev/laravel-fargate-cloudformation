## 手順
1. .envファイルを作成
```
cp .env.example .env
```
2. .envファイルにそれぞれの値を入力
3. Laravelプロジェクト作成
```
sh tools/util.sh createProject
```
3. ECR作成
```
sh tools/util.sh createEcr
```
4. buildしてpush
```
sh tools/util.sh build
sh tools/util.sh push
```
3. S3バケット作成
```
sh tools/util.sh createBucket
```
5. デプロイ
```
sh tools/util.sh deploy
```

## ディレクトリ構成
```
|- docker
|   |- composer
|   |- laravel
|   |- nginx
|- output
|- src
|- stacks
|   |- cloudwatch.yml
|   |- ecr.yml
|   |- ecs.yml
|   |- iam.yml
|   |- vpc.yml
|- tools
|   |- util.sh
|   |- aws-ecr-login.sh
|- .env.example
|- .gitignore
|- docker-compose.yml
```

## インフラ構成
AZ : ap-northeast-1
