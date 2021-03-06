FROM digitalrebar/deploy-service-wrapper

# Set our command
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

RUN groupadd -r rebar && useradd -r -u 1000 -g rebar -p '$6$afAL.34B$T2WR6zycEe2q3DktVtbH2orOroblhR6uCdo5n3jxLsm47PBm9lwygTbv3AjcmGDnvlh0y83u2yprET8g9/mve.' -m -d /home/rebar -s /bin/bash rebar \
  && mkdir -p /opt/digitalrebar /etc/sudoers.d /home/rebar/.ssh /var/run/rebar \
  && chown rebar:rebar /var/run/rebar

COPY rebar_sudoer /etc/sudoers.d/rebar
COPY ssh_config /home/rebar/.ssh/config
COPY rebar-runner.json /etc/consul.d/rebar-runner.json

RUN apt-get -y update \
  && apt-get -y install software-properties-common wget \
  && apt-add-repository ppa:brightbox/ruby-ng \
  && add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe multiverse" \
  && add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" \
  && apt-add-repository ppa:ansible/ansible \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
  && apt-get -y update \
  && apt-get -y install ruby2.1 ruby2.1-dev make cmake curl swig3.0 libcimcclient0-dev libxml2-dev libcurl4-openssl-dev libssl-dev build-essential jq sudo libopenwsman-dev postgresql-client-9.4 libpq5 libpq-dev autoconf uuid-runtime ipmitool ansible python-netaddr python-dns python-pip \
  && pip install dnspython \
  && gem install bundler \
  && gem install net-http-digest_auth \
  && gem install berkshelf \
  && curl -fgL -o /usr/local/bin/rebar \
         https://s3-us-west-2.amazonaws.com/rebar-cli/rebar-linux-amd64 \
  && chmod 755 /usr/local/bin/rebar \
  && [ -d /opt/digitalrebar/core ] || git clone https://github.com/digitalrebar/core /opt/digitalrebar/core \
  && mkdir -p /var/run/rebar /var/cache/rebar/cookbooks /var/cache/rebar/gems /var/cache/rebar/bin /var/log/rebar \
  && chown -R rebar:rebar /opt/digitalrebar /var/run/rebar /var/cache/rebar /var/log/rebar /home/rebar/.ssh \
  && chmod 755 /home/rebar/.ssh \
  && ln -s /usr/bin/swig3.0 /usr/bin/swig \
  && su -l -c 'cd /opt/digitalrebar/core/rails; bundle install --path /var/cache/rebar/gems --standalone --binstubs /var/cache/rebar/bin' rebar \
  && ln -s /var/cache/rebar/bin/puma /usr/bin/puma \
  && ln -s /var/cache/rebar/bin/pumactl /usr/bin/pumactl \
  && chown rebar:rebar /home/rebar/.ssh/config \
  && chmod 644 /home/rebar/.ssh/config \
  && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out /var/run/rebar/server.key \
  && openssl req -new -key /var/run/rebar/server.key -out /var/run/rebar/server.csr -subj "/C=US/ST=Texas/L=Austin/O=RackN/OU=RebarAPI/CN=neode.net" \
  && openssl x509 -req -days 365 -in /var/run/rebar/server.csr -signkey /var/run/rebar/server.key -out /var/run/rebar/server.crt \
  && rm /var/run/rebar/server.csr \
  && chmod 400 /var/run/rebar/server.key /var/run/rebar/server.crt \
  && chown rebar:rebar /var/run/rebar/server.key /var/run/rebar/server.crt \
  && curl -fgL -o '/tmp/chef.deb' \
       'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_11.18.12-1_amd64.deb' \
  && dpkg -i /tmp/chef.deb && rm -f /tmp/chef.deb \
  && sed -i '/\[ssh_connection\]/a ssh_args=' /etc/ansible/ansible.cfg

COPY entrypoint.d/*.sh /usr/local/entrypoint.d/
