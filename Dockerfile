FROM gitlab/gitlab-ce:17.5.2-ce.0

RUN sed -i "$((`wc -l < /assets/wrapper`+1 -2))i\
gitlab-rails runner '/assets/init.rb'\n\
" /assets/wrapper

ENV GITLAB_POST_RECONFIGURE_SCRIPT=/crond/cron.sh