ARG IMAGE_NAME_WITH_TAG=python:3

FROM ${IMAGE_NAME_WITH_TAG}

# Install curl
RUN apt-get update && apt-get install -y curl

# Install Flask framework in the app_user home dir
RUN pip install --no-cache-dir Flask

# Sets current workdir to /app dir
WORKDIR /app

# Copy files from local dir to the /app dir
COPY /src/* .

# Sets current workdir to root dir
WORKDIR /

# Apps starts with the container
CMD [ "python", "/app/rce_app.py" ]

LABEL owner=mikolajtelec