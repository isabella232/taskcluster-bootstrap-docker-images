FROM ubuntu:bionic-20180821@sha256:b5309340de7a9a540cf6c0cba3eabdfb9c9bc5153026d37991fd0028180fc725

RUN apt-get update -q && apt-get install -qy --no-install-recommends \
        git \
        python3-pip \
        python3-setuptools \
    && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install \
        # Output of "pip freeze" in a virtualenv after "pip install taskcluster" as of 2018-09-11
        aiohttp==3.4.4 \
        async-timeout==3.0.0 \
        attrs==18.2.0 \
        certifi==2018.8.24 \
        chardet==3.0.4 \
        idna==2.7 \
        idna-ssl==1.1.0 \
        mohawk==0.3.4 \
        multidict==4.4.0 \
        requests==2.19.1 \
        six==1.11.0 \
        slugid==1.0.7 \
        taskcluster==4.0.1 \
        urllib3==1.23 \
        yarl==1.2.6 \
    && \
    python3 -c 'import taskcluster'  # check that it was installed correctly

