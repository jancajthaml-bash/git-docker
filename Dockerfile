FROM alpine:latest

MAINTAINER  Jan Cajthaml <jan.cajthaml@gmail.com>

COPY opt/no-interactive-login /var/cache/git/no-interactive-login
COPY opt/sshd.conf /var/cache/git/sshd_config
COPY opt/start.sh /var/cache/git/start

RUN apk add --no-cache \
  openssh \
  git && \
  ssh-keygen -A && \
  mkdir -p /git-server/repos /git-server/keys && \
  mkdir -p /home/git/.ssh /home/git/git-shell-commands && \
  cat /var/cache/git/no-interactive-login > /home/git/git-shell-commands/no-interactive-login && \
  cat /var/cache/git/sshd_config > /etc/ssh/sshd_config && \
  sed -i 's/^AcceptEnv LANG LC_\*$//g' /etc/ssh/sshd_config && \
  adduser -D -s /usr/bin/git-shell git && \
  chmod +x /home/git/git-shell-commands/no-interactive-login && \
  chown -R git:git /home/git && \
  echo git:12345 | chpasswd && \
  cat /var/cache/git/start > /usr/local/bin/git-server && chmod +x /usr/local/bin/git-server

EXPOSE 22

CMD git-server
