FROM python:buster


RUN    apt update
RUN    apt install software-properties-common -y
RUN    apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y
RUN    apt install curl apt-utils -y
RUN    apt install mosquitto-clients -y


ENV PLATFORM=poc
ENV THING_ID=busterpubhello
ENV TENANT=data-integration

# DSH specific settings
ARG     UID=2080
ARG     GID=2080
ENV     GROUP_NAME=appusers
ENV     USER_NAME=appuser
ENV     HOME_DIR=/home/${USER_NAME}
RUN     addgroup --gid ${GID} ${GROUP_NAME}
RUN     adduser --home ${HOME_DIR} --gid ${GID} --uid ${UID} ${USER_NAME}

# Set the working directory to ${HOME_DIR}/app
ENV     PKI_CONFIG_DIR=${HOME_DIR}/app
WORKDIR $PKI_CONFIG_DIR

# Copy the current directory contents into the container at ${HOME_DIR}/app
COPY   . $PKI_CONFIG_DIR

# Finally fix permissions of ${HOME_DIR}/app to appuser:appusers and set the user to appuser
RUN     chown -R ${USER_NAME}:${GROUP_NAME} ${HOME_DIR}
RUN chmod +x entry.sh
USER    ${GID}:${UID}
# USER root
CMD ["./entry.sh"]

