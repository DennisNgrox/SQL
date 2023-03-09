#!/bin/bash

############################################################################
###                                                                      ### 
###      INSTALAÇÃO DO BANCO DE DADOS MYSQL-COMMUNITY - VERSION 8.2      ### 
###                  INSTALAÇÃO FEITA NO RedHat 8                        ###
############################################################################

# Necessário executar o script utilizando usuário com permissões de administrador (root)


# Instalando o respositorio do MySql Community 8.2
sudo dnf install https://repo.mysql.com//mysql80-community-release-el8-2.noarch.rpm -y >> /dev/null

# Repositório do Zabbix 5.0 LTS para redhat 8
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm >> /dev/null

# Desabilitar MySQL padrão
sudo yum module disable mysql -y >> /dev/null

# Instalar MySQL e Zabbix Agent2
sudo dnf install mysql-community-server -y >> /dev/null
sudo dnf install zabbix-agent2 -y >> /dev/null

# Habilitar serviço MySQL e Zabbix-Agent2
systemctl enable --now mysqld
systemctl enable --now zabbix-agent2

# Criar arquivo
touch ~/.my.cnf

# Acrescentar ao arquivo as informações do usuário root do mysql
echo [client] >> ~/.my.cnf
echo user=root >> ~/.my.cnf 
echo host=localhost >> ~/.my.cnf 

## Comandos para buscar a senha temporaria e acrecentar ao arquivo my.cnf
SENHA=$(awk -F " " '/temporary password/ {print "\""$13"\""}' /var/log/mysqld.log) 
echo password=$SENHA >> ~/.my.cnf 

# Comando para logar e alterar a senha do Mysql
mysql -u root -e "ALTER USER USER() IDENTIFIED BY 'SeNhA#20';" --connect-expired-password

# Definindo em uma varíavel a nova senha
SENHA='"SeNha#20"'

# Substituindo a antiga senha no arquivo de My.cnf
sed -i '/password/d' ~/.my.cnf
echo password=$SENHA >> ~/.my.cnf 

# Executando comandos para criar database, criar usuario e conceder privilégios.
mysql -u root -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -u root -e "create user 'zabbix'@'%' identified with mysql_native_password by 'Julia#20';"
mysql -u root -e "grant all privileges on zabbix.* to 'dennis22'@'%';"
mysql -u root -e "flush privileges;"
