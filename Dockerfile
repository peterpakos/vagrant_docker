FROM centos:6
MAINTAINER Peter Pakos

# Set timezone to BST
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

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

# Disable udev
RUN echo ' ' > /sbin/start_udev

# Disable iptables
RUN chkconfig --del iptables && rm -f /etc/init.d/iptables

# Enable services
RUN chkconfig rsyslog on
RUN chkconfig sshd on

# Java setup
ADD files/set_java_home.sh /etc/profile.d/set_java_home.sh
RUN update-alternatives --install /usr/bin/java java /usr/java/default/bin/java 1
RUN update-alternatives --set java /usr/java/default/bin/java
RUN update-alternatives --install /usr/bin/javac javac /usr/java/default/bin/javac 1
RUN update-alternatives --set javac /usr/java/default/bin/javac
RUN update-alternatives --install /usr/bin/jar jar /usr/java/default/bin/jar 1
RUN update-alternatives --set jar /usr/java/default/bin/jar

# Expose SSH
EXPOSE 22

# Start init upon run
ENTRYPOINT [ "/sbin/init" ]
