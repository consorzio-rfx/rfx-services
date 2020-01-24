FROM jupyter/pyspark-notebook

USER root
RUN apt-get -y update; \
    apt-get -y install curl gnupg;

RUN curl -fsSL http://www.mdsplus.org/dist/mdsplus.gpg.key | sudo apt-key add -; \
    echo 'deb [arch=amd64] http://www.mdsplus.org/dist/Ubuntu18/repo MDSplus alpha' | sudo tee /etc/apt/sources.list.d/mdsplus.list; \
    echo 'deb [arch=amd64] http://www.mdsplus.org/dist/Ubuntu18/repo MDSplus stable' | sudo tee /etc/apt/sources.list.d/mdsplus.list; \
    apt-get -y update; \
    apt-get -y install mdsplus;

RUN cd /usr/local/mdsplus/python/MDSplus; \
    python2 setup.py install; \
    python3 setup.py install

RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java;

USER jovyan