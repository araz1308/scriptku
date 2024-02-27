#!/bin/bash

# Fungsi untuk membuat UUID secara otomatis
generate_uuid() {
    uuid=$(cat /proc/sys/kernel/random/uuid)
    echo "$uuid"
}

# Fungsi untuk membuat akun VMess dengan limitasi perangkat
create_vmess_account() {
    username="$1"
    account_duration="$2"    # Masa aktif akun dalam format "x days"
    max_devices="$3"         # Jumlah maksimum perangkat yang diizinkan

    # Membuat UUID untuk akun VMess
    uuid=$(generate_uuid)

    # Membuat file konfigurasi untuk akun VMess
    cat > "/etc/v2ray/users/${username}_tls.json" << EOF
{
    "id": "$uuid",
    "flow": "xtls-rprx-direct",
    "email": "admin@example.com",
    "encryption": "none",
    "expires": "$account_duration",
    "ip": {
        "inbound": [
            {
                "port": "8080",
                "listen": "127.0.0.1",
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "$uuid",
                            "alterId": 64
                        }
                    ],
                    "detour": {
                        "to": "vmess-device-limit",
                        "settings": {
                            "maxUplink": $max_devices,
                            "maxDownlink": $max_devices
                        }
                    }
                },
                "tag": "proxy"
            }
        ],
        "outbound": null
    },
    "streamSettings": {
        "network": "ws",
        "security": "tls",
        "wsSettings": {
            "path": "/example"
        }
    }
}
EOF

    # Menampilkan pesan konfirmasi
    echo "Akun VMess untuk pengguna $username dengan UUID $uuid dan limit perangkat $max_devices telah berhasil dibuat."
}

# Menampilkan header
echo "======================================="
echo "   SELAMAT DATANG DI PENGELOLA VMess"
echo "======================================="
echo

# Membersihkan layar
clear

# Meminta pengguna untuk memasukkan detail akun VMess
read -p "Masukkan nama pengguna untuk akun VMess: " username
read -p "Masukkan masa aktif untuk akun VMess (misal: '30 days'): " account_duration
read -p "Masukkan jumlah maksimum perangkat yang diizinkan (misal: '2'): " max_devices
echo

# Membuat akun VMess dengan detail yang dimasukkan pengguna
create_vmess_account "$username" "$account_duration" "$max_devices"

# Menampilkan footer
echo "======================================="
echo "     Terima kasih telah menggunakan layanan kami - araz1308"
echo "======================================="
