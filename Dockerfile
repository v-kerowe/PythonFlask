
#FROM python:3.4
FROM python:3.6.9

RUN mkdir /code
WORKDIR /code

#Turbodbc Requirements https://turbodbc.readthedocs.io/en/latest/pages/getting_started.html#installation
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
        && apt-get install -y --no-install-recommends libboost-all-dev \
        && apt-get install -y --no-install-recommends unixodbc-dev \
        && apt-get install -y --no-install-recommends python-dev \
        && echo "Turbodbc Req Done"

#Install Python Modules requiered by turbodbc
RUN pip install -U numpy pybind11

#Install App Python Modules
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd 

COPY sshd_config /etc/ssh/
COPY init.sh /usr/local/bin/
	
RUN chmod u+x /usr/local/bin/init.sh
EXPOSE 5000 2222
ENTRYPOINT ["init.sh"]
