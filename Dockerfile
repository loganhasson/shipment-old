FROM ubuntu:12.04
MAINTAINER Logan Hasson
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8
RUN apt-get -y update && apt-get -y upgrade && apt-get -y update
RUN apt-get -y install build-essential sqlite3 libsqlite3-dev libyaml-dev libpq-dev git curl vim nodejs chrpath git-core libssl-dev libfontconfig1-dev libqt4-dev wget expect postgresql-9.3 pgadmin3 redis-server
RUN curl -L get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.2"
RUN sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf
RUN sed -i 's/# Put your actual configuration here/host all all 0.0.0.0\/0 md5/g' /etc/postgresql/9.3/main/pg_hba.conf
USER postgres
RUN service postgresql start && psql --command "CREATE USER root WITH SUPERUSER PASSWORD 'postgres';" && createdb -O root root && service postgresql stop
USER root
RUN /bin/bash -l -c "gem install rails -v 4.1.1 --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install bundler rspec activerecord sqlite3 rake database_cleaner oj faraday"
RUN /bin/bash -l -c "gem install rails rspec-rails capybara selenium-webdriver better_errors sprockets_better_errors binding_of_caller factory_girl_rails simplecov database_cleaner sqlite3 pry pg google-analytics-rails rails_12factor bootstrap-sass devise airbrake mina flatiron-rails"
ADD fake_brew.sh /usr/local/bin/brew
ENV HOME '/'
EXPOSE 3000
EXPOSE 8080
EXPOSE 5432
EXPOSE 9292
EXPOSE 6379

