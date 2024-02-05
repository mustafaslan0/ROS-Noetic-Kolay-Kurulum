#!/bin/bash


#      ___         __              ____        __          __  _                __            __  
#     /   |  _____/ /___ _____    / __ \____  / /_  ____  / /_(_)_________     / /____  _____/ /_ 
#    / /| | / ___/ / __ `/ __ \  / /_/ / __ \/ __ \/ __ \/ __/ / ___/ ___/    / __/ _ \/ ___/ __ \
#   / ___ |(__  ) / /_/ / / / / / _, _/ /_/ / /_/ / /_/ / /_/ / /__(__  ) _  / /_/  __/ /__/ / / /
#  /_/  |_/____/_/\__,_/_/ /_/ /_/ |_|\____/_.___/\____/\__/_/\___/____/ (_) \__/\___/\___/_/ /_/ 
#         


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



echo -e "Bu script, belirtilen GitHub reposunu içeren bir çalışma alanı (workspace) oluşturur.\n"

# Kullanıcıdan çalışma alanı adını al
read -p "Çalışma alanı adını girin: " workspace_name

# Çalışma alanı dizini oluştur
workspace_dir="$PWD/$workspace_name"
mkdir -p "$workspace_dir"
cd "$workspace_dir"

# src klasörü oluştur
mkdir -p src
cd src

# GitHub reposunu indir
echo -e "\n\e[1;34mGitHub reposunu indiriliyor...\e[0m"
git clone https://github.com/mustafaslan0/diff_drive_basic_py.git

# Çalışma alanına geri dön
cd ..

# catkin_make ile çalışma alanını derle
echo -e "\n\e[1;34mÇalışma alanı derleniyor...\e[0m"
catkin_make

echo -e "\n\e[1;32mSetup tamamlandı. Çalışma alanınız: $workspace_dir\e[0m"
