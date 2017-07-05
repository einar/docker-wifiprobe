FROM ubuntu:16.04
MAINTAINER el@sunet.se
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get -y dist-upgrade
ENV INSTALLDIR /opt/probe-website
ENV PYTHONPATH ${INSTALLDIR}
ENV FLASK_APP ${INSTALLDIR}/runserver.py
ENV DATABASE ${INSTALLDIR}/wifi-probe.db
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# NB: Must have ansible 2.x
RUN apt-get install --fix-missing --yes python3 python3-pip ansible netcat git apt-utils vim
# These programs are required for the python cryptography module to compile
# (when installed with pip)
RUN apt-get install --yes build-essential libssl-dev libffi-dev python-dev

# Snag source from UNINETT
RUN git clone https://github.com/UNINETT/probe-website ${INSTALLDIR} 

RUN pip3 install --upgrade pip virtualenv
RUN virtualenv -p python3 ${INSTALLDIR}
RUN ${INSTALLDIR}/bin/pip3 install -r ${INSTALLDIR}/requirements.txt gunicorn

RUN apt-get install sqlite3
RUN sqlite3 ${DATABASE} < ${INSTALLDIR}/database.sqlite.sql

COPY settings.py ${INSTALLDIR}/probe_website
COPY secret_settings.py ${INSTALLDIR}/probe_website 
ADD start.sh /start.sh
COPY get_probe_keys.sh /usr/bin
RUN chmod +x /usr/bin/get_probe_keys.sh

EXPOSE 5000 
ENTRYPOINT ["/start.sh"]


