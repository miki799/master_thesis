FROM python:3

# Install curl
RUN apt-get update && apt-get install -y curl

# Creates user app_user with id 234 and root privileges
RUN useradd -u 234 -G sudo -ms /bin/bash app_user

# Next commands will be run by app_user
USER app_user:app_user

# Install Flask framework in the app_user home dir
RUN pip install --user --no-cache-dir Flask

# Sets current workdir to /app dir
WORKDIR /app

# /app dir is owned by app_user
RUN chown app_user /app -R

# Copy files from local dir to the /app dir
COPY /src/* .

# Sets current workdir to root dir
WORKDIR /

# Apps starts with the container
CMD [ "python", "/app/rce_app.py" ]

LABEL owner=mikolajtelec