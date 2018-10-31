# base > https://medium.com/agits/deploy-com-git-configurando-e-executando-um-deploy-automatizado-156e3e1bc374
FROM ubuntu:latest

ARG teste=defaultValue

# VARIAVEIS
ENV dir=/var/www/html
ENV pass=123
ENV user=git
# END VARIAVEIS

# INSTALAÇÕES
RUN apt-get update
RUN apt-get install openssh-server -y
RUN apt-get install -y git
# END INSTALAÇÕES

# USUARIO GIT
RUN adduser git
RUN mkdir -p ${dir}/app.git
RUN chmod 2775 ${dir}
# END USUARIO

# SSHD 
RUN mkdir /var/run/sshd
RUN echo "${user}:${pass}" | chpasswd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
# END SSHD

# CONFIG GIT HOOKS
WORKDIR ${dir}/app.git
COPY hooks/post-receive hooks/post-receive
RUN chmod +x hooks/post-receive
RUN git init --bare
# END CONGIG GIT HOOKS

# MUDA PROPRIETARIO PARA O USUARIO 
RUN chown -R ${user}:git ${dir}

# PORTA PADRAO DO SSH
EXPOSE 22

# VOLTA PARA HOME PARA HABILIAR O COMANDO
RUN cd $HOME

# COMANDO PARA INICIAR O SSH SERVER
CMD ["/usr/sbin/sshd", "-D"]