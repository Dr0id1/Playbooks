
![alt text](https://wickedgroup.ca/wiki-images/wickedbarn.png "Wicked Barn")

# MadMax's `Homelab`

![alt text](https://wickedgroup.ca/wiki-images/MadMax-Github_Banner.png "MadMax's Banner")

***Vous trouvez les étapes initiales afin de configurer un HomeLab similaire au mien. N'hésitez pas à adapter les configurations à vos besoins.Ceux-ci ne sont qu'à titres informatives***

**Index**
1. [Général](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#g%C3%A9n%C3%A9ral)
2. [Portainer](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#portainer)
2. [CloudFlare](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#cloudflare-ddns)

# Docker
## Général

À des fins de simplicité et de constance, tous les dossiers de `config` sont placé dans le répertoire `/opt/nomduconteneur/config`.

Il est fortement recommandé de débuter en utilisant un gestionnaire tel que `Portainer` afin de stocker vos fichiers de configuration. Les données n'étant pas persistantes par défaut, vous devriez conserver une copie en lieux sûrs.

Les conteneurs peuvent être déployés de 2 facons:

* [Ligne de commande](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#ligne-de-commande)
* [Docker-Compose](https://github.com/Dr0id1/Playbooks/tree/master?tab=readme-ov-file#docker-compose)

Nous allons utilisé le conteneur `qBittorent` à titre d'exemple.

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
      - /opt/qbittorrent/config:/config
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
Il nous est possible d'utiliser gratuitement le service de CloudFlare d'utiliser un domaine que vous possédez pour vos services externes.

Tout d'abord il vous faudra votre propre domaine et pointer les nameservers vers ceux de CloudFlare. Ces étapes ne seront pas couvertes ici.

Par la suite, il vous faudra générer un "Token" pour que le conteneur puisse s'authentifier à votre compte CloudFlare. De cette façon, le conteneur pourra mettre à jour régulièrement votre adresse IP publique.

Nous mettrons également en place les paramètres nécessaire pour la mise en place d'un "Reverse-Proxy".

### Configuration DNS
Rendez-vous sur votre panneau CloudFlare, sélectionner le domaine concerné et activé les fonctions suivantes dans les options de sécuritées:

![alt text](https://wickedgroup.ca/wiki-images/cloudflare-strict.png "CloudFlare - Strict")

![alt text](https://wickedgroup.ca/wiki-images/cloudflare-always-https.png "CloudFlare - Always HTTPS")

![alt text](https://wickedgroup.ca/wiki-images/cloudflare-https-rewrite.png "CloudFlare - HTTPS Rewrite")

Il faut ensuite créer une règle comme celle-ci:

![alt text](https://wickedgroup.ca/wiki-images/cloudflare-rules.png "CloudFlare - Rules")

### Token
Pour créer un jeton d'API CloudFlare pour votre zone DNS, suivez ces étapes sur https://dash.cloudflare.com/profile/api-tokens :

1. Cliquez sur "Créer un jeton".
2. Donnez un nom au jeton, par exemple, cloudflare-ddns.
3. Accordez au jeton les autorisations suivantes :
    * Zone - Paramètres de zone - Lecture
    * Zone - Zone - Lecture
    * Zone - DNS - Modifier
    * Définissez les ressources de la zone comme suit :
    * Inclure - Toutes les zones
4. Terminez l'assistant et copiez le jeton généré dans la variable API_KEY pour le conteneur.

### Conteneur

Nous allons utilisé le conteneur [oznu/cloudflare-ddns](https://github.com/oznu/docker-cloudflare-ddns) pour mettre à jour notre IP.

```shell
sudo docker run \
  -e API_KEY=TOKENCLOUDFLARE \
  -e ZONE=example.com \
  -e SUBDOMAIN=subdomain \ 
  oznu/cloudflare-ddns
```

| Variables| Notes|
| ------------- |:-------------:|
| `API_KEY` | Clé Généré |
| `ZONE` | La racine de votre domaine      |
| `SUBDOMAIN` | Sous-Domaine (Facultatif)     |

Si le déploiement du conteneur se déroule comme prévu, vous devriez obtenir les logs suivants (Accessible via Portainer):

```accesslog
[cont-init.d] executing container initialization scripts...
[cont-init.d] 30-cloudflare-setup: executing... 
DNS Zone: mondomaine.com (1725776d1644dc0b9e36fa046ebe7145)
DNS Record: sousdomaine.mondomaine.com (7422e19ddcd60b711aaaaf52d77357a7)
[cont-init.d] 30-cloudflare-setup: exited 0.
[cont-init.d] 50-ddns: executing... 
No DNS update required for sousdomaine.mondomaine.com (71.55.190.170).
[cont-init.d] 50-ddns: exited 0.
[cont-init.d] done.
[services.d] starting services
Starting crond...
crond: crond (busybox 1.31.1) started, log level 6
[services.d] done.
```