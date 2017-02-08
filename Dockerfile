FROM ubuntu:16.04

MAINTAINER ZanyXDev "zanyxdev@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/ZanyXDev/dev-idea-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
org.label-schema.schema-version="1.0.0-rc1"

# Dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq --no-install-recommends software-properties-common  && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -yq --no-install-recommends software-properties-common  \
    apt \
    apt-utils \ 
    libapt-pkg5.0 \
    libsystemd0 \
    libudev1 \
    systemd \
    systemd-sysv \
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
    locale-gen ru_RU ru_RU.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 


# Download Java Cryptography Extension
RUN cd /tmp && \
    curl -LO "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" -H 'Cookie: oraclelicense=accept-securebackup-cookie' && \
    unzip jce_policy-8.zip && \
    yes | cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/ && \
    rm jce_policy-8.zip

RUN mkdir -p /home/developer && \
    useradd developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown -R developer:developer /home/developer

#Installs configure and update Android SDK with components
ENV ANDROID_HOME /opt/android-sdk-linux 
ENV PATH ${PATH}:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools
ENV ANDROID_COMPONENTS platform-tools,build-tools-25.0.0,build-tools-25.0.1,build-tools-25.0.2,android-25
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN curl -L https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o /tmp/tools_r25.2.3-linux.zip && \
    unzip /tmp/tools_r25.2.3-linux.zip -d /opt/android-sdk-linux && \
    rm -f /tmp/tools_r25.2.3-linux.zip && \   
    echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" && \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"  && \
    chown -R developer:developer /opt/android-sdk-linux
    



VOLUME /home/developer

# Set things up using the dev user and reduce the need for `chown`s
#USER developer    

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV HOME /home/developer
#set Russian locale
ENV LC_ALL ru_RU.UTF-8 
ENV LANG ru_RU.UTF-8 
ENV LANGUAGE ru_RU.UTF-8 

CMD /opt/intellij/bin/idea.sh