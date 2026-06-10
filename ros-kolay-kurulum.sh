#!/bin/bash -eu

user_name=$(whoami)

echo -e "\e[33m>>> AslanRobotics ROS Kurulum Asistanı\e[0m"
echo -e "\e[33m>>> Desteklenen: ROS Noetic | ROS2 Humble | ROS2 Jazzy\e[0m"
echo ""

# Ubuntu sürümü tespit et
version=$(lsb_release -sc)
relesenum=$(grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}')
echo -e "\e[36m>>> Sistem: Ubuntu $version $relesenum\e[0m"
echo ""

# Ubuntu sürümüne göre ROS dağıtımını belirle
case $version in
    "focal")
        ros_distro="noetic"
        ros_label="ROS Noetic (ROS1)"
        ;;
    "jammy")
        ros_distro="humble"
        ros_label="ROS2 Humble"
        ;;
    "noble")
        ros_distro="jazzy"
        ros_label="ROS2 Jazzy"
        ;;
    *)
        echo -e "\e[31m>>> HATA: Desteklenmeyen Ubuntu sürümü: '$version'\e[0m"
        echo -e "\e[33mDesteklenen Ubuntu sürümleri:\e[0m"
        echo "  Ubuntu 20.04 (Focal)  →  ROS Noetic"
        echo "  Ubuntu 22.04 (Jammy)  →  ROS2 Humble"
        echo "  Ubuntu 24.04 (Noble)  →  ROS2 Jazzy"
        exit 1
        ;;
esac

echo -e "\e[33m>>> Ubuntu $version için önerilen: $ros_label\e[0m"
echo ""
echo "     [1. $ros_label Kur]"
echo ""
echo "     [2. ROS Kaldır]"
echo ""
read -p ">>> Seçeneklerden birini seçiniz: " answer

case "$answer" in
    1) action="install" ;;
    2) action="uninstall" ;;
    *)
        echo -e "\e[31m>>> Geçersiz seçim, çıkılıyor.\e[0m"
        exit 1
        ;;
esac

# ───────────────────── KURULUM ─────────────────────
if [ "$action" == "install" ]; then

    echo ""
    echo "###########################################################"
    echo -e "\e[33m>>> $ros_label Kurulumu Başlatılıyor\e[0m"
    echo "###########################################################"

    # Adım 1: Locale
    echo ""
    echo -e "\e[33m>>> [Adım 1] Locale ayarlanıyor...\e[0m"
    sudo apt update -y
    sudo apt install -y locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    echo -e "\e[32m>>> Locale ayarlandı.\e[0m"

    # Adım 2: Depolar
    echo ""
    echo -e "\e[33m>>> [Adım 2] Ubuntu depoları yapılandırılıyor...\e[0m"
    sudo apt install -y software-properties-common curl gnupg2 lsb-release
    sudo add-apt-repository universe -y
    sudo add-apt-repository restricted -y
    sudo add-apt-repository multiverse -y
    sudo apt update -y
    echo -e "\e[32m>>> Depolar eklendi.\e[0m"

    # Adım 3: ROS kaynağı ekle
    echo ""
    echo -e "\e[33m>>> [Adım 3] ROS kaynağı ekleniyor...\e[0m"

    if [ "$ros_distro" == "noetic" ]; then
        sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${version} main\" > /etc/apt/sources.list.d/ros-latest.list"
        ret=$(curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -)
        case $ret in
            "OK") ;;
            *) echo -e "\e[31m>>> HATA: ROS anahtarları eklenemedi\e[0m"; exit 1 ;;
        esac
    else
        # ROS2 Humble ve Jazzy için modern GPG yöntemi
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc \
            | sudo gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${version} main" \
            | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    fi
    echo -e "\e[32m>>> ROS kaynağı eklendi.\e[0m"

    # Adım 4: Paket türü seçimi
    echo ""
    echo "###########################################################"
    echo -e "\e[33m>>> [Adım 4] Kurulum türü seçin:\e[0m"
    echo ""
    echo "     [1. Desktop-Full (Tavsiye Edilen)]"
    echo "        Masaüstü + 2D/3D simülatörler + algılama paketleri"
    echo ""
    echo "     [2. Desktop]"
    echo "        RViz + rqt + temel araçlar"
    echo ""
    echo "     [3. ROS-Base (Minimal)]"
    echo "        Yalnızca iletişim kütüphaneleri, GUI araçları yok"
    echo ""
    read -p "Kurulum türünü seçin (Varsayılan 1): " pkg_answer

    case "$pkg_answer" in
        2)    package_type="desktop" ;;
        3)    package_type="ros-base" ;;
        *)    package_type="desktop-full" ;;
    esac

    # Adım 5: Kurulum
    echo ""
    echo -e "\e[33m>>> [Adım 5] ros-${ros_distro}-${package_type} kuruluyor...\e[0m"
    echo -e "\e[33m>>> (İnternet hızınıza bağlı olarak 10-30 dakika sürebilir)\e[0m"
    echo ""
    sudo apt update -y
    sudo apt install -y ros-${ros_distro}-${package_type}

    # Adım 6: Bağımlılıklar ve ortam ayarı
    echo ""
    echo -e "\e[33m>>> [Adım 6] Bağımlılıklar ve ortam ayarlanıyor...\e[0m"

    if [ "$ros_distro" == "noetic" ]; then
        sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
        if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
            sudo rosdep init
        fi
        rosdep update
    else
        sudo apt install -y ros-dev-tools python3-argcomplete
    fi

    # .bashrc'ye ekle (zaten ekliyse atla)
    if ! grep -q "source /opt/ros/${ros_distro}/setup.bash" /home/$user_name/.bashrc 2>/dev/null; then
        echo "source /opt/ros/${ros_distro}/setup.bash" >> /home/$user_name/.bashrc
    fi

    echo ""
    echo "###########################################################"
    echo -e "\e[32m>>> $ros_label kurulumu başarıyla tamamlandı!\e[0m"
    echo ""
    echo -e "\e[36m>>> Terminali yeniden başlatın veya şu komutu çalıştırın:\e[0m"
    echo -e "\e[36m    source ~/.bashrc\e[0m"
    echo "###########################################################"

# ───────────────────── KALDIRMA ─────────────────────
else
    echo ""
    echo -e "\e[33m>>> ROS kaldırma işlemi başlatılıyor...\e[0m"
    sudo apt-get purge -y 'ros-*' || true
    sudo apt-get autoremove -y
    sudo rm -f /etc/apt/sources.list.d/ros-latest.list
    sudo rm -f /etc/apt/sources.list.d/ros2.list
    sudo rm -f /usr/share/keyrings/ros-archive-keyring.gpg
    # .bashrc'den ROS kaynak satırlarını temizle
    sed -i '/source \/opt\/ros/d' /home/$user_name/.bashrc
    echo -e "\e[32m>>> ROS kaldırma işlemi başarıyla tamamlandı!\e[0m"
fi
