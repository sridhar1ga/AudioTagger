FROM python:3.7-slim-bookworm

LABEL org.opencontainers.image.authors="sridharvanga2001@gmail.com"

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get -y install ffmpeg parallel \
    && export DEBIAN_FRONTEND=noninteractive

RUN pip install --no-cache --upgrade pip setuptools

RUN pip install lxml pydub 

WORKDIR /VrtParserPipeline

ADD ./VrtParserPipeline .

