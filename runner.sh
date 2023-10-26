sshkeypath=/home/kali/.ssh/id_ed25519
vaultpass=pinephone

setuponce(){
echo Setup brains of Ansible
sudo apt update && sudo apt install ansible -y
sudo apt install sshpass
ansible-galaxy collection install ansible.windows

echo setup Windows:
echo "powershell && start-process powershell -verb runas"

echo "Get-WindowsCapability -Online | ? name -like *OpenSSH.Server* | Add-WindowsCapability -Online"
echo "New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22"
echo "New-ItemProperty -Path \"HKLM:\SOFTWARE\OpenSSH\" -Name DefaultShell -Value \"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\" -PropertyType String -Force"

# powershell
#always start ssh
Set-Service -Name sshd -StartupType 'Automatic'  # cmd?: sc config sshd start= auto
Start-Service -Name sshd
#arba services.msc

#ssh-copy-id -i anbexam.pub notubuntu@192.168.56.106
#admin cmd.exe
#echo "cat ssh.pub" >> C:\ProgramData\ssh\administrators_authorized_keys 

}

makekey(){
#ssh-keygen -t ed25519 -b 521 -C "SSH key ansible edu" ## Edwards-curve Digital Signature Algorithm - EdDSA 
ssh-keygen -t ecdsa -b 521 -f anbexam ## ~ Elliptic-curve Diffie–Hellman (ECDH) - as given in task

ansible-vault encrypt_string abcxyz
#vault pwd: pinephone
#ansible-doc -l
}

### setuponce
### makekey

echo Run Playbooks

echo paleidžia PING Windows ir Linux Operacinems Sistemoms
ansible-playbook pl6ping.yml -i inventory.yml --vault-password-file <(echo $vaultpass) -vv #--key-file $sshkeypath  #paleidžia "PING" Windows ir Linux Operacinems Sistemoms (Pasinaudoti When)

echo New user
#sleep 20s
ansible-playbook pl7newuser.yml -i inventory.yml --vault-password-file <(echo $vaultpass) -vv #--key-file $sshkeypath #sukurtu naują vartotoją (User) Windows ir Linux Operacinėms Sistemos, pridėti jį į Admin / Sudo teises. Playbooką padaryti pasinaudojus When.
#sleep 20s
echo Time sync windows
ansible-playbook pl8timesync.yml -i inventory.yml --vault-password-file <(echo $vaultpass) --limit pc3  -vv ##--key-file $sshkeypath ### 8 NTP Time Sync Windows


echo restart
ansible-playbook pl10reboot.yml -i inventory.yml --vault-password-file <(echo $vaultpass)  -vv #--key-file $sshkeypath #restartuoja Windows ir Linux

echo "sleep 20 seconds (because ansibele waits for windows reboot, to check if started again) "
#sleep 20s

echo poweroff
ansible-playbook pl9poweroff.yml -i inventory.yml --vault-password-file <(echo $vaultpass) -vv #--key-file $sshkeypath #išjungia iš karto Windows ir Linux
