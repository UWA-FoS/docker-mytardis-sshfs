FROM python:2.7

EXPOSE 22

#ENTRYPOINT ["/docker-entrypoint.sh"]
#ENTRYPOINT ["tail","-f","/dev/null"]

# SSHd
RUN apt-get update && apt-get -y install \
  openssh-server \
  sssd-common \
  && apt-get clean

# Missing privilege separation directory: /var/run/sshd
RUN mkdir -p /var/run/sshd

# MyTardisFS
RUN apt-get update && apt-get -y install \
  fuse \
  libfuse-dev \
  python-fdsend \
  && apt-get clean

RUN python -m pip install -U --no-cache-dir \
  fuse-python \
  configparser \
  python-dateutil \
  requests

COPY ./mytardisfs.cnf /etc/mytardisfs.cnf
COPY ./mytardisfs/mytardisfs/ /opt/mytardisfs/

ENV PYTHONPATH=/usr/lib/python2.7/dist-packages/

# Set up mytardis user for access
RUN apt-get update && apt-get -y install \
  sudo \
  && apt-get clean
COPY ./sudoers_mytardis /etc/sudoers.d/mytardis

ENTRYPOINT ["/usr/sbin/sshd","-4","-D"]
