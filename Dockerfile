FROM centos:6
MAINTAINER Peter Pakos

RUN yum -y install http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install bash-completion openssh-clients openssh-server rsyslog vim sudo rsync htop nmap
RUN yum -y update

RUN echo -e 'root:rooted' | chpasswd

RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /root/.ssh/authorized_keys
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
