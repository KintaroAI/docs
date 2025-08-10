---
title: "Full Setup Guide: NVIDIA RTX 4090 with CUDA on Proxmox Host and Shared in LXC Container"
linkTitle: "NVIDIA RTX 4090 with CUDA on Proxmox"
date: 2025-08-09

authors: 
  - llm-kun
  - baraban
---

### Full Setup Guide: NVIDIA RTX 4090 with CUDA on Proxmox Host and Shared in LXC Container

This guide compiles the complete, step-by-step process from our conversation to set up NVIDIA drivers with CUDA support on a Proxmox VE 8.4 host (Debian 12-based) for an RTX 4090 GPU, verify it, and configure a privileged LXC container for shared GPU access (concurrent CUDA compute across containers). The setup enables running AI applications (e.g., PyTorch, Transformers) directly on the host or in isolated containers.

**Prerequisites:**
- Proxmox VE 8.4 installed with RTX 4090 attached (verified via `lspci | grep -i nvidia`).
- Root access on the host.
- Internet access for downloads/packages.
- Host kernel: 6.8.x-pve (as in your setup; if different, adjust headers).
- Backup your system before proceeding (e.g., `pve-manager` config).

#### Part 1: Install NVIDIA Drivers and CUDA on the Proxmox Host
1. **Update System and Install Prerequisites:**
   ```
   apt update && apt full-upgrade -y
   apt install pve-headers-$(uname -r) build-essential gcc dirmngr ca-certificates apt-transport-https dkms curl software-properties-common -y
   add-apt-repository contrib non-free-firmware
   apt update
   ```

2. **Blacklist Nouveau Driver (Open-Source Alternative):**
   ```
   echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist-nouveau.conf
   update-initramfs -u -k all
   reboot
   ```
   After reboot, verify: `lsmod | grep nouveau` (should return nothing).

3. **Install NVIDIA Drivers with CUDA Support Using .run Installer:**
   ```
   wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.65.06/NVIDIA-Linux-x86_64-580.65.06.run
   chmod +x NVIDIA-Linux-x86_64-580.65.06.run
   ./NVIDIA-Linux-x86_64-580.65.06.run --dkms
   ```
   - During prompts: Choose MIT/GPL (open modules) for better compatibility.
   - Accept license, yes to DKMS, no to 32-bit libs if asked.
   - Reboot after installation: `reboot`.

4. **Install CUDA Toolkit (Full Userland Support):**
   ```
   wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
   dpkg -i cuda-keyring_1.1-1_all.deb
   apt update
   apt install cuda-toolkit=13.0.0-1 -y
   ```
   - Set environment variables (persist in shell):
     ```
     echo 'export PATH=/usr/local/cuda-13.0/bin:$PATH' >> ~/.bashrc
     echo 'export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
     source ~/.bashrc
     ```

5. **Verify Installation on Host:**
   ```
   nvidia-smi  # Should show RTX 4090, driver 580.65.06, CUDA 13.0
   nvcc --version  # Should show CUDA 13.0 details
   ```

6. **Install Python and Test AI (Optional on Host; Skip if Using Container Only):**
   ```
   apt install python3-venv python3-pip -y
   python3 -m venv ai_env
   source ai_env/bin/activate
   pip install --upgrade pip
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
   pip install transformers
   python -c "import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"
   python -c "from transformers import pipeline; classifier = pipeline('sentiment-analysis'); print(classifier('This is great!'))"
   deactivate
   ```
   - Expected: "True" + "NVIDIA GeForce RTX 4090", and positive sentiment output.

#### Part 2: Create and Configure LXC Container with Shared GPU Access
1. **Download Debian 12 Template (If Not Already Done):**
   - In Proxmox Web UI: Select storage (e.g., `local`) > Content > Templates > Download Debian 12 Standard (e.g., debian-12-standard_12.7-1_amd64.tar.zst).

2. **Create Privileged LXC Container:**
   ```
   pct create 101 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst --hostname ai-container --rootfs local-zfs:50 --cores 128 --memory 131072 --net0 name=eth0,bridge=vmbr0,ip=dhcp --unprivileged 0 --features nesting=1
   pct start 101
   ```
   - Adjust ID (101), storage (`local-zfs`), size (50GB), cores/RAM as needed.

3. **Bind GPU Devices for Shared Access:**
   - Edit `/etc/pve/lxc/101.conf` (e.g., via `nano`):
     Add at the end:
     ```
     lxc.cgroup2.devices.allow: c 195:* rwm
     lxc.cgroup2.devices.allow: c 509:* rwm
     lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file
     lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file
     lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file
     lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file
     lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file
     lxc.mount.entry: /dev/nvidia-caps dev/nvidia-caps none bind,create=dir,optional 0 0
     ```
   - Restart: `pct stop 101; pct start 101`

4. **Install NVIDIA Userland Tools and CUDA Toolkit in Container:**
   - Enter container: `pct enter 101`
   - Update: `apt update && apt full-upgrade -y`
   - Install prerequisites: `apt install software-properties-common gnupg curl build-essential -y`
   - Download and install userland only (no kernel module):
     ```
     wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.65.06/NVIDIA-Linux-x86_64-580.65.06.run
     chmod +x NVIDIA-Linux-x86_64-580.65.06.run
     ./NVIDIA-Linux-x86_64-580.65.06.run --no-kernel-module
     ```
   - Add CUDA repo and toolkit:
     ```
     wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
     dpkg -i cuda-keyring_1.1-1_all.deb
     apt update
     apt install cuda-toolkit -y
     ```
   - Set environment variables:
     ```
     echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
     echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
     source ~/.bashrc
     ```
   - Verify: `nvidia-smi` (shows GPU) and `nvcc --version` (CUDA 13.0).

5. **Install Python and Test AI in Container:**
   - Still inside: `apt install python3-venv python3-pip -y`
   - Create venv:
     ```
     python3 -m venv ai_env
     source ai_env/bin/activate
     pip install --upgrade pip
     pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
     pip install transformers
     ```
   - Test:
     ```
     python -c "import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"
     python -c "from transformers import pipeline; classifier = pipeline('sentiment-analysis'); print(classifier('This is great!'))"
     deactivate
     ```

#### Additional Notes
- **Shared GPU:** Repeat for new containers (e.g., ID 102) to share the GPU concurrently (bind same devices).
- **Troubleshooting:** If nvidia-smi fails in container, check bindings (`ls /dev/nvidia*`) and host modules (`lsmod | grep nvidia`).
- **Updates:** After kernel updates, rebuild host DKMS modules: `dkms autoinstall`.
- **Removal:** On host: `./NVIDIA-Linux-x86_64-580.65.06.run --uninstall`; apt purge cuda-toolkit.

This setup is complete and tested as of August 2025.