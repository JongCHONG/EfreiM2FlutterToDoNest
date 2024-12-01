### Flutter Firebase App : ToDoNest

Une application mobile développée en Flutter qui utilise Firebase comme Backend-as-a-Service (BaaS). Cette application implémente des fonctionnalités d'authentification, de gestion des utilisateurs, et de gestion sécurisée des données en utilisant Firebase Authentication et Firestore.

### Fonctionnalités

Fonctionnalités utilisateur :

- Page d'accueil :
Accès à un bouton pour se connecter ou s'inscrire.
- Connexion :
L'utilisateur peut entrer ses informations d'identification pour se connecter.
- Inscription :
Les nouveaux utilisateurs peuvent s'inscrire via un formulaire d'inscription.
- Redirection sécurisée :
Les utilisateurs non inscrits ou non connectés sont redirigés s'ils tentent d'accéder à des pages sécurisées.
- Blocage des tentatives de connexion :
Après 3 tentatives de connexion infructueuses, l'utilisateur est temporairement bloqué.
- Architecture
Le projet suit une architecture modulaire et maintenable en respectant les principes S.O.L.I.D :

Séparation des responsabilités : Séparation des widgets, des services Firebase, et de la logique métier.
Gestion des états : Utilisation de Provider pour une gestion centralisée des états.
Prérequis
Flutter : Assurez-vous que Flutter est installé et configuré correctement.

flutter run

### Auteurs :
Maylis Gaillard
CHONG Jong Hoa
