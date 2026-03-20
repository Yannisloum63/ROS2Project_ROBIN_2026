# Guide de Test - Robot Aspirateur ROS2

## Prérequis Installation

```bash
# ROS2 Humble (supposé installé)
source /opt/ros/humble/setup.bash

# Chemin vers ce dépôt
export PROJECT_ROOT=$HOME/ros2_ws/src/ROS2Project_ROBIN_2026

# Installer les paquets TurtleBot3, Nav2, SLAM
sudo apt update
sudo apt install -y \
    ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3 \
    ros-humble-turtlebot3-simulations \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-slam-toolbox \
    ros-humble-tf2-tools \
    ros-humble-tf2-geometry-msgs \
    python3-tf-transformations

# Exporter le model utilisé
export TURTLEBOT3_MODEL=burger
```

## Test 1 : Évitement d'obstacles réactif

```bash
# Terminal 1: Lancer Gazebo avec TurtleBot3
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo empty_world.launch.py

# Terminal 2: Lancer RViz pour visualiser
rviz2

# Terminal 3: Lancer le nœud reactive_avoidance
source ~/ros2_ws/install/setup.bash
ros2 run reactive_avoidance avoidance_node

# Terminal 4: Vérifier les topics
ros2 topic echo /cmd_vel
```

**Attendu** : 
- Le robot tourne sur lui-même si obstacles proches
- Le robot avance quand le chemin est dégagé
- Pas d'oscillations critiques (paramètres à ajuster si nécessaire)

**Ajustement des paramètres** :
```bash
ros2 run reactive_avoidance avoidance_node \
    --ros-args -p min_distance:=0.4 -p forward_speed:=0.15 -p rotate_speed:=0.3
```

### Validation Express Chapitres 7-8 (a faire en premier)

Objectif : valider concretement la boucle perception -> decision -> action.

```bash
# T1: simulation minimale
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo empty_world.launch.py

# T2: noeud d'evitement
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 launch reactive_avoidance avoidance.launch.py

# T3: verification topics
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 topic hz /scan
ros2 topic hz /cmd_vel
ros2 topic echo /cmd_vel
```

Checklist de validation (chapitre valide si tout est OK):
- [ ] `/scan` publie de maniere reguliere (lidar actif)
- [ ] `/cmd_vel` publie en continu quand le noeud tourne
- [ ] En zone degagee: `linear.x > 0` et `angular.z ~ 0`
- [ ] Proche obstacle: `linear.x = 0` et `angular.z != 0`
- [ ] Pas d'oscillation critique (robot ne reste pas bloque en tremblement)

Preuves minimales a capturer pour ton rapport:
- Capture terminal `ros2 topic echo /cmd_vel` (phase avance + phase rotation)
- Courte video de 20-30 s montrant l'evitement
- Valeurs de parametres utilises (`min_distance`, `forward_speed`, `rotate_speed`)

---

## Test 2 : Cartographie (SLAM)

```bash
# Terminal 1: Gazebo
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# Terminal 2: SLAM Toolbox (online async)
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=$PROJECT_ROOT/config/slam_params.yaml use_sim_time:=true

# Terminal 3: Teleopération (pour bouger le robot manuellement ou programmer mouveurs)
ros2 run turtlebot3_teleop teleop_keyboard

# Terminal 4: RViz pour voir la carte en construction
rviz2 -d $(ros2 pkg prefix slam_toolbox)/share/slam_toolbox/config/slam.rviz

# Après exploration suffisante: sauvegarder la cate
ros2 run nav2_map_server map_saver_cli -f ~/ros2_ws/maps/my_map
```

**Résultats attendus** :
- Fichiers `my_map.pgm` et `my_map.yaml` dans `~/ros2_ws/maps/`
- Carte visible dans RViz

---

## Test 3 : Navigation avec Nav2

```bash
# Terminal 1: Gazebo
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# Terminal 2: AMCL Localization + Nav2
ros2 launch nav2_bringup bringup_launch.py \
    use_sim_time:=true \
    map:=$HOME/ros2_ws/maps/my_map.yaml \
    params_file:=$PROJECT_ROOT/config/nav2_params.yaml

# Terminal 3: RViz avec Nav2
rviz2 -d $(ros2 pkg prefix nav2_bringup)/share/nav2_bringup/launch/nav2_default_view.rviz

# Dans RViz: 
# 1. Set Initial Pose (bouton 2D Pose Estimate)
# 2. Envoyer goals (Nav2 Goal button ou code)
```

**Résultats attendus** :
- Robot localisé dans la carte
- Robot navigue vers les goals sans collision
- Trajectoire lisse et optimisée

---

## Test 4 : Couverture Complète (aspirateur)

```bash
# Terminal 1: Gazebo + carte pré-existante
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# Terminal 2: Nav2 sur carte existante
ros2 launch nav2_bringup bringup_launch.py \
    use_sim_time:=true \
    map:=$HOME/ros2_ws/maps/my_map.yaml \
    params_file:=$PROJECT_ROOT/config/nav2_params.yaml

# Terminal 3: Coverage Planner
source ~/ros2_ws/install/setup.bash
ros2 run coverage_planner coverage_planner_node \
    --ros-args -p cell_size:=0.5 -p coverage_threshold:=50
```

**Comportement actuel** :
- Le nœud génère des goals de couverture depuis `/map`
- Le nœud publie les goals séquentiellement sur `/goal_pose`
- Le nœud suit la progression via `/amcl_pose` et passe au goal suivant quand la tolérance est atteinte

---

## Validation chapitre par chapitre (recommandé)

### Chapitre 7-8 : évitement réactif

Objectif : valider perception lidar -> commande `/cmd_vel` sans Nav2.

```bash
# T1
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo empty_world.launch.py

# T2
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 launch reactive_avoidance avoidance.launch.py

# T3
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 topic echo /cmd_vel
```

Critère de validation : le robot avance en zone libre et pivote devant obstacle.

### Chapitre 9 : cartographie SLAM

Objectif : générer une carte exploitable (`.yaml` + `.pgm`).

```bash
# T1
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
export PROJECT_ROOT=$HOME/ros2_ws/src/ROS2Project_ROBIN_2026
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# T2
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=$PROJECT_ROOT/config/slam_params.yaml use_sim_time:=true

# T3
ros2 run turtlebot3_teleop teleop_keyboard

# T4 (fin de mapping)
ros2 run nav2_map_server map_saver_cli -f $HOME/ros2_ws/maps/my_map
```

Critère de validation : fichiers `my_map.yaml` et `my_map.pgm` présents.

### Chapitre 10 : navigation Nav2

Objectif : AMCL + Nav2 atteignent des goals sur carte figée.

```bash
# T1
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
export PROJECT_ROOT=$HOME/ros2_ws/src/ROS2Project_ROBIN_2026
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# T2
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 launch nav2_bringup bringup_launch.py \
    use_sim_time:=true \
    map:=$HOME/ros2_ws/maps/my_map.yaml \
    params_file:=$PROJECT_ROOT/config/nav2_params.yaml

# T3
rviz2
```

Dans RViz2 : `2D Pose Estimate` avant tout goal.

Critère de validation : la TF `map -> odom` existe et le robot atteint au moins 3 goals.

---

## Test Complet en Séquence (recommandé)

```bash
# Phase A: Vérifier évitement uniquement
# Terminal 1
source /opt/ros/humble/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo empty_world.launch.py

# Terminal 2
source ~/ros2_ws/install/setup.bash
ros2 run reactive_avoidance avoidance_node
# → Robot devrait tourner/avancer spontanément

---

# Phase B: Cartographier
# Terminal 1
source /opt/ros/humble/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# Terminal 2
source ~/ros2_ws/install/setup.bash
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=$PROJECT_ROOT/config/slam_params.yaml use_sim_time:=true

# Terminal 3: RViz
rviz2

# Terminal 4: Contrôle manuel du robot (ou avoidance)
ros2 run turtlebot3_teleop teleop_keyboard

# Une fois exploration finie:
ros2 run nav2_map_server map_saver_cli -f ~/ros2_ws/maps/test_map

---

# Phase C: Naviguer sur la carte
# Terminal 1
source /opt/ros/humble/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

# Terminal 2
source ~/ros2_ws/install/setup.bash
ros2 launch nav2_bringup bringup_launch.py use_sim_time:=true map:=~/ros2_ws/maps/test_map.yaml params_file:=$PROJECT_ROOT/config/nav2_params.yaml

# Terminal 3: RViz + set initial pose, puis cliquer des goals
rviz2

---

# Phase D: Couvrir l'environnement
# Combiner: reactive_avoidance + coverage_planner + Nav2
```

## Métriques à Collecter

```bash
# Distance parcourue
ros2 bag record /odom /cmd_vel
# Puis: analyser en post-traitement

# Nombre de collisions (optionnel: plugin Gazebo)
# Topics spécialisés à définir

# Couverture (%)
# À calculer via coverage_planner ou script post-traitement
```

## Troubleshooting

**Le robot ne bouge pas**:
- Vérifier `/cmd_vel` reçoit des messages: `ros2 topic echo /cmd_vel`
- Vérifier `use_sim_time` correctement set dans Gazebo

**RViz black screen**:
- Vérifier `/map` topic disponible: `ros2 topic list | grep map`
- Set Fixed Frame à `map` ou `odom`

**Pas de scan LIDAR**:
- Vérifier `/scan` disponible: `ros2 topic echo /scan`
- Vérifier version Gazebo compatible

