# Projet ROS2 (à partir de *Programming Robots with ROS*)

## 1) Ce que demandent les consignes du prof

- Réaliser les chapitres **7, 8, 9, 10** du livre.
- Proposer un environnement ROS simulant un robot aspirateur dans un environnement inconnu.
- Le robot doit:
  - naviguer de façon autonome (éviter les obstacles)
  - couvrir efficacement l’environnement (aspiration complète)
  - construire une carte
- Produire un **rapport de méthodologie + validation de l’efficacité du contrôle**.

Contrainte perso: Windows + VirtualBox + Ubuntu + **ROS2** (et non ROS1).

---

## 2) Synthèse utile des chapitres 7-10 du livre

## Chapitre 7 — Wander-bot
Objectif: boucler perception (LaserScan) -> décision -> action (Twist) pour éviter les obstacles.

À retenir:
- Lire la distance frontale sur le lidar.
- Si obstacle proche: tourner.
- Sinon: avancer.
- Publier sur `/cmd_vel`.

Livrable attendu côté projet:
- Un nœud de base d’évitement d’obstacles simple et robuste.

## Chapitre 8 — Teleop-bot
Objectif: architecture propre de commande (entrée -> génération de vitesse), puis visualisation.

À retenir:
- Séparer la capture de commande et le générateur de mouvement.
- Utiliser des paramètres (vitesses max, gains).
- Ajouter des rampes de vitesse (changement progressif, pas brutal).
- Utiliser RViz pour observer les données et vérifier les topics.

Livrable attendu côté projet:
- Une architecture modulaire de contrôle, même en autonome.

## Chapitre 9 — Building Maps
Objectif: cartographier en SLAM avec logs reproductibles.

À retenir:
- Enregistrer des données capteurs (`rosbag` en ROS1, `ros2 bag` en ROS2).
- Exécuter un SLAM (dans le livre: `gmapping`).
- Sauvegarder carte (`.yaml + .pgm`).

Livrable attendu côté projet:
- Une procédure claire: acquisition -> SLAM -> sauvegarde de carte.

## Chapitre 10 — Navigation
Objectif: localisation + planification + suivi de trajectoire.

À retenir:
- Localiser le robot dans la carte (livre: `amcl`).
- Utiliser la stack de navigation (livre: `move_base`, en ROS2: `Nav2`).
- Envoyer des objectifs depuis RViz ou en code.

Livrable attendu côté projet:
- Démonstration d’objectifs atteints sans collision + comportement stable.

---

## 3) Traduction ROS1 (livre) -> ROS2 (ton contexte)

- `rospy` -> `rclpy`
- `catkin` -> `colcon` (+ `ament`)
- `roslaunch` -> `ros2 launch`
- `rostopic` -> `ros2 topic`
- `rosbag` -> `ros2 bag`
- `gmapping` (ROS1) -> **`slam_toolbox`** (recommandé ROS2)
- `move_base` (ROS1) -> **Nav2** (`bt_navigator`, `planner_server`, `controller_server`)
- `amcl` existe aussi en ROS2 (paquet Nav2)

---

## 4) Environnement ROS2 recommandé pour ton projet aspirateur

## Choix minimal et crédible (MVP académique)
- ROS2: **Humble** (Ubuntu 22.04)
- Simulateur: Gazebo (Classic ou Fortress selon tes paquets installés)
- Robot: **TurtleBot3 Burger** (diff-drive + lidar)
- Navigation: **Nav2**
- Cartographie: **slam_toolbox**

Pourquoi ce choix:
- Stable, bien documenté, adapté à VirtualBox.
- Suffisant pour prouver autonomie + cartographie + couverture.

## Architecture logique
- Entrées: `/scan`, `/odom`, `/tf`
- SLAM: `slam_toolbox` -> `/map`
- Localisation (phase navigation sur carte figée): `amcl`
- Navigation: Nav2 -> commandes `/cmd_vel`
- Couverture: nœud perso `coverage_planner` (stratégie de balayage)

---

## 5) Méthodologie proposée (ce que tu peux écrire dans le rapport)

## Phase A — Mise en place
1. Installer ROS2 + paquets TB3 + Nav2 + slam_toolbox.
2. Vérifier TF, `/scan`, `/odom`, `/cmd_vel`.
3. Lancer monde simulé avec obstacles.

## Phase B — Reprise chapitres 7-8 (commande)
1. Implémenter un nœud `reactive_avoidance` (inspiré Wander-bot).
2. Ajouter saturation + rampes sur vitesses.
3. Valider absence d’oscillation près des obstacles.

## Phase C — Reprise chapitre 9 (cartographie)
1. Mapper un environnement inconnu avec `slam_toolbox`.
2. Enregistrer un run avec `ros2 bag`.
3. Sauvegarder la carte finale.

## Phase D — Reprise chapitre 10 (navigation)
1. Basculer en mode carte figée + `amcl`.
2. Lancer Nav2 et envoyer des objectifs.
3. Vérifier atteinte des objectifs sans collision.

## Phase E — Couverture type aspirateur
1. Découper la carte libre en cellules (grille).
2. Générer une trajectoire de couverture (type boustrophédon simplifié / lawnmower).
3. Envoyer séquentiellement des goals Nav2.
4. Marquer cellules visitées pour éviter les redondances.

---

## 6) Critères de validation (très important pour la note)

Mesures minimales à fournir:
- **Taux de couverture**: surface visitée / surface libre.
- **Temps de mission**: durée pour atteindre x% de couverture.
- **Nombre de collisions**: idéalement 0.
- **Longueur de trajectoire**: distance totale parcourue.
- **Taux de réexploration**: % de zone revisitée inutilement.

Formules simples:
- Couverture (%) = `(cellules_visitées / cellules_libres) * 100`
- Efficacité trajet = `surface_couverte / distance_parcourue`

Scénario de test recommandé:
- 3 cartes de difficulté croissante (simple, moyenne, encombrée).
- 3 runs par carte (changer orientation initiale).
- Comparer: 
  - baseline réactive seule
  - baseline Nav2 goals aléatoires
  - méthode couverture proposée

---

## 7) Plan de rapport prêt à remplir

## 1. Introduction
- Contexte ROS1 du livre et migration ROS2.
- Objectifs du projet.

## 2. Environnement expérimental
- PC hôte Windows, VM Ubuntu, version ROS2, simulateur.
- Modèle robot et capteurs.

## 3. Méthodologie
- Contrôle réactif (chap. 7-8).
- SLAM (chap. 9).
- Navigation (chap. 10).
- Stratégie de couverture aspirateur.

## 4. Implémentation
- Nœuds ROS2 développés.
- Topiques, TF, paramètres essentiels.
- Diagramme fonctionnel.

## 5. Protocole de validation
- Cartes, métriques, nombre d’essais.

## 6. Résultats
- Tableaux des métriques.
- Graphiques couverture/temps.
- Analyse des échecs.

## 7. Discussion
- Limites (VM, perf temps réel, capteur simulé).
- Pistes d’amélioration (frontier exploration, tuning Nav2).

## 8. Conclusion
- Bilan objectifs atteints/non atteints.

---

## 8) Commandes ROS2 utiles (guide rapide)

> Adapter selon ton installation exacte.

```bash
# Source ROS2
source /opt/ros/humble/setup.bash

# Workspace
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build
source install/setup.bash

# Introspection
ros2 topic list
ros2 topic echo /scan
ros2 topic hz /scan
ros2 run tf2_tools view_frames

# Enregistrement
ros2 bag record /scan /tf /odom /cmd_vel

# Lancement SLAM (exemple générique)
ros2 launch slam_toolbox online_async_launch.py

# Sauvegarde carte (Nav2)
ros2 run nav2_map_server map_saver_cli -f ~/maps/map1

# Lancement Nav2 (exemple générique)
ros2 launch nav2_bringup navigation_launch.py use_sim_time:=True map:=~/maps/map1.yaml
```

---

## 9) Conseils spécifiques VirtualBox

- Activer 3D acceleration VM si stable.
- Allouer assez de RAM (>= 8 Go conseillé si possible) + 2-4 vCPU.
- Travailler en `use_sim_time:=True` en simulation.
- Éviter de lancer trop d’outils GUI en parallèle (Gazebo + RViz + rqt) si la VM rame.

---

## 10) Ce que tu peux dire à l’oral si on te challenge sur ROS vs ROS2

« Le livre est ROS1, mais j’ai transposé les principes des chapitres 7-10 dans ROS2: boucle perception-action, architecture modulaire de commande, SLAM, puis navigation autonome. Les concepts restent les mêmes; seule l’infrastructure logicielle change (rclpy/colcon/Nav2/slam_toolbox). »
