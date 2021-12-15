if grep -i ubuntu /etc/os-release>/dev/null; then
    wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    apt update
    apt install sysinternalsebpf # Install EBPF prerequisitite
    apt install sysmonforlinux # Install sysmonforlinux
elif grep -i debian /etc/os-release>/dev/null; then
    wget https://packages.microsoft.com/config/debian/$(lsb_release -rs)/packages-microsoft-prod.deb # Download microsoft repository installer
    dpkg -i packages-microsoft-prod.deb
    apt update
    apt install sysinternalsebpf # Install EBPF prerequisitite
    apt install sysmonforlinux # Install sysmonforlinux
elif grep -i CentOS /etc/os-release>/dev/null; then
    rpm -Uvh https://packages.microsoft.com/config/centos/8/packages-microsoft-prod.rpm
    dnf install sysinternalsebpf
    dnf install sysmonforlinux
else
    echo "OS Not supported"
    exit 1

wget https://raw.githubusercontent.com/N4SOC/N4Sysmon/main/linux_sysmon.xml # Download node4 sysmon config

sysmon -accepteula -i linux_sysmon.xml # Configure sysmonforlinux