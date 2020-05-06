FROM python:3.7.6-slim-buster
ENV SAM_CLI_TELEMETRY 0
ENV SAM_VERSION 0.48.0
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -y --no-install-recommends \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
RUN pip3 --no-cache-dir install aws-sam-cli==${SAM_VERSION}
WORKDIR /opt/aws-sam-action
COPY entrypoint.sh entrypoint.sh
ENV PATH ${PATH}:/opt/aws-sam-action
ENTRYPOINT ["entrypoint.sh"]
