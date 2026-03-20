# Structure du Projet ROS2 - Robot Aspirateur

## Paquets créés

### 1. `reactive_avoidance`
- **Objectif** : Évitement réactif d'obstacles (Chapitres 7-8 du livre)
- **Nœud** : `avoidance_node`
- **Topics**:
  - Entrée: `/scan` (sensor_msgs/LaserScan)
  - Sortie: `/cmd_vel` (geometry_msgs/Twist)
- **Paramètres**:
  - `min_distance` (0.3m) : distance limite avant obstacle
  - `forward_speed` (0.2 m/s) : vitesse de déplacement
  - `rotate_speed` (0.5 rad/s) : vitesse de rotation

**Lancement** :
```bash
ros2 run reactive_avoidance avoidance_node
# ou
ros2 launch reactive_avoidance avoidance.launch.py
```

### 2. `coverage_planner`
- **Objectif** : Planification de couverture type aspirateur (Chapitres 9-10)
- **Nœud** : `coverage_planner_node`
- **Fonctionnalité** : Génère un pattern "lawnmower" sur la carte et envoie des goals à Nav2
- **Topics**:
  - Entrée: `/map` (nav_msgs/OccupancyGrid)
  - Sortie: `/goal_pose` (geometry_msgs/PoseStamped)
- **Paramètres**:
  - `cell_size` (0.5m) : taille des cellules de couverture
  - `coverage_threshold` (50) : seuil occupancy pour libre/occupé

**Lancement** :
```bash
ros2 run coverage_planner coverage_planner_node
# ou
ros2 launch coverage_planner coverage.launch.py
```

## Fichiers de Configuration

- `config/nav2_params.yaml` : Paramètres Nav2 (à adapter)
- `config/slam_params.yaml` : Paramètres slam_toolbox

## Dossiers de Données

- `maps/` : Cartes sauvegardées (.pgm + .yaml)
- `bags/` : Enregistrements ROS2 (ros2 bag record)

## Build et Utilisation

```bash
# 1. Build les paquets
cd ~/ros2_ws
colcon build

# 2. Source l'installation
source install/setup.bash

# 3. Vérifier que les paquets sont trouvés
ros2 pkg list | grep -E "reactive_avoidance|coverage_planner"

# 4. Lancer un nœud
ros2 run reactive_avoidance avoidance_node

# 5. Vérifier les topics
ros2 topic list
ros2 topic echo /cmd_vel
```

## Prochaines Étapes

1. **Tester reactive_avoidance** : Lancer Gazebo + TurtleBot3, vérifier évitement d'obstacles
2. **Intégrer slam_toolbox** : Cartographier l'environnement
3. **Lancer Nav2** : Navigation autonome avec objectifs
4. **Tester coverage_planner** : Générer et exécuter plan de couverture
5. **Collecter métriques** : efficacité, collisions, couverture %
