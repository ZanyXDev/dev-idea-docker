FROM ubuntu:16.04

MAINTAINER ZanyXDev "zanyxdev@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
#set Russian locale
ENV LC_ALL ru_RU.UTF-8 
ENV LANG ru_RU.UTF-8 
ENV LANGUAGE ru_RU.UTF-8 

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/ZanyXDev/dev-idea-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
org.label-schema.schema-version="1.0.0-rc1"

# Dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -yq --no-install-recommends software-properties-common  \
    git \
    libxext-dev \
    libxrender-dev \
    libstdc++6:i386 \
    zlib1g:i386 \
    libncurses5:i386 \
    libxslt1.1 \
    libxtst-dev \
    libgtk2.0-0 \
    libcanberra-gtk-module \
    unzip \
    wget \
    curl \
    sudo \
    openjdk-8-jdk \
    ca-certificates-java \
    meld && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 

# Download Java Cryptography Extension
RUN curl -LO "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
    -o /tmp/jce_policy-8.zip && \
    unzip jce_policy-8.zip && \
    yes | cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/java-8-openjdk-amd64/lib/security/ && \
    rm jce_policy-8.zip

RUN mkdir -p /home/developer && \
    useradd developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown -R developer:developer /home/developer

#Installs and configure Android SDK
ENV ANDROID_HOME /opt/android-sdk-linux 
ENV PATH ${PATH}:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools

RUN curl -L https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o /tmp/tools_r25.2.3-linux.zip && \
    unzip /tmp/tools_r25.2.3-linux.zip -d /opt/android-sdk-linux && \
    chown -R developer:developer /opt/android-sdk-linux
    rm -f /tmp/tools_r25.2.3-linux.zip

# Install Android SDK components
ENV ANDROID_COMPONENTS platform-tools,build-tools-25.0.0,build-tools-25.0.1,build-tools-25.0.2,android-25
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" && \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"  && \
    chown -R developer:developer /opt/android-sdk-linux

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-2016.3.4-no-jdk.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    chmod +x /opt/intellij/bin/idea.sh && \
    chown -R developer:developer /opt/intellij  && \
    rm /tmp/intellij.tar.gz

# Set up USB device debugging (device is ID in the rules files)
RUN curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/ZanyXDev/dev-idea-docker/latest/51-android.rules && \
    chmod a+r /etc/udev/rules.d/51-android.rules

#Install Gradle
ENV GRADLE_URL http://services.gradle.org/distributions/gradle-3.3-all.zip
ENV GRADLE_HOME /usr/local/gradle-3.3
RUN curl -L ${GRADLE_URL} -o /tmp/gradle-3.3-all.zip && \
    unzip /tmp/gradle-3.3-all.zip -d /usr/local && \
    rm /tmp/gradle-3.3-all.zip 

#RUN apt-get update && apt-get install -y mc

VOLUME /home/developer

# Set things up using the dev user and reduce the need for `chown`s
USER developer    

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV HOME /home/developer

CMD /opt/intellij/bin/idea.sh