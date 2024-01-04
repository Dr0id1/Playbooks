
# MadMax's `Homelab`

**Everything you need for your HomeLab**

## Docker-Compose
### Général

À des fins de simplicité et constance, tous les dossiers de `config` sont placé dans le répertoire `/opt/nomduconteneur/config`.

Il est fortement recommandé de débuter en utilisant un gestionnaire tel que `Portainer` afin de stocker vos fichiers de configuration. Les données n'étant pas persistantes par défaut, vous devriez conserver une copie en lieux sûrs.

### Portainer

Déployer portainer via `SSH` avec la commande suivante:

```yaml
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

| Port| Notes|
| ------------- |:-------------:|
| `8000` | Tunnel TCP (Edge Compute) |
| `9000` | Port pour le WebUI      |



Une fois déployé, rendez-vous à `http://iphost:9000`. Il vous sera ensuite demandé de créer votre compte administrateur.

Une fois votre compte créer, vous obtiendré la page suivante:
