#!/bin/bash

# Baixar e instalar o pacote de repositório do Zabbix
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb

# Atualizar a lista de pacotes
apt update

# Instalar pacotes necessários do Zabbix e MySQL
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server -y

# Configuração do MySQL
mysql -u root --password="" -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -u root --password="" -e "create user zabbix@localhost identified by 'Senai@134';"
mysql -u root --password="" -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -u root --password="" -e "set global log_bin_trust_function_creators = 1;"

# Importar a estrutura do banco de dados 
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix --password="Senai@134" zabbix

# Desativar a opção log_bin_trust_function_creators
mysql -u root --password="" -e "set global log_bin_trust_function_creators = 0;"

# Alterações banco de dados no arquivo de configuração
echo 'DBPassword=Senai@134' >> /etc/zabbix/zabbix_server.conf

# Reiniciar e ativar os serviços do Zabbix, Apache2 e habilitá-los
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2