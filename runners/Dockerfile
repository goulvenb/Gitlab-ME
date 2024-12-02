ARG VERSION=17.5.2
FROM gitlab/gitlab-runner:alpine-v${VERSION}

COPY ../certs/ca.crt /certs/ca.crt

RUN sed -i "$((`wc -l < /entrypoint`+1 -2))i\
sed -i ""s/\\\${TOKEN\}/\${TOKEN}/g"" /etc/gitlab-runner/config.toml\n\
sed -i ""s/\\\${DOCKER_VERSION\}/\${DOCKER_VERSION}/g"" /etc/gitlab-runner/config.toml\n\
sed -i ""s/\\\${DOMAIN_GITLAB\}/\${DOMAIN_GITLAB}/g"" /etc/gitlab-runner/config.toml\n\
" /entrypoint 

# In hope of removing the 2 volumes
# that are now useless
VOLUME [ "/var/run/docker.sock" ]