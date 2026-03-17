# Protocole de tests - ROS2 Robot Aspirateur

## 1. Objectif
Evaluer l'efficacite du controle autonome pour la navigation et la couverture d'un environnement inconnu.

## 2. Config experimentale
- Robot: TurtleBot3 Burger (simulation)
- Capteurs: lidar 2D + odometrie
- Stack: slam_toolbox + Nav2 + noeud coverage_planner
- Simulation: Gazebo
- Horloge: use_sim_time:=True

## 3. Scenarios
- Carte A (simple): peu d'obstacles
- Carte B (moyenne): couloirs + obstacles disperses
- Carte C (encombree): passages etroits + obstacles denses

Pour chaque carte:
- 3 essais avec orientation initiale differente
- Timeout mission: 20 min (ou seuil defini)

## 4. Methodes comparees
1. Baseline reactive_avoidance seule
2. Baseline Nav2 avec objectifs aleatoires
3. Methode proposee coverage_planner

## 5. Metriques
- Couverture (%): (cellules_visitees / cellules_libres) * 100
- Temps de mission (s)
- Collisions (count)
- Distance parcourue (m)
- Reexploration (%): cellules revisitees inutiles / cellules_visitees

## 6. Instrumentation
- ros2 bag record /scan /tf /odom /cmd_vel /map
- Logs applicatifs:
  - debut/fin mission
  - goals envoyes/atteints
  - collisions detectees
  - resume metriques

## 7. Criteres d'acceptation minimaux
- Collisions: 0 sur la majorite des essais
- Couverture: >= 90% sur carte A et B
- Stabilite: pas d'oscillation persistante au voisinage des obstacles

## 8. Format de resultat
Tableau par scenario:
- essai_id
- methode
- couverture_pct
- temps_s
- collisions
- distance_m
- reexploration_pct

Graphiques recommandes:
- couverture_pct vs temps_s
- boxplot des performances par methode
