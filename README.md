## 構成

- VPN
    - サブネット (IPv4 : 10.0.0.0/16)
        - PUBLIC (IPv4 : 10.0.0.0/24) -> VPC
        - PRIVATE -> VPC
    - インターネットゲートウェイ -> VPC
        - ルートテーブル (送信先 : 0.0.0.0/0)
    - セキュリティーグループ (HTTP, [0.0.0.0/0, :/0]) -> VPC
    - ALB
        - ターゲットグループ
- ECS
    - クラスター
    - サービス
    - タスク定義
    - AWS Systems Manager
- IAMロール (ECSTaskRolte)
    - AmazonECSTaskExecutionRolePolicy
    - AmazonSSMReadOnlyAccess
- CloudWatch


**deploy**
```
aws cloudformation deploy \
    --template-file vpc.yml \
    --stack-name VPCcreate \
    --profile ecs-lesson
```
**delete**
```
aws cloudformation delete-stack --stack-name VPCcreate --profile ecs-lesson
```
