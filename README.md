
# MadMax's `Homelab`

**Everything needed for HomeLab**

## Docker-Compose
### Général

À des fins de simplicité et constance, tout les dossier de `config` sont placé dans le répertoire `/opt/nomduconteneur/config`.
Il est fortement recommandé de débuté en utilisant un gestionnaire tel que `Portainer` afin de stocker vos fichier de configuration. Les données n'étant pas persistante par défaut, vous devriez conserver une copie en lieux sur.

```yaml
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

| Port| Notes|
| ------------- |:-------------:|
| `8000`     | Tunnel TCP (Edge Compute) |
| `9000`     | Port pour le WebUI      |
