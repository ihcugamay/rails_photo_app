# FROM：使用するイメージ、バージョン
FROM ruby:3.1.3
# 公式→https://hub.docker.com/_/ruby

# ruby3.1のイメージがBundler version 2.3.7で失敗するので、gemのバージョンを追記
ARG RUBYGEMS_VERSION=3.3.20

RUN apt-get update -qq

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# install yarn
RUN npm install --global yarn

# RUN：任意のコマンド実行
RUN mkdir /app

# WORKDIR：作業ディレクトリを指定
WORKDIR /app

# COPY：コピー元とコピー先を指定
# ローカルのGemfileをコンテナ内の/app/Gemfileに
COPY Gemfile* /app/


# RubyGemsをアップデート
RUN gem update --system ${RUBYGEMS_VERSION} && \
  bundle install

COPY . /app

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001

# CMD:コンテナ実行時、デフォルトで実行したいコマンド
# Rails サーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]
