# base > https://medium.com/agits/deploy-com-git-configurando-e-executando-um-deploy-automatizado-156e3e1bc374
FROM ubuntu

ENV dir=/home/git

RUN apt-get update

# USUARIO GIT
RUN adduser git
RUN mkdir -p ${dir}/app.git/
RUN chown -R git:git ./home/

# SSHD 
RUN apt-get install openssh-server -y
RUN mkdir /var/run/sshd
RUN echo 'git:senha' | chpasswd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# GIT
RUN apt-get install -y git

# CONFIG GIT HOOKS
WORKDIR ${dir}/app.git
RUN git init --bare
COPY hooks/post-receive hooks/post-receive
RUN chmod +x hooks/post-receive

# PORTA PADRAO DO SSH
EXPOSE 22
# COMANDO PARA INICIAR O SSH SERVER
RUN cd $HOME
CMD ["/usr/sbin/sshd", "-D"]