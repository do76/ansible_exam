# ansible_exam

NTP time sync could be better (doesn't work on ansible, but works if trying that whole command yourself)  
New linux admin user works, but bash shell is a bit weird  (no arrow key up to use previous command), but sudo works  

<pre>
Linux brains:
sudo apt update && sudo apt install ansible -y
sudo apt install sshpass
ansible-galaxy collection install ansible.windows

Windows:
powershell && start-process powershell -verb runas

Get-WindowsCapability -Online | ? name -like *OpenSSH.Server* | Add-WindowsCapability -Online
# arba windows settings -> apps & features -> add optional features -> "openssh server"
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

#always start ssh
Set-Service -Name sshd -StartupType 'Automatic'  # cmd?: sc config sshd start= auto
Start-Service -Name sshd
#arba services.msc

ssh-copy-id -i anbexam.pub notubuntu@192.168.56.106
echo "cat ssh.pub" >> C:\ProgramData\ssh\administrators_authorized_keys 
</pre>