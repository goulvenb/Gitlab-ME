ARG VERSION=17.5.2
ARG REVISION=0
FROM gitlab/gitlab-ce:${VERSION}-ce.${REVISION}

COPY ./certs /certs
RUN chmod -R 644 /certs
COPY ./scripts /scripts
RUN chmod -R 700 /scripts
COPY ./crond /crond
RUN chmod -R 700 /crond

ENV GITLAB_POST_RECONFIGURE_SCRIPT=/scripts/init.sh

COPY ./gitlab.rb /etc/gitlab/gitlab.rb
COPY ./init.rb /assets/init.rb