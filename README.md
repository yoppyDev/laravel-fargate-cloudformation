## 手順
1. .envファイルを作成
```
cp .env.example .env
```
2. .envファイルにそれぞれの値を入力
3. ~~Laravelプロジェクト作成~~ (srcを追加したので不要になった)
```
sh tools/util.sh createProject
```
4. ECR作成
```
sh tools/util.sh createEcr
```
5. buildしてpush
```
sh tools/aws-ecr-login.sh
sh tools/util.sh build
sh tools/util.sh push
```
6. S3バケット作成
```
sh tools/util.sh createBucket
```
7. デプロイ
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
|   |- alb.yml
|- tools
|   |- util.sh
|   |- aws-ecr-login.sh
|- .env.example
|- .gitignore
|- docker-compose.yml
```

## インフラ構成
AZ : ap-northeast-1
