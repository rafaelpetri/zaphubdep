#!/bin/bash

# Atualiza os repositórios
sudo apt update

# Lista de pacotes a serem instalados
PACKAGES=(
    "curl"
    "wget"
    "git"
    "vim"
    "nginx"
    "docker-ce"
    "docker-ce-cli"
    "docker-compose-plugin"
    "postgresql"
    "nodejs"
    "snapd"         # Snapd para instalar o Certbot via Snap
)

# Função para instalar pacotes
install_package() {
    if dpkg -l | grep -qw "$1"; then
        echo "$1 já está instalado."
    else
        echo "Instalando $1..."
        sudo apt install -y "$1"
    fi
}

# Instala cada pacote da lista
for package in "${PACKAGES[@]}"; do
    install_package "$package"
done

# Instala o Certbot usando Snap
if ! command -v certbot &> /dev/null; then
    echo "Instalando Certbot..."
    sudo snap install core
    sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
else
    echo "Certbot já está instalado."
fi

# Pergunta os subdomínios
echo "Digite o primeiro subdomínio (exemplo: subdominio1.dominio.com): "
read SUBDOMAIN1
echo "Digite o segundo subdomínio (exemplo: subdominio2.dominio.com): "
read SUBDOMAIN2

# Configuração do Certbot para os subdomínios
echo "Gerando certificados SSL para $SUBDOMAIN1 e $SUBDOMAIN2..."
sudo certbot --nginx -d "$SUBDOMAIN1" -d "$SUBDOMAIN2" --non-interactive --agree-tos -m seu-email@exemplo.com

echo "Certificados SSL gerados com sucesso para $SUBDOMAIN1 e $SUBDOMAIN2."

# Configuração do banco de dados PostgreSQL
echo "Configuração do banco de dados PostgreSQL:"
echo "Digite o nome do usuário para o banco de dados:"
read DB_USER
echo "Digite a senha para o usuário do banco de dados:"
read -s DB_PASS
echo "Digite o nome do banco de dados:"
read DB_NAME

# Cria o banco de dados e usuário no PostgreSQL
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

echo "Banco de dados $DB_NAME criado com sucesso e associado ao usuário $DB_USER."

# Exibe as informações finais
echo "-------------------------------------------"
echo "Informações de configuração:"
echo "Domínios escolhidos: $SUBDOMAIN1, $SUBDOMAIN2"
echo "Usuário do banco de dados: $DB_USER"
echo "Senha do banco de dados: $DB_PASS"
echo "Nome do banco de dados: $DB_NAME"
echo "-------------------------------------------"
echo "Instalação e configuração concluídas."
