## インフラ構成
赤で囲っている部分のリソースを作成する

![Alt text](InfrastructureConfiguration.png)

出典：https://aws.amazon.com/jp/cdp/ec-container/

## 手順

```
# 1. リポジトリをクローン
git clone git@github.com:yoppytaro/laravel-fargate-cloudformation.git

# 2. .envファイルを作成 & 編集
cp .env.example .env

# 3. ParameterStore作成
sh tools/util.sh createSystemParameter

# 4. ECR作成
sh tools/util.sh createEcr

# 5. buildしてpush
sh tools/aws-ecr-login.sh
sh tools/util.sh baseBuild
sh tools/util.sh basePush
sh tools/util.sh build
sh tools/util.sh push

# 6. S3バケット作成
sh tools/util.sh createBucket

# 7. デプロイ
sh tools/util.sh subDeploy

# 8. migrate
aws ecs execute-command \
    --cluster laravel-template-cluster \
    --task ${{ taskArn }} \
    --container nginx \
    --interactive \
    --command 'php artisan migrate --force'
```


## デプロイ
`sh util.sh updateService`かmainにマージするとデプロイされる
(github actionの設定は必要)


## スクラップ

https://zenn.dev/yoppy/scraps/e310e607c0b1fb
