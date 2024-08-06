FROM node
WORKDIR /app
COPY . .
RUN npm install
RUN groupadd -g ${JenkinsGID} ${user}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${JenkinsUID} -g ${JenkinsGID} -m ${user}
EXPOSE 8080
CMD ["npm", "start"]

