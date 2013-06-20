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

## Usersコントローラの作成

`bundle exec rails g controller users`でひな形を作成し、Controllerを実装する。

## Users#new のViewを作成

ユーザ登録用のViewを`app/views/users/`以下に作成する。

## routesの作成

`config/routes.rb`にて、URL routesを設定する。

## Userモデルで認証処理の実装

`app/models/user.rb`にて、認証処理を実装する。今回は`email`をログインキーとする。

# the_roleの導入

権限管理のためにthe_roleを導入します。導入手順は次の通り。

## Gemの追加

`Gemfile`に`gem 'the_role', '~>1.7.0'`を追加。また、権限周りの設定をGUIで行えるように`gem 'bootstrap-sass', '~> 2.3.1.0'`も追加しておくとよい。

追加したら`bundle install`する。

## role_idカラムの追加

ユーザ情報を格納しているテーブル（今回の場合は`users`テーブル）に対して`role_id`カラムを追加する。

`rails g migration AddRoleIdToUsers`でMigrationファイルを作ればよい。

その後、`rake db:migrate`を実行して、カラムを追加。

## roleモデルの作成

`rails g model role --migration=false`を実行して`role`モデルを作成する。

migrationファイルはこの後のコマンドで作成する。

## rolesテーブルの作成

`the_role`が用意している`rake`コマンド`rake the_role_engine:install:migrations`を実行してrolesテーブルのmigrationファイルを作成する。

作成後は、`rake db:migrate`でテーブルを作成する。

## alias_methodの設定

`alias_method`を使って、`login_required`と`role_access_denied`の設定を行う。実装は`application_controller.rb`に。

`login_required`は使っている認証プラグインらが用意しているログインを求めるメソッドを指定する。

`role_access_denied`は権限不正の時の処理を指定する。

```ruby
class ApplicationController < ActionController::Base
  include TheRole::Requires

  def access_denied
    render text: 'access_denied: requires an role' and return
  end

  # ログインを求めるメソッドを指定
  alias_method :login_required, :require_user
  # 権限不正の時の処理を指定
  alias_method :role_access_denied, :access_denied

  # 以下省略
end
```


