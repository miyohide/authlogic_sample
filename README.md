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

