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
read -p "Digite o primeiro subdomínio (exemplo: subdominio1.dominio.com): " SUBDOMAIN1
read -p "Digite o segundo subdomínio (exemplo: subdominio2.dominio.com): " SUBDOMAIN2

# Configuração do Certbot para os subdomínios
echo "Gerando certificados SSL para $SUBDOMAIN1 e $SUBDOMAIN2..."

sudo certbot --nginx -d "$SUBDOMAIN1" -d "$SUBDOMAIN2" --non-interactive --agree-tos -m seu-email@exemplo.com

echo "Certificados SSL gerados com sucesso para $SUBDOMAIN1 e $SUBDOMAIN2."
echo "Instalação concluída."
