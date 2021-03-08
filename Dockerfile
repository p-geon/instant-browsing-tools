FROM python:3.7
LABEL version="1.0"
LABEL purpose="python3.7-jupyter_notebook"

ENV DIR_DOCKER=docker
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && apt-get install -y --quiet --no-install-recommends \
  wget

RUN pip install -q --upgrade pip

COPY ./requirements.txt ./
RUN pip install -r requirements.txt -q

WORKDIR /work
ARG launch_port
EXPOSE ${launch_port}
ENTRYPOINT ["jupyter"]
