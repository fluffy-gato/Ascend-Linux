clear
echo "Installing Ascend Linux"
sleep 3
clear
fdisk -l
sleep 1
echo "WARNING: Choosing the wrong disk may cause data loss!"
sleep 1
echo "What is your disk (/dev/xxx)?"
read DISK
if [[ $string =~ "nvme" ]]; then
export ROOTASC=${DISK}p2
export BOOTASC=${DISK}p1
else
export ROOTASC=${DISK}2
export BOOTASC=${DISK}1
fi
clear
echo "What do you want your username to be?"
read USER
clear
echo "Please pick a Totoro Version (gnome, xfce, plasma, diy)"
read VER
clear
if [ -z VER ]
then
echo "You have not set your VER!"

else
if [ -z "$ROOTASC" ]
then
        echo "You have not set your ROOTASC!"

else
if [ -z "$BOOTASC" ]
then
        echo "You have not set your BOOTASC!"

else        
        if [ -z "$USER" ]
         then
          echo "You have not set your USERNAME! (password will be set later)"
           else
          echo "Are you sure you want to install Ascend Linux to $ROOTASC? This is irreversible! (Type Y and press enter to confirm, press enter to cancel)"
           read CONFIRM
           if [ $CONFIRM == "Y" ]
    then
            clear
            echo "Destroying old gpt!"
            dd if=/dev/zero of=$DISK bs=512M status=progress count=1
        (
        echo g
         echo n
          echo 1
           echo  
           echo +512M
            echo t
             echo 1
              echo n
               echo 2
        echo  
         echo  
          echo w
) | sudo fdisk $DISK
        clear
         echo "Making filesystems!"
        mkfs.ext4 $ROOTASC
         mkfs.fat -F32 $BOOTASC
          echo "Finished!"
          clear
           echo "Mounting filesystems!"
          mount $ROOTASC /mnt
           mount $BOOTASC /mnt/boot --mkdir
            echo "Finished!"
             clear
              echo "Installing base system!"
            pacstrap -K /mnt linux linux-firmware base base-devel
             echo "Making user!"
         arch-chroot /mnt useradd $USER
          clear
           echo "Please set a password for the user!"
          arch-chroot /mnt passwd $USER
           mkdir /mnt/home/$USER
        arch-chroot /mnt chown -R $USER:$USER /home/$USER
         arch-chroot /mnt usermod -a -G wheel $USER
          wget https://raw.githubusercontent.com/trurune/totoro-linux/master/sudoers
           cat sudoers > /mnt/etc/sudoers
           echo "Finished!"
             clear
              echo "Installing extra packages!"
              if [ $VER == "gnome" ]
        then
             wget https://raw.githubusercontent.com/trurune/totoro-linux/master/gnome-packages.txt
              mv gnome-packages.txt /mnt/packages.txt
              wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
               mv issue /mnt/etc/issue
        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
         mv os-release /mnt/etc/os-release
              arch-chroot /mnt pacman -Sy gdm gnome gnome-extras kitty firefox networkmanager --noconfirm
               echo "Finished!"
        fi
        if [ $VER == "diy" ]
        then
         wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
               mv issue /mnt/etc/issue
        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
         mv os-release /mnt/etc/os-release
        arch-chroot /mnt pacman -S networkmanager --noconfirm
        fi
         if [ $VER == "xfce" ]
        then
             wget https://raw.githubusercontent.com/trurune/totoro-linux/master/xfce-packages.txt
              mv xfce-packages.txt /mnt/packages.txt
              wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
               mv issue /mnt/etc/issue
        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
         mv os-release /mnt/etc/os-release
              arch-chroot /mnt pacman -Sy xorg xfce4 kitty firefox networkmanager sddm --noconfirm
             echo "Finished!"
        fi
    if [ $VER == "plasma" ]
        then
             wget https://raw.githubusercontent.com/trurune/totoro-linux/master/plasma-packages.txt
              mv plasma-packages.txt /mnt/packages.txt
              wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
               mv issue /mnt/etc/issue
        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
         mv os-release /mnt/etc/os-release
              arch-chroot /mnt pacman -Sy xorg plasma-desktop sddm firefox kitty networkmanager --noconfirm
               echo "Finished!"
        fi
         echo "Efistub setup!"
        efibootmgr --create --disk $ROOTASC --part 1 --label "Ascend Linux" --loader /vmlinuz-linux --unicode 'root='$ROOTASC' rw initrd=\initramfs-linux.img'        
    echo "Finished!"
    clear
    echo "Generating fstab"
    genfstab /mnt >> /mnt/etc/fstab
    echo "Finished!"
    clear
    echo "Enabling daemons!"
    if [ $VER == "gnome" ]
    then
    arch-chroot /mnt systemctl enable gdm
    fi
    clear
    echo "Generating locales!"
    echo "Please uncomment the line where your locale is"
    read DJODJ
    nano /mnt/etc/locale.gen
    arch-chroot /mnt locale-gen
    echo "Finished!"
    clear
    echo "Setting the time zone"
    echo "What is your continent?"
    ls /usr/share/zoneinfo
    read CONTINENT
    echo "What is your timezone in that continent?"
        ls /usr/share/zoneinfo/$CONTINENT
 read ZONE
         arch-chroot /mnt ln -sf /usr/share/zoneinfo/$CONTINENT/$ZONE /etc/localtime
          echo "Finished!"

        if [ $VER == "plasma" ]
        then
        arch-chroot /mnt systemctl enable sddm
        fi
        if [ $VER == "xfce" ]
         then
          arch-chroot /mnt systemctl enable sddm
           fi
         arch-chroot /mnt systemctl enable NetworkManager
          echo "ascend-linux" > /mnt/etc/hostname
          echo "Finished!"
           clear
            echo "Installation completed! Rebooting in:"
            echo "3"
            sleep 1
            echo "2"
            sleep 1
            echo "1"
            sleep 1
            reboot

            else
             echo "Cancelled!"
              fi
fi
fi
fi
fi
