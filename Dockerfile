FROM centos:6
MAINTAINER Peter Pakos

# Update packages and install some additional ones
RUN yum -y update
RUN yum -y install http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install bash-completion openssh-clients openssh-server rsyslog vim sudo rsync htop wget tar

# Set root password
RUN echo -e 'root:rooted' | chpasswd

# SSH setup
ADD files/.ssh /root/.ssh/
RUN chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/*
RUN mkdir /var/run/sshd
RUN sed -i -e '/pam_loginuid\.so/d' /etc/pam.d/sshd
RUN sed -i 's/#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config

# Disable TTYs
RUN sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers
RUN rm -f /etc/init/tty.conf /etc/init/start-ttys.conf

# Set timezone to Europe/London
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

# Disable udev
RUN echo ' ' > /sbin/start_udev

# Disable iptables
RUN chkconfig --del iptables && rm -f /etc/init.d/iptables
RUN chkconfig --del ip6tables && rm -f /etc/init.d/ip6tables

# Enable services
RUN chkconfig rsyslog on
RUN chkconfig sshd on

# Expose SSH
EXPOSE 22

# Start init upon run
ENTRYPOINT [ "/sbin/init" ]
