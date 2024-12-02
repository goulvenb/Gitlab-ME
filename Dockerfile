ARG VERSION=17.5.2
ARG REVISION=0
FROM gitlab/gitlab-ce:${VERSION}-ce.${REVISION}

RUN sed -i "$((`wc -l < /assets/wrapper`+1 -2))i\
gitlab-rails runner '/assets/init.rb'\n\
" /assets/wrapper

ENV GITLAB_POST_RECONFIGURE_SCRIPT=/crond/cron.sh
