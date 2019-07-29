FROM centos:centos7.6.1810
COPY wazuh.repo /etc/yum.repos.d/wazuh.repo
RUN rpm --import http://packages.wazuh.com/key/GPG-KEY-WAZUH ; yum install wazuh-agent openssl -y
ENV  WAZUH_MANAGER_IP="wazuh-cluster.wauzh.svc.cluster.local"
COPY init.sh /
COPY ossec.conf /var/ossec/etc/ossec.conf
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]