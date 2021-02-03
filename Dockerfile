FROM python:3.7
LABEL maintainer="nguyenvungoctung@gmail.com"

# expected ports opened
EXPOSE 8080
EXPOSE 4372

ARG UID
ARG USERNAME
ARG GID
ARG GROUP

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    net-tools vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#RUN deb http://archive.ubuntu.com/ubuntu trusty main

#RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'\
#    && apt-get update \
#    && apt-get install -y mysql-client-5.6 \
#    && rm -rf /var/lib/apt

ENV HOME=/home/$USERNAME
RUN mkdir -p $HOME
RUN addgroup --gid "$GID" "$USERNAME" \
   && adduser \
   --disabled-password \
   --gecos "" \
   --home "$(pwd)" \
   --ingroup $USERNAME \
   --uid "$UID" \
   "$USERNAME"

ENV APP_HOME=/home/$USERNAME/biomodels/dbtest

## Setting up the app ##
RUN mkdir -p $APP_HOME
RUN chown -R $USERNAME:$USERNAME $HOME

COPY --chown=$USERNAME:$USERNAME . $APP_HOME
USER $USERNAME
WORKDIR $APP_HOME
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app/app.py"]