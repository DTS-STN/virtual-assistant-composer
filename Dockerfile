FROM node:16

LABEL MAINTAINER FreshWorks<web@freshworks.io>
ENV PATH $PATH:/usr/src/app/node_modules/.bin
# Add github.com to known hosts to avoid error
RUN mkdir /root/.ssh && chmod 0700 /root/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app
# Add keys to ssh to they may be used for npm when installing from git.
# Add setting for different subdomain names to allow differente deploy keys to be used (This is a sort of hack)
RUN printf "Host db.github.com\n    Hostname github.com\n    IdentityFile ~/.ssh/db_deploy_key\n    IdentitiesOnly yes\n" >> /etc/ssh/ssh_config &&\
    printf "Host idm.github.com\n    Hostname github.com\n    IdentityFile ~/.ssh/idm_deploy_key\n    IdentitiesOnly yes\n" >> /etc/ssh/ssh_config

# Copy package.json and package-lock.json
COPY ./package*.json ./
# COPY ./tsconfig.json ./

COPY . /usr/src/app/

# COPY ./src ./

RUN npm i npm@7.24.0 -g

# Install dependencies
RUN npm install

EXPOSE 3978


CMD [ "npm", "run", "dev" ]