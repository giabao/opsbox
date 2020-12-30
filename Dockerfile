LABEL maintainer="thanhbv@sandinh.net"
FROM python:3
# why install tor?
# relayor uses the control machine as a key storage for OfflineMasterKeys.
# tor is needed to generate keys only, we do not configure a tor daemon on the control machine.
RUN apt update \
    && apt install -y \
    sudo \
    tor \
    python-netaddr \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r box \
    && useradd --no-log-init -r -ms /bin/bash -g box box \
    && echo 'box ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER box
WORKDIR /home/box
ENV PATH="/home/box/.local/bin:${PATH}"
# Need `netaddr` to use ipaddr filter
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters_ipaddr.html
RUN pip install --no-cache-dir --user ansible netaddr \
    && ansible-galaxy collection install community.general \
    && mkdir -m 755 ~/.ssh
CMD [ "ssh-agent", "bash" ]
