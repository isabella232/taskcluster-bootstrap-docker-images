FROM ubuntu:bionic-20180821@sha256:b5309340de7a9a540cf6c0cba3eabdfb9c9bc5153026d37991fd0028180fc725

RUN apt-get update -q && apt-get install -qy --no-install-recommends \
        git \
        python3-pip \
        python3-setuptools \
    && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install \
        # Output of "pip freeze" in a virtualenv after "pip install taskcluster" as of 2019-11-05
        aiohttp==3.6.2 \
        async-timeout==3.0.1 \
        attrs==19.3.0 \
        certifi==2019.9.11 \
        chardet==3.0.4 \
        idna==2.8 \
        mohawk==1.1.0 \
        multidict==4.5.2 \
        requests==2.22.0 \
        six==1.12.0 \
        slugid==2.0.0 \
        taskcluster==22.0.0 \
        taskcluster-urls==11.0.0 \
        urllib3==1.25.6 \
        yarl==1.3.0 \
    && \
    python3 -c 'import taskcluster'  # check that it was installed correctly

