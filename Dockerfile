FROM erlang:20

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.6.1" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="91109a1774e9040fb10c1692c146c3e5a102e621e9c48196bfea7b828d54544c" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean

RUN apt-get update

RUN apt-get install -y apache2-utils python git

RUN mkdir -p /var/park && cd /var/park && git clone https://github.com/init/http-test-suite.git && \
	mkdir -p /var/www/html && rm -rf /var/www/html && mkdir -p /var/www && \
	cp -r /var/park/http-test-suite /var/www/html

ENV WORK /highload_server
WORKDIR $WORK/


ADD . .

COPY core-counter.py .

RUN yes | mix deps.get
EXPOSE 80

RUN mix local.rebar --force

RUN cp httpd.conf /etc/httpd.conf

CMD ELIXIR_CPU_CORES=`python core-counter.py` && elixir --erl "+S $ELIXIR_CPU_CORES" -S mix run --no-halt
