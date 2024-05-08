FROM python:3

# Install curl
RUN apt-get update && apt-get install -y curl

# Creates user goofy_user with id 999 and root privileges
RUN useradd -u 999 -G sudo -ms /bin/bash goofy_user

# Next commands will be run by goofy_user
USER goofy_user:goofy_user

# Install Flask framework in the goofy_user home dir
RUN pip install --user --no-cache-dir Flask

# Sets current workdir to /app dir
WORKDIR /app

# /app dir is owned by goofy_user
RUN chown goofy_user /app -R

# Copy files from local dir to the /app dir
COPY /src/* .

# Go back to root dir
WORKDIR /

# Apps starts with the container
CMD [ "python", "/app/rce_app.py" ]

LABEL owner=mikolajtelec