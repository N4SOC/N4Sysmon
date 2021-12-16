if grep -i ubuntu /etc/os-release>/dev/null; then
    echo "Running Ubuntu install commands"
    wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    apt update
    apt install sysinternalsebpf # Install EBPF prerequisitite
    apt install sysmonforlinux # Install sysmonforlinux
elif grep -i debian /etc/os-release>/dev/null; then
    echo "Running Debian install commands"
    wget https://packages.microsoft.com/config/debian/$(lsb_release -rs)/packages-microsoft-prod.deb # Download microsoft repository installer
    dpkg -i packages-microsoft-prod.deb
    apt update
    apt install sysinternalsebpf # Install EBPF prerequisitite
    apt install sysmonforlinux # Install sysmonforlinux
elif grep -i CentOS /etc/os-release>/dev/null; then
    echo "Running CentOS install commands"
    rpm -Uvh https://packages.microsoft.com/config/centos/$(lsb_release -rs)/packages-microsoft-prod.rpm
    dnf install sysinternalsebpf
    dnf install sysmonforlinux
elif grep -i "Red Hat" /etc/os-release>/dev/null; then
    echo "Running Redhat install commands"
    rpm -Uvh https://packages.microsoft.com/config/rhel/$(lsb_release -rs)/packages-microsoft-prod.rpm
    dnf install sysinternalsebpf
    dnf install sysmonforlinux
elif grep -i Arch /etc/os-release>/dev/null; then
    echo "Arch Linux Not supported"
    exit 1
else
    echo "Other OS Not supported"
    exit 1
fi

wget https://raw.githubusercontent.com/N4SOC/N4Sysmon/main/linux_sysmon.xml # Download node4 sysmon config

sysmon -accepteula -i linux_sysmon.xml # Configure sysmonforlinux