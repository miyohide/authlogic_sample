# これは何か

認証GemであるauthlogicのサンプルRailsプロジェクトです。

# バージョン

* Ruby 2.0.0-p195
* Rails 3.2.13
* authlogic 3.3.0

# つくり方
## プロジェクトの生成

`rails new authlogic_sample -T --skip-bundle`でRailsプロジェクトを作成。サンプルということから`-T`でテストは作らないように。
あとで`Gemfile`をいじるので、`--skip-bundle`でbundleの実行を回避。

## authlogicの追加とbundle install

`Gemfile`に`gem 'authlogic'`を追加し、`bundle install --path vendor/bundle`を実行

## 認証が必要となる処理の自動生成

認証を埋め込む処理を`rails g scaffold entry title:string`と打って自動生成

作成したら、`bundle exec rake db:migrate`でテーブルを作成

## 認証用のモデルを作成

認証処理のために、セッションを持つ`user_session`モデルとユーザの情報を持つ`user`モデルを作成。

`user_session`モデルは、`bundle exec rails g model user_session`で、`user`モデルは、`bundle exec rails g model user`で作成。

## UserSessionクラスの親クラスを変更

`app/models/user_session.rb`を開き、`UserSession`クラスの親クラスを`Authlogic::Session::Base`に変更。

```ruby
class UserSession < Authlogic::Session::Base
  # attr_accessible :title, :body
end
```
## user_sessionsテーブルとusersテーブルの作成

`db/migrate`ディレクトリ以下にあるmigrationファイルを編集して、`user_sessions`テーブルと`users`テーブルを作成

## application_controllerでcurrent_userなどの処理を定義

`app/controllers/application_controller.rb`に`current_user`などの処理を書く

## UserSessionsコントローラの作成

`bundle exec rails g controller user_sessions`でひな形を作成し、Controllerを実装する。

## UserSessions#new のViewを作成

メールアドレスとパスワードを入力する欄を作ったログインフォームを`app/views/user_sessions/new.html.erb`に作成する。


