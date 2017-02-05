FROM ubuntu:16.04

MAINTAINER ZanyXDev "zanyxdev@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
#set Russian locale
ENV LC_ALL ru_RU.UTF-8 
ENV LANG ru_RU.UTF-8 
ENV LANGUAGE ru_RU.UTF-8 

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
	rm -rf /var/lib/apt/lists/* && \
	locale-gen ru_RU.UTF-8

# fix default setting
#ln -s java-8-openjdk-amd64 /usr/lib/jvm/default-jvm

# TODO add encrypt polisy AES 256 key

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo


#Installs and configure Android SDK
RUN curl -L https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o /tmp/tools_r25.2.3-linux.zip && \
    unzip /tmp/tools_r25.2.3-linux.zip -d /home/developer/android-sdk-linux && \
    rm -f /tmp/tools_r25.2.3-linux.zip
RUN cd /home/developer/android-sdk-linux/tools && \
    echo y | ./android update sdk --all --no-ui --force --filter android-22 && \
    echo y | ./android update sdk --all --no-ui --force --filter platform-tools && \
    echo y | ./android update sdk --all --no-ui --force --filter extra-android-m2repository && \
    echo y | ./android update sdk --all --no-ui --force --filter extra-google-m2repository && \
    echo y | ./android update sdk --all --no-ui --force --filter source-22 && \
    echo y | ./android update sdk --all --no-ui --force --filter build-tools-22.0.1 && \
    echo y | ./android update sdk --all --no-ui --force --filter android-21 && \
    echo y | ./android update sdk --all --no-ui --force --filter build-tools-21.1.2 && \
    chown -R developer:developer /home/developer/android-sdk-linux

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-2016.3.4-no-jdk.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    chmod +x /opt/intellij/bin/idea.sh && \
    chown -R developer:developer /opt/intellij  && \
    rm /tmp/intellij.tar.gz

RUN mkdir -p /home/developer/.IdeaIC2016.3/config/options && \
    mkdir -p /home/developer/.IdeaIC2016.3/config/plugins && \
    mkdir -p /home/developer/IdeaProject && \
    echo 'Installing Markdown plugin' && \
    wget https://plugins.jetbrains.com/files/7793/31990/markdown-2017.1.20170119.zip -O markdown.zip -q && \
    unzip -q markdown.zip -d /home/developer/.IdeaIC2016.3/config/plugins/ && \
    rm markdown.zip && \
    chown -R developer:developer /home/developer/.IdeaIC2016.3


#Install Gradle
ENV GRADLE_URL http://services.gradle.org/distributions/gradle-3.3-all.zip
RUN curl -L ${GRADLE_URL} -o /tmp/gradle-3.3-all.zip && unzip /tmp/gradle-3.3-all.zip -d /usr/local && rm /tmp/gradle-3.3-all.zip

RUN chown developer:developer -R /home/developer

# Set things up using the dev user and reduce the need for `chown`s
USER developer
ENV ANDROID_HOME="/home/developer/android-sdk-linux" \
    PATH="${PATH}:/home/developer/android-sdk-linux/tools:/home/developer/android-sdk-linux/platform-tools" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    GRADLE_HOME="/usr/local/gradle-3.3"

WORKDIR /home/developer/IdeaProject

ENV HOME /home/developer
CMD /opt/intellij/bin/idea.sh