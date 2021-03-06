FROM ruby:2.3.3

RUN mkdir /opt/dear_fcc
WORKDIR /opt/dear_fcc

ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock

RUN bundle install

ADD app ./app
ADD config ./config
ADD config.ru ./config.ru
ADD db ./db
ADD lib ./lib
ADD public ./public
ADD Rakefile ./Rakefile
ADD spec ./spec
ADD tasks ./tasks

ADD entrypoint.sh ./entrypoint.sh
ENTRYPOINT ./entrypoint.sh

CMD ["padrino", "s", "-h", "0.0.0.0"]
ENTRYPOINT ["/opt/dear_fcc/entrypoint.sh"]
