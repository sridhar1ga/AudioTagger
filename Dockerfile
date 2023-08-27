FROM python:3.7-slim-bookworm

LABEL org.opencontainers.image.authors="sridharvanga2001@gmail.com"

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get -y install ffmpeg parallel openssh-client gzip \
    && export DEBIAN_FRONTEND=noninteractive

RUN pip install --no-cache --upgrade pip setuptools

RUN pip install beautifulsoup4 lxml pydub 

WORKDIR /VrtParserPipeline

ADD ./VrtParserPipeline .

ENTRYPOINT ["bash", "/scratch/users/sxv499/2016", "/scratch/users/sxv499/tv_output", "/mnt/rds/redhen/gallina/tv/2016"]