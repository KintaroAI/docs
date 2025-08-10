---
title: "Comprehensive Guide: Deploying Docker with Portainer UI, Ollama, and Open WebUI in a Proxmox LXC Container"
linkTitle: "Docker in Proxmox LXC Container"
date: 2025-08-09

authors: 
  - llm-kun
  - baraban
---

### Comprehensive Guide: Deploying Docker with Portainer UI, Ollama, and Open WebUI in a Proxmox LXC Container

This guide provides a step-by-step process to install Docker inside a privileged LXC container on Proxmox (with nesting enabled and GPU bound for shared access), deploy Portainer as a web-based Docker management UI, and then set up Ollama (for running LLMs) and Open WebUI (a ChatGPT-like interface for Ollama models). This enables easy management of multiple Docker containers via a UI, with GPU acceleration for AI workloads. The setup assumes your LXC container (e.g., ID 101) is already created and GPU-bound (as per previous instructions).

**Prerequisites:**
- Privileged LXC container on Proxmox with nesting enabled (`--features nesting=1`), sufficient resources (e.g., 128 cores, 128GB RAM), and GPU devices bound (e.g., via `/etc/pve/lxc/101.conf` with NVIDIA mounts and `lxc.cap.drop:` cleared for capability support). See [Proxmox with GPU support setup](/news/2025-08-09-proxmox-gpu-setup/) for more details.
- Internet access in the container.
- Enter the container: `pct enter 101` (on Proxmox host)—all steps below are executed inside the LXC unless noted.

#### Section 1: Install Docker in the LXC Container
Docker will run nested inside the LXC, allowing container isolation while sharing the host GPU.

1. **Uninstall Old Docker Packages (If Present):**
   ```
   apt remove docker docker-engine docker.io containerd runc -y
   ```

2. **Install Prerequisites:**
   ```
   apt update
   apt install ca-certificates curl gnupg lsb-release -y
   ```

3. **Add Docker Repository:**
   ```
   mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
   apt update
   ```

4. **Install Docker:**
   ```
   apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
   ```

5. **Start and Enable Docker:**
   ```
   systemctl start docker
   systemctl enable docker
   ```

6. **Verify Docker:**
   ```
   docker --version
   docker run hello-world  # Pulls and runs a test container
   ```

#### Section 2: Install NVIDIA Container Toolkit for GPU Support
This enables Docker containers (like Ollama) to use the bound RTX 4090 GPU.

1. **Add Toolkit Repository:**
   ```
   curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
       sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
       tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   apt update
   ```

2. **Install Toolkit:**
   ```
   apt install nvidia-container-toolkit -y
   ```

3. **Configure Docker Runtime:**
   ```
   mkdir -p /etc/docker
   echo '{
       "runtimes": {
           "nvidia": {
               "path": "/usr/bin/nvidia-container-runtime",
               "runtimeArgs": []
           }
       },
       "default-runtime": "nvidia"
   }' > /etc/docker/daemon.json
   ```

4. **Restart Docker:**
   ```
   systemctl restart docker
   ```

5. **Verify GPU Support:**
   ```
   docker info | grep -i runtime  # Should show "nvidia"
   nvidia-smi  # Confirms GPU detection
   ```

#### Section 3: Deploy Portainer (Docker Management UI)
Portainer provides a web UI for managing Docker containers, volumes, networks, and GPU allocation.

1. **Create Persistent Volume:**
   ```
   docker volume create portainer_data
   ```

2. **Run Portainer Container:**
   ```
   docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
   ```

3. **Access Portainer UI:**
   - Find container IP: `ip addr show eth0`
   - Browser: http://<container-ip>:9000 (or https://<container-ip>:9443 for secure).
   - Set admin username/password on first login.
   - Connect to the "Local" Docker environment.

4. **Enable GPU in Portainer:**
   - In UI: Home > Local environment > Setup (or Settings > Environments > Edit Local > Host Setup).
   - Toggle "Show GPU in the UI" ON.
   - Click "Add GPU" > Select your RTX 4090 > Save.

#### Section 4: Deploy Ollama Container via Portainer UI
Ollama runs LLMs with GPU support.

1. In Portainer UI: Containers > Add container.
2. **Name:** ollama
3. **Image:** ollama/ollama:latest
4. **Ports:** Publish host 11434 to container 11434 (for API).
5. **Volumes:** Add: Host `/root/.ollama` to container `/root/.ollama` (persistent models/data).
6. **Runtime & Resources:** Enable GPU > Select RTX 4090 (all capabilities).
7. **Restart policy:** Always.
8. Deploy.

9. **Verify Ollama:**
   - In Portainer: Check container logs for "Listening on 0.0.0.0:11434".
   - CLI test: `docker exec -it ollama ollama run llama3` (pulls model, chat interactively).
   - Monitor GPU: `nvidia-smi` (shows usage during inference).

#### Section 5: Deploy Open WebUI Container via Portainer UI
Open WebUI provides a web-based chat interface for Ollama models (pull, manage, and converse).

1. In Portainer UI: Containers > Add container.
2. **Name:** open-webui
3. **Image:** ghcr.io/open-webui/open-webui:main
4. **Ports:** Publish host 3000 to container 8080 (access UI at http://<container-ip>:3000).
5. **Volumes:** Add: Host `/root/open-webui-data` to container `/app/backend/data` (persistent data).
6. **Env Variables:**
   - `OLLAMA_BASE_URL`: `http://host.docker.internal:11434` (or Ollama container IP/name).
   - Optional: `WEBUI_SECRET_KEY`: A random secret (e.g., `your-secret-key` for auth).
7. **Runtime & Resources:** Enable GPU > Select RTX 4090.
8. **Restart policy:** Always.
9. Deploy.

10. **Access and Use Open WebUI:**
    - Browser: http://<container-ip>:3000
    - Sign up (first user is admin).
    - Settings > Connections > Ollama: Confirm connection (auto-detects or enter URL).
    - Pull models: Search/pull (e.g., "llama3")—uses GPU.
    - Chat: Create new chat, select model, prompt (e.g., "This is great!")—expect positive sentiment response.

#### Verification and Management
- **Test End-to-End:** In Open WebUI, pull a model, chat, and monitor GPU with `nvidia-smi`.
- **Manage in Portainer:** Use UI for logs, stop/start, volumes, or deploy more containers (e.g., databases).
- **Troubleshooting:** If GPU not detected, verify toolkit (`nvidia-container-cli info`). For errors, check Docker logs (`docker logs <container-name>`).
- **Scaling:** Add more containers via Portainer; GPU is shared concurrently.

This setup is complete as of August 2025—lightweight, GPU-accelerated, and UI-driven for easy model pulling/chatting. If you encounter issues or want additions (e.g., multi-user auth), share details!