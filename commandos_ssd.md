# Criando key SSH 

Não tem onde colocar msm vai ser aqui. (remove as imagens <none> do doker images)

´docker rmi $(docker images -f dangling=true -q)´


* Lista as chaves ja existentes

´ls -al ~/.ssh´

    id_rsa e is_rsa.pub são chaves padrão. (useas se solber a senha).

## Criando uma key SSH

```sh
 ssh-keygen -t rsa -b 4069 -C "<MEU_EMAIL>"

# Enter
# Digite uma senha e a confirme 
# Enter
```

Até onde sei funcionou na maquina  talves precisa de modificação no Docker

Logo após tem que executar esse comando aqui

```sh
# pesquisar para ver oque é isso
 eval "$(ssh-agent -s)"
```

## Adicionando no SSH-AGENT

Cara se tudo estiver OK e deichou como padrão basta adicionar com esse comando aqui

```sh
ssh-add ~/.ssh/id_rsa
```

Para imprimir a nova key ssh : 

`cat ~/.ssh/id_rsa.pub`

# sshd SERVIDOR

Por padrao acessa o usuario ´root@host´ é desabilitado entao crie um usuario e atribua uma senha