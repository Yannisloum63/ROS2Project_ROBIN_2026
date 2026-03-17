# Rapport Projet ROS2 - Robot Aspirateur Autonome

## 1. Introduction
- Contexte: adaptation des chapitres 7-10 du livre ROS1 vers ROS2
- Objectifs fonctionnels et criteres d'evaluation

## 2. Environnement experimental
- Materiel hote et VM
- Version Ubuntu / ROS2
- Simulateur et modele robot
- Paquets logiciels utilises

## 3. Methodologie
### 3.1 Controle reactif (chap. 7-8)
- Logique obstacle proche -> tourner, sinon avancer
- Parametres et rampes de vitesse

### 3.2 Cartographie (chap. 9)
- Acquisition des donnees
- Execution SLAM
- Sauvegarde carte

### 3.3 Navigation (chap. 10)
- Localisation AMCL
- Navigation Nav2
- Envoi d'objectifs

### 3.4 Couverture aspirateur
- Representation de la zone libre
- Strategie de balayage (lawnmower / boustrophedon simplifie)
- Politique anti-reexploration

## 4. Implementation
- Architecture des noeuds
- Topics, TF, parametres cle
- Diagramme fonctionnel

## 5. Protocole de validation
- Scenarios et repetitions
- Metriques
- Outils de mesure et journalisation

## 6. Resultats
- Tableaux de resultats
- Graphiques
- Analyse des cas d'echec

## 7. Discussion
- Forces et limites de la solution
- Impact de la virtualisation (latence, fps simulation)
- Pistes d'amelioration

## 8. Conclusion
- Bilan des objectifs atteints
- Perspectives

## Annexes
- Commandes ROS2 utilisees
- Parametres Nav2/SLAM
- Extraits de logs
