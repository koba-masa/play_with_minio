# play_with_minio
MinIOを遊び尽くすリポジトリ
- Docker環境にて遊ぶことを想定しています。

[![ci](https://github.com/koba-masa/play_with_minio/actions/workflows/ci.yml/badge.svg)](https://github.com/koba-masa/play_with_minio/actions/workflows/ci.yml)

## MinIOとは
- `AWS S3`と互換性のある軽量なストレージサーバ

### 関連サイト
- [公式サイト](https://min.io/)
- [GitHub](https://github.com/minio/minio)
- [Docker Image](https://hub.docker.com/r/minio/minio/)

### 起動方法
- 環境変数に以下のキーを設定する(rootユーザとして、使用する)
  - `MINIO_ROOT_USER`
  - `MINIO_ROOT_PASSWORD`
- 以下のコマンドを実行する(コンテナ内で実行するコマンド)
  - `minio server /data --address ':9000' --console-address ':9001'`

|オプション|概要|設定例|備考|
|:--|:--|:--|:--|
|<ディイレクトリ>|minioが使用するディレクトリを指定|/data||
|--address|API用のホストとポートを指定|--address ':9000'|省略可。デフォルト値は自ホストと9000番ポート|
|--console-address|Webコンソール用のホストとポートを指定|--console-address ':9001'|省略するとポートが起動時に異なる|

- [MinIO Docker Quickstart Guide](https://docs.min.io/docs/minio-docker-quickstart-guide.html#:~:text=Run%20Standalone%20MinIO%20on%20Docker.)

#### ディレクトリ構成
- 事前にバケットやIAMの情報を設定する場合は、以下のディレクトリ構成に従う

|  |  |  |  |  |  |  |  |
| :-- | :-- | :-- | :-- | :-- |:-- |:-- |:-- |
| /data |  |  |  |  |  |  | 起動時に指定したディレクトリ |
|  | /.minio.sys |  |  |  |  |  | 各種設定を格納 |
|  |  | /config |  |  |  |
|  |  |  | /iam |  |  |  | IAM関連の設定を格納 |
|  |  |  |  | /groups |  |  | Group関連の設定を格納 |
|  |  |  |  |  | /<グループ名> |  |  |
|  |  |  |  |  |  | /members.json |  |
|  |  |  |  | /policies |  |  | Policy関連の設定を格納 |
|  |  |  |  |  | /<ポリシー名> |  |  |
|  |  |  |  |  |  | /policy.json |  |
|  |  |  |  | /policydb |  |  | PolicyとUser/Groupを関連づける設定を格納 |
|  |  |  |  |  | /groups |  | PolicyとGroupを関連づける設定を格納 |
|  |  |  |  |  |  | /<グループ名>.json |  |
|  |  |  |  |  | /users |  | PolicyとUserを関連づける設定を格納 |
|  |  |  |  |  |  | /<アクセスキーID>.json |  |
|  |  |  |  | /users |  |  | Userに関連する設定を格納 |
|  |  |  |  |  | /<アクセスキーID> |  |  |
|  |  |  |  |  |  | /identity.json |  |

## 実行手順
1. Docker環境の構築
   ```
   $ docker-compose build
   ```
1. MinIOコンテナの起動
   ```
   $ docker-compose up -d
   ```
1. アプリケーションの実行
   ```
   $ docker-compose run app bundle exec ruby <実行ファイル>
   ```

### MinIO Webコンソール
- http://localhost:9001
   - ユーザ名: `minio`
   - パスワード: `minio123`
