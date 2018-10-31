# base > https://medium.com/agits/deploy-com-git-configurando-e-executando-um-deploy-automatizado-156e3e1bc374
FROM ubuntu

ENV dir=/var/www/html
ENV pass=123
ENV user=git

RUN apt-get update
RUN apt-get install openssh-server -y
RUN apt-get install -y git

# USUARIO GIT
RUN adduser git
RUN mkdir -p ${dir}/app.git
RUN chmod 2775 ${dir}
# RUN chown -R ${user} .git
# RUN chgrp -R ${user} .git
# RUN find .git -type d -exec chmod 755 {} +
# RUN find .git -type f -exec chmod 644 {} +
# RUN chmod +x .git/hooks/*

# SSHD 
RUN mkdir /var/run/sshd
RUN echo "${user}:${pass}" | chpasswd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# CONFIG GIT HOOKS
WORKDIR ${dir}/app.git
COPY hooks/post-receive hooks/post-receive
RUN chmod +x hooks/post-receive
# USER ${user}
RUN git init --bare
RUN chown -R ${user}:git ${dir}

# PORTA PADRAO DO SSH
EXPOSE 22
# COMANDO PARA INICIAR O SSH SERVER
RUN cd $HOME
USER root
CMD ["/usr/sbin/sshd", "-D"]