FROM centos:6
MAINTAINER Peter Pakos

RUN yum -y install http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install bash-completion openssh-clients openssh-server rsyslog vim sudo rsync htop nmap
RUN yum -y update

RUN echo -e 'root:rooted' | chpasswd

ADD files/.ssh /root/.ssh/
RUN chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/*

RUN mkdir /var/run/sshd
RUN sed -i -e '/pam_loginuid\.so/d' /etc/pam.d/sshd
RUN sed -i 's/#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config
RUN sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers
RUN rm -f /etc/init/tty.conf /etc/init/start-ttys.conf
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo ' ' > /sbin/start_udev

RUN chkconfig --del iptables && rm -f /etc/init.d/iptables
RUN chkconfig rsyslog on
RUN chkconfig sshd on

EXPOSE 22

ENTRYPOINT [ "/sbin/init" ]
