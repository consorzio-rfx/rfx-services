FROM jenkins/jenkins:latest

USER root

ARG jenkins_user=1000
ARG jenkins_group=1000
ARG docker_group_id=1054

## flip jenkins user id
RUN if [ ${jenkins_user} != 1000 ]; then \
  usermod -u ${jenkins_user} jenkins && find / \
   -type d \( -path proc -o -path sys \) -prune -false -o \
   -uid 1000 -exec chown -h ${jenkins_user} {} + 2> /dev/null; \
  fi
RUN if [ ${jenkins_group} != 1000 ]; then \
  groupmod -g ${jenkins_group} jenkins && find / \
   -type d \( -path proc -o -path sys \) -prune -false -o \
   -gid 1000 -exec chgrp -h ${jenkins_user} {} + 2> /dev/null;\
  fi


## Install docker
RUN echo docker:x:${docker_group_id}:jenkins >> /etc/group
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh


USER jenkins
