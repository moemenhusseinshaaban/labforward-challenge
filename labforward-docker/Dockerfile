FROM ruby:2.5.3
RUN gem install bundler
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /application
WORKDIR /application
COPY labforward/Gemfile /application/Gemfile
COPY labforward/Rakefile /application/Rakefile
RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java
RUN bundle install
COPY . /application
CMD while true ; do sleep 1 ; done
