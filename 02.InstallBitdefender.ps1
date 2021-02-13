#Install BitDefender Total Security
cd ~/Downloads
Invoke-WebRequest -Uri https://download.bitdefender.com/windows/installer/en-us/bitdefender_tsecurity.exe -OutFile bitdefender_tsecurity.exe
./bitdefender_tsecurity.exe /bdparams /silent silent