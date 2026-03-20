# ROS2Project_ROBIN_2026

Projet ROS2 inspiré des chapitres 7 a 10 de Programming Robots with ROS, adapte a un robot aspirateur autonome en simulation.

## Objectifs du projet

- Evitement d'obstacles autonome (chap. 7-8)
- Cartographie SLAM d'un environnement inconnu (chap. 9)
- Navigation sur carte avec Nav2 (chap. 10)
- Couverture efficace type aspirateur
- Rapport avec validation quantitative

## Prerequis cibles

- Ubuntu + ROS2 Humble (ou distribution equivalente avec paquets compatibles)
- Gazebo (Classic ou Fortress)
- TurtleBot3, Nav2, slam_toolbox

## Demarrage rapide

```bash
# 1) Source ROS2
source /opt/ros/humble/setup.bash

# 2) Si pas encore fait: le repo doit être cloné dans ~/ros2_ws/src/
cd ~/ros2_ws/src
git clone https://github.com/Yannisloum63/ROS2Project_ROBIN_2026.git
cd ~/ros2_ws

# 3) Build les paquets ROS2
colcon build

# 4) Source l'installation
source install/setup.bash

# 5) Verification CLI
ros2 pkg list | grep -E "reactive_avoidance|coverage_planner"
ros2 topic list
```

## Paquets utiles a installer

```bash
sudo apt update
sudo apt install -y \
	ros-humble-turtlebot3* \
	ros-humble-navigation2 \
	ros-humble-nav2-bringup \
	ros-humble-slam-toolbox \
	ros-humble-tf2-tools \
	ros-humble-tf-transformations \
	python3-numpy
```

## Workflow projet recommande

1. Phase A: verifier simulation + topics (/scan, /odom, /tf, /cmd_vel).
2. Phase B: coder reactive_avoidance (lecture LaserScan -> publication Twist).
3. Phase C: lancer slam_toolbox + enregistrer ros2 bag + sauvegarder map.
4. Phase D: lancer Nav2 sur carte figee + valider objectifs sans collision.
5. Phase E: implementer coverage_planner (balayage en grille) + metriques.

## Metriques minimales a reporter

- Couverture (%) = (cellules_visitees / cellules_libres) * 100
- Temps de mission
- Nombre de collisions
- Distance parcourue
- Taux de reexploration

## Structure conseillee (dans ce depot)

```text
ROS2Project_ROBIN_2026/
	docs/
		protocole_tests.md
		rapport_template.md
	ros2_pkgs/
		reactive_avoidance/
		coverage_planner/
	config/
		nav2_params.yaml
		slam_params.yaml
	maps/
	bags/
```

## Checkpoint de fin de semaine 1

- Le robot evite les obstacles sans oscillation critique.
- Une carte est sauvegardee (yaml + pgm).
- Nav2 atteint au moins 3 objectifs dans la carte sans collision.

## Notes

- En simulation, utiliser use_sim_time:=True.
- Si la VM rame, eviter Gazebo + RViz + rqt en simultane.