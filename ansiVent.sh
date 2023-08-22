r="\e[31m"
g="\e[32m"
y="\e[33m"
m="\e[35m"
end="\e[0m"

lokasiH="/etc/ansible/hosts"

nambah() {
  echo -e "\n" >> ltarget.txt
  cat ltarget.txt >> /etc/ansible/hosts
}

hapus() {
  sudo rm -rf ltarget.txt
}

hapusH() {
  sudo rm -rf /etc/ansible/hosts
}

gawe() {
  touch ltarget.txt
}

takon2() {
  if [[ "$1" == -s || "$1" == --silent ]]; then
  echo -e "${g}File ditemukan${end}\n"
  else
    echo -e "\n"
    cat "$lokasiH"
  fi
}

takon3() {
  if [[ "$1" == -s || "$1" == --silent ]]; then
    echo -e "${g}Proses hapus berhasil${end}"
  else
    echo -e "${r}\nBerikut isi file inventory sebelum\n${end}"
    cat hai
    echo -e "${g}Berikut isi file inventory sesudah\n${end}"
    cat "$lokasiH"
  fi
}

takon() {
  if [[ "$1" == -s || "$1" == --silent ]]; then
    echo -e "${g}Proses menambahkan target ke hosts berhasil${end}\n"
  else
    echo -e "${g}\nTarget berhasil ditambahkan ke hosts${end}\n"
    cat /etc/ansible/hosts
    echo -e "\n"
  fi
}

semangat() {
  echo -e "${m}\n\\    ||======================\ ${end}"
  echo -e "${m}||==||${end}" "${g}Ansible Inventory Tool${end}" "${m}====>${end}"
  echo -e "${m}/    ||======================/${end}"
}

if [[ -z "$1" ]]; then
  semangat
  echo "Untuk bantuan: ./ansiVent.sh -h"
  echo -e "               ./ansiVent.sh --help\n"
elif [[ "$1" == -h || "$1" == --help ]]; then
  semangat
  echo -e "${y}Menu:${end}"
  echo -e "${y}1. Tambahkan hosts${end}"
  echo -e "${y}2. Tambahkan group${end}"
  echo -e "${y}3. Cek file hosts${end}"
  echo -e "${y}4. Buat file inventory${end}"
  echo -e "${y}5. Hapus file inventory${end}"
  echo -e "${y}6. Hapus hosts${end}"
  echo -e "${y}7. Hapus group${end}"
  echo -e "${y}8. Tentang tools ini${end}\n"
  echo -e "Penggunaan: ./ansiVent.sh [menu]"
  echo -e "            ./ansiVent.sh 1"
  echo -e "            ./ansiVent.sh 2"
  echo -e "\nUntuk mode diam/tanpa detail output: ./ansiVent.sh [menu] -s"
  echo -e "                                     ./ansiVent.sh [menu] --silent\n"
elif [[ "$1" == 1 ]]; then
  semangat
  echo "Silahkan masukan hosts:"
  read target
  echo "Proses menambahkan $target ke file /etc/ansible/hosts"
  echo -e "$target\n" >> /etc/ansible/hosts
  takon $2
elif [[ "$1" == 2 ]]; then
  semangat
  echo "Berapa jumlah hosts yang akan anda masukan kedalam grup $grup??"
  echo "Apabila 1-3 isikan dengan angka, apabila lebih dari 3 masukan list seperti contoh: etc/file.txt"
  read jtarget
  echo "Silahkan masukan nama group:"
  read grup
  gawe
  echo "[$grup]" >> ltarget.txt
  filter=$(echo "$jtarget" | grep -E "csv|txt|/")
  if [[ -z $filter ]]; then
    if [[ $jtarget == 1 ]]; then
      echo "Silahkan masukan hosts"
      read haha
      echo "$haha" >> ltarget.txt
      nambah
      takon $2
      hapus
    elif [[ $jtarget == 2 ]]; then
      echo "Silahkan masukan hosts 1 per 1"
      read haha
      echo "$haha" >> ltarget.txt
      echo "Silahkan masukan hosts ke 2"
      read haha2
      echo "$haha2" >> ltarget.txt
      nambah
      takon $2
      hapus
    elif [[ $jtarget == 3 ]]; then
      echo "Silahkan masukan target 1 per 1"
      read haha
      touch ltarget.txt
      echo "$haha" >> ltarget.txt
      echo "Silahkan masukan target ke 2"
      read haha2
      echo "$haha2" >> ltarget.txt
      echo "Silahkan masukan target ke 3"
      read haha3
      echo "$haha3" >> ltarget.txt
      nambah
      takon $2
      hapus
    fi
  else
    cat "$jtarget" >> ltarget.txt
    nambah
    takon $2
    hapus
  fi
elif [[ "$1" == 3 ]]; then
  semangat
  echo "Proses cek file inventory"
  if [ -e "$lokasiH" ]; then
    takon2 $2
  else
    echo -e "${r}File tidak ditemukan${end}\n"
  fi
elif [[ "$1" == 4 ]]; then
  semangat
  echo "Proses membuat file inventory"
  touch /etc/ansible/hosts
  if [ -e "$lokasiH" ]; then
    echo -e "${g}Sukses membuat file inventory${end}\n"
  else
    echo -e "${r}Gagal membuat file inventory${end}\n"
  fi
elif [[ "$1" == 5 ]]; then
  semangat
  echo "Cek file inventory"
  if [ -e "$lokasiH" ]; then
    echo "Proses menghapus file inventory"
    hapusH
    if [ -e "lokasiH" ]; then
      echo -e "${g}Proses menghapus file inventory tidak berhasil${end}\n"
    else
      echo -e "${r}Proses menghapus file inventory gagal${end}\n"
    fi
  else
    echo -e "${g}Proses menghapus file inventory berhasil${end}\n"
  fi
elif [[ "$1" == 6 ]]; then
  semangat
  echo "Silahkan masukan hosts yang ingin dihapus"
  read target
  touch hai
  cp "$lokasiH" hai
  cat hai | grep -Ev "$target" > "$lokasiH"
  ae=$(cat "$lokasiH" | wc -l)
  au=$(cat hai | wc -l)
  if [[ $au -gt $ae ]]; then
    takon3 $2
  else
    echo -e "${r}Proses hapus $target dari inventory gagal${end}\n"
  fi
  sudo rm -rf hai
elif [[ "$1" == 7 ]]; then
  semangat
  echo "Silahkan masukan group yang ingin dihapus"
  read target
  touch hai
  cp "$lokasiH" hai
  cat hai | sed '/'$target'/,/^$/d' > "$lokasiH"
  cat "$lokasiH"
  ae=$(cat "$lokasiH" | wc -l)
  au=$(cat hai | wc -l)
  if [[ $au -gt $ae ]]; then
    takon3 $2
  else
    echo -e "${r}Proses hapus $target dari inventory gagal${end}\n"
  fi
  sudo rm -rf hai
elif [[ "$1" == 8 ]]; then
  semangat
  echo -e "\n${g}Pemulung${end}" "${y}ilmu${end}" "${r}para${end}" "${m}suhu,${end}" "${y}mengagumimu${end}" "${r}dalam${end}" "${g}diam${end}\n"
else
  echo -e "${r}Inputan tidak sesuai program auto close ya boskuh${end}\n"
fi