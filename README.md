
# MadMax's `Homelab`

**Index**
1. [Général](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#g%C3%A9n%C3%A9ral)
2. [Portainer](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#portainer)
2. [CloudFlare]()

# Docker
## Général

À des fins de simplicité et de constance, tous les dossiers de `config` sont placé dans le répertoire `/opt/nomduconteneur/config`.

Il est fortement recommandé de débuter en utilisant un gestionnaire tel que `Portainer` afin de stocker vos fichiers de configuration. Les données n'étant pas persistantes par défaut, vous devriez conserver une copie en lieux sûrs.

Les conteneurs peuvent être déployés de 2 facons:

* [Ligne de commande]()
* [Docker-Compose]()

Nous allons utilisé le conteneurs qBittorent à titre d'exemple.

### Ligne de commande
```yaml
sudo docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/Montreal \
  -e WEBUI_PORT=8080 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /opt/qbittorrent/config:/config \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  lscr.io/linuxserver/qbittorrent:latest
```

### Docker-Compose
```yaml
version: "2.1"
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Montreal
      - WEBUI_PORT=8080
    volumes:
      - /path/to/appdata/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```
Comme vous pouvez le constater, les deux versions sont pratiquement identiques.

## Portainer

Déployer portainer via `SSH` avec la commande suivante:

```yaml
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

| Port| Notes|
| ------------- |:-------------:|
| `8000` | Tunnel TCP (Edge Compute) |
| `9000` | Port pour le WebUI      |



Une fois déployé, rendez-vous à `http://iphost:9000`. Il vous sera ensuite demandé de créer votre compte administrateur.

Une fois votre compte créer, vous obtiendrez la page suivante:

![alt text](https://wickedgroup.ca/wiki-images/portainer-get-started.png "Portainer - Get Started")

Cliquez ensuite sur "Get Started". Votre environnement local sera automatiquement ajouté.

Rendez-vous à `Stacks`, c'est à cet endroit que vous pourrez déployer vos `docker-compose.yml`.

![alt text](https://wickedgroup.ca/wiki-images/portainer-home-menu.png "Portainer - Get Started")

Cette méthode vous permet d'éviter de faire tout en `CLI`. Vous pourrez y revenir facilement et mettre vos fichiers à jour sans difficulté.

## CloudFlare DDNS
Il nous est possible d'utiliser gratuitement le service de CloudFlare afin d'obteni