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
    # Adicione mais pacotes conforme necessário
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

echo "Instalação concluída."
