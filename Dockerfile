FROM centos:6
MAINTAINER Peter Pakos

RUN yum -y install http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install bash-completion openssh-clients openssh-server rsyslog vim sudo rsync htop nmap
RUN yum -y update

RUN echo -e 'root:rooted' | chpasswd

RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYKV83n9tnQoVDPKdBydMEoPQWe2Uh1Qot+w6kQ8xqMQJsuaMql4cSEWbtXbeK7EIflw/qXL5r74EEdE5aHlwdXq++wAtfCeXbGt6PNY7L3OGbPjWS5kPlFB+1oBvBU8u+/4g3S3UMmGnyXSzaOMIcOz+eGsI98KTiOgXg1D/E5rKRJQdGal1LarenPjIlkCgHbUoHyDXJj7NT4TI4G2uWcDh1VfoHxvJREzfyv0yIeOtaj7wgvzO36o4JaL9odcvx+6nVd1F7ZwPOyBW+AMmrqmfFrVbCgPG3I+kvGicFu7vuJEPzbmNdHRM462XqcOUG6RGDUW+aFDCz/PhJlIFD custom vagrant key' > /root/.ssh/authorized_keys
RUN chmod -R 0600 /root/.ssh

RUN mkdir /var/run/sshd
RUN sed -i -e '/pam_loginuid\.so/d' /etc/pam.d/sshd
RUN sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers
RUN rm -f /etc/init/tty.conf /etc/init/start-ttys.conf
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo ' ' > /sbin/start_udev

RUN chkconfig --del iptables && rm -f /etc/init.d/iptables
RUN chkconfig rsyslog on
RUN chkconfig sshd on

EXPOSE 22

ENTRYPOINT [ "/sbin/init" ]
