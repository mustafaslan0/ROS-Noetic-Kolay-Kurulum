# ROS-Noetic-Kolay-Kurulum



Bu repo, ROS Noetic'in kolay bir şekilde kurulumunu sağlamak için bir betik içerir.

  ```bash
    git clone https://github.com/mustafaslan0/ROS-Noetic-Kolay-Kurulum.git
    ```


## Kullanım

1. Betiği çalıştırmadan önce yetkilendirme yapın:
    ```bash
    chmod +x ros-noetic-kolay-kurulum.sh
    ```

2. Betiği çalıştırın:
    ```bash
    ./ros-noetic-kolay-kurulum.sh
    ```

3. İlk olarak, kurulum veya kaldırma yapmak istediğinizi soran bir soru alacaksınız.

## kurulum 

4. Kurulum için "1" tuşuna basın.

5. Ardından, ROS Noetic'in sürümünü seçin:
   - desktop-full: Tüm paketleri içerir.
   - desktop: Standart masaüstü paketlerini içerir.
   - base: Minimum kurulumu içerir.

6. Seçiminize göre devam edin.

## kaldırma

4. kaldırmak için "2" tuşuna basın. Ardından kadırma işlemleri otomatik olarak gerçekleşecektir.


## Örnek Kullanım

```bash
# Betiği yetkilendirme
chmod +x ros-noetic-kolay-kurulum.sh

# Betiği çalıştırma
./ros-noetic-kolay-kurulum.sh


# sadece .bashrc ye ekleyerekde kullanıla bilir
if [ ! -f ~/.ros_installed ]; then
    sudo apt install git
    git clone https://github.com/mustafaslan0/ROS-Noetic-Kolay-Kurulum.git
    chmod +x ROS-Noetic-Kolay-Kurulum/ros-noetic-kolay-kurulum.sh
    ./ROS-Noetic-Kolay-Kurulum/ros-noetic-kolay-kurulum.sh
    rm -rf ROS-Noetic-Kolay-Kurulum
    touch ~/.ros_installed
fi


