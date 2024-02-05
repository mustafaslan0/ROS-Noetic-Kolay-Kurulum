#!/bin/bash -eu
#set -x

name_ros_distro=noetic 
user_name=$(whoami)


echo -e "\e[1;31m                                       
                .::::--::=              
              .-.        =  :-:         
              +         =.  = .=        
          := =          +  =    :-:     
        -- =.=         ::  =     .+ -   
      :-.  =+          =  -:      +     
   ::-.   .+-         .-  +     .+.:*.  
  =. *    =+    #     =  .-      + +:   
   =.%    #:   -+     =  =      :---+:  
   :++    *    #.    -.  =      + +     
     =   -:   ++     +  =.     *::--    
     -:-:.=  :=-    ::  +      -:..     
         =   =+     +  ::     -*+       
         =  =.=    .=  +:.:-*-* .       
         = .-=     =  .+=- .=-          
         = + =  :  =  -++-=             
         +-.:- :-#-.  -.:.              
             :=.                                                               
\e[0m"
# Başlangıçta gösterilecek havalı yazı (koyu kırmızı renkte)
echo -e "\e[1;31m
    ___         __               ____        __          __  _          
   /   |  _____/ /___ _____     / __ \____  / /_  ____  / /_(_)_________
  / /| | / ___/ / __ \`/ __ \   / /_/ / __ \/ __ \/ __ \/ __/ / ___/ ___/
 / ___ |(__  ) / /_/ / / / /  / _, _/ /_/ / /_/ / /_/ / /_/ / /__(__  ) 
/_/  |_/____/_/\__,_/_/ /_/  /_/ |_|\____/_.___/\____/\__/_/\___/____/  
\e[0m"



echo -e "\e[33m>>> AslanRobotics ROS-NOETİC kurulum asistanı\e[0m\n"

# Kullanıcıya seçenekler sunulur
echo "     [1. ROS-NOETİC Kurulumu]"
echo ""
echo "     [2. ROS-NOETİC Kaldır]"
echo ""
start="ROS-Noetic-kurulumu" 
read -p ">>> Seçeneklerden birini seçiniz:" answer 

case "$answer" in
  1)
    start="ROS-Noetic-kurulumu"
    ;;
  2)
    start="ROS-Noetic-kaldır"
    ;;

esac





if [ "$start" == "ROS-Noetic-kurulumu" ]; then

    echo "#######################################################################################################################"
    echo "Mevcut Kullanıcı: $user_name" 
    echo -e "\e[33m>>> {ROS Noetic Kurulumuna Başlanıyor}\e[0m"
    echo ""
    echo -e "\e[33m>>> {Ubuntu sürümü kontrol ediliyor}\e[0m"
    echo ""
    # Ubuntu sürümünün versiyonunu ve sürüm numarasını alın
    version=`lsb_release -sc`
    relesenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
    echo -e "\e[33m>>> {Ubuntu sürümünüz: [Ubuntu $version $relesenum]}\e[0m"
    # Sürümün focal olup olmadığını kontrol et, değilse çık
    case $version in
    "focal" )
    ;;
    *)
        echo -e "\e[31m>>> {HATA: Bu betik yalnızca Ubuntu Focal (20.04) üzerinde çalışır.}\e[0m"
        exit 0
    esac

    echo ""
    echo -e "\e[33m>>> {Ubuntu Focal 20.04, Ubuntu Focal 20.04 ile tam uyumludur}\e[0m"
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 1: Ubuntu depolarını yapılandırın}\e[0m"
    echo ""
    # "restricted," "universe," ve "multiverse" izin vermek için Ubuntu depolarını yapılandırın. Ubuntu kılavuzunu izleyerek bunu yapma talimatları için Ubuntu kılavuzunu izleyebilirsiniz. 
    # https://help.ubuntu.com/community/Repositories/Ubuntu

    sudo add-apt-repository universe
    sudo add-apt-repository restricted
    sudo add-apt-repository multiverse

    sudo apt update

    echo ""
    echo -e "\e[32m>>> {Tamamlandı: Ubuntu depoları eklendi}\e[0m"
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 2: sources.list dosyanızı ayarlayın}\e[0m"
    echo ""

    # Bu, ROS Noetic paket listesini sources.list'e ekleyecektir
    sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${version} main\" > /etc/apt/sources.list.d/ros-latest.list"

    # Dosyanın eklenip eklenmediğini kontrol et
    if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
    echo -e "\e[31m>>> {Hata: sources.list eklenemedi, çıkılıyor}\e[0m"
    exit 0
    fi

    echo -e "\e[32m>>> {Tamamlandı: sources.list eklendi}\e[0m"
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 3: Anahtarları ayarlayın}\e[0m"
    echo ""
    echo -e "\e[33m>>> {Anahtarları eklemek için curl yükleniyor}\e[0m"
    # Curl yükleyin: Proxy sunucusu arkasındaysanız apt-key komutu yerine curl'i kullanabilirsiniz: 
    #TODO: Paket kontrolü bazen çalışmıyor, bu nedenle devre dışı bırakılıyor
    # Curl yüklü mü kontrol et
    #name=curl
    #which $name > /dev/null 2>&1

    #if [ $? == 0 ]; then
    #    echo "Curl zaten yüklü!"
    #else
    #    echo "Curl yüklü değil, Curl yükleniyor"

    sudo apt install -y curl
    #fi

    echo "#######################################################################################################################"
    echo ""
    # Anahtarları ekleyin
    echo -e "\e[33m>>> {Anahtarlar eklenirken bekleniyor, birkaç saniye sürecek}\e[0m"
    echo ""
    ret=$(curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -)
    

    # Return değerini kontrol et
    case $ret in
    "OK" )
    ;;
    *)
        echo -e "\e[31m>>> {HATA: ROS anahtarları eklenemedi}\e[0m"
        exit 0
    esac

    echo -e "\e[32m>>> {Tamamlandı: Anahtarlar eklendi}\e[0m"
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 4: Ubuntu paket dizinini güncelleme, bağlantı hızınıza bağlı olarak birkaç dakika sürecektir}\e[0m"
    echo ""
    sudo apt update
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 5: ROS kurulumu, ROS'un hangi bölümünü kurmak istediğinizi seçebilirsiniz.}\e[0m"
    echo "     [1. Desktop-Full Kurulumu (Tavsiye Edilen): Masaüstüne ek olarak 2D/3D simülatörler ve 2D/3D algılama paketleri içerir]"
    echo ""
    echo "     [2. Desktop Kurulumu: ROS-Base'deki her şeyin yanı sıra rqt ve rviz gibi araçları içerir]"
    echo ""
    echo "     [3. ROS-Base: (Temel) ROS paketleme, derleme ve iletişim kütüphaneleri. GUI araçları yok.]"
    echo ""
    # Varsayılan değeri 1 olarak atayın: Desktop full kurulum
    read -p "Kurulumunuzu seçin (Varsayılan 1):" answer 

    case "$answer" in
    1)
        package_type="desktop-full"
        ;;
    2)
        package_type="desktop"
        ;;
    3)
        package_type="ros-base"
        ;;
    * )
        package_type="desktop-full"
        ;;
    esac
    echo "#######################################################################################################################"
    echo ""
    echo -e "\e[33m>>>  {ROS kurulumu başlatılıyor, yaklaşık 20 dakika sürecektir. İnternet bağlantınıza bağlı olarak değişir}\e[0m"
    echo ""
    ros_kurulumu_tamamlandi=1
    sudo apt-get install -y ros-${name_ros_distro}-${package_type} > log.txt &
    pid1=$!
    while ros_kurulumu_tamamlandi; do
    satir_sayisi=$(wc -l < log.txt)
    yuzde=$((satir_sayisi / 200)) 
    echo "ilerleme: $yuzde"
    sleep 1  # Örnek olarak 0.1 saniye bekleme

    # İkinci işlem: ROS kurulumu tamamlandığında

    done &
    pid2=$!
    wait $pid1
    ros_kurulumu_tamamlandi=0
    wait $pid2

    echo ""
    echo ""
    echo "#######################################################################################################################"
    echo -e "\e[33m>>> {Adım 6: ROS Çevresini Ayarlama, Bu, ROS çevresini .bashrc'ye ekleyecektir.}\e[0m" 
    echo -e "\e[33m>>> {Bunu ekledikten sonra, terminalde ROS komutlarına erişebileceksiniz}\e[0m"
    echo ""
    echo "source /opt/ros/noetic/setup.bash" >> /home/$user_name/.bashrc
    source /home/$user_name/.bashrc
    source /opt/ros/noetic/setup.bash
    sudo apt install -y python3-rosdep python3-rosinstall python3
    echo -e "\e[32mROS Noetic kurulumu tamamlandı.\e[0m"

else
    echo -e "\e[32mRos kaldırma işlemi başlatılıyor...\e[0m"
    sudo apt-get purge ros-* 
    sudo apt-get autoremove
    echo -e "\e[32mRos kaldırma işlemi Başarı ile tamamlandı...\e[0m"
fi
