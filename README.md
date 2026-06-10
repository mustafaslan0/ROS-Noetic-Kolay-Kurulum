# ROS Kolay Kurulum

Ubuntu sürümünüzü otomatik algılayarak uygun ROS dağıtımını kuran evrensel kurulum betiği.

| Ubuntu Sürümü | ROS Dağıtımı | Tür |
|---|---|---|
| 20.04 Focal | ROS Noetic | ROS1 (LTS) |
| 22.04 Jammy | ROS2 Humble | ROS2 (LTS) |
| 24.04 Noble | ROS2 Jazzy | ROS2 (LTS) |

ÖRNEK VİDEO (Noetic): https://www.youtube.com/watch?v=8wgiStd4tjc

---

## Hızlı Başlangıç

```bash
git clone https://github.com/mustafaslan0/ROS-Noetic-Kolay-Kurulum.git
chmod +x ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
./ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
```

---

## Kullanım

### 1. Repoyu klonlayın

```bash
git clone https://github.com/mustafaslan0/ROS-Noetic-Kolay-Kurulum.git
```

### 2. Betiği yetkilendirin

```bash
chmod +x ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
```

### 3. Betiği çalıştırın

```bash
./ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
```

Betik Ubuntu sürümünüzü otomatik algılar ve uygun ROS dağıtımını önerir.

---

## Kurulum Seçenekleri

Kurulum sırasında hangi paket kümesini kuracağınızı seçebilirsiniz:

| Seçenek | İçerik |
|---|---|
| **Desktop-Full** (Tavsiye Edilen) | Masaüstü + 2D/3D simülatörler + algılama paketleri |
| **Desktop** | RViz + rqt + temel araçlar |
| **ROS-Base** (Minimal) | Yalnızca iletişim kütüphaneleri, GUI yok |

---

## Kaldırma

Betik çalıştırıldığında **[2. ROS Kaldır]** seçeneği ile tüm ROS paketleri, kaynak listesi girişleri ve `.bashrc` satırları temizlenir.

---

## Global Kullanım (.bashrc)

Yeni bir terminal açıldığında ROS otomatik kurulsun istiyorsanız `~/.bashrc` dosyanıza ekleyebilirsiniz:

```bash
if [ ! -f ~/.ros_installed ]; then
    sudo apt install -y git
    git clone https://github.com/mustafaslan0/ROS-Noetic-Kolay-Kurulum.git
    chmod +x ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
    ./ROS-Noetic-Kolay-Kurulum/ros-kolay-kurulum.sh
    rm -rf ROS-Noetic-Kolay-Kurulum
    touch ~/.ros_installed
fi
```

---

## Dağıtıma Özel Betikler

Belirli bir sürümü doğrudan kurmak isterseniz:

| Betik | Ubuntu | Açıklama |
|---|---|---|
| `ros-kolay-kurulum.sh` | 20.04 / 22.04 / 24.04 | **Evrensel betik (önerilen)** |
| `ros-noetic-kolay-kurulum.sh` | 20.04 Focal | Yalnızca ROS Noetic |

---

## VMware Sanal Makine (ROS Noetic Kurulu)

Doğrudan kullanıma hazır sanal makine görüntüsü:  
https://mega.nz/file/QFIDQI4Q#7iFmjgmvu26ZYVLJKaLbzw6BeOqsx_ftoXq09Uhl4jA
