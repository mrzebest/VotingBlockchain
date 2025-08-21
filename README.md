# Projet Blockchain : Système de Vote

## Vue d'ensemble du projet

Ce projet implémente un système de vote décentralisé sur blockchain permettant :
- Vote unique par électeur
- Résultats transparents et sécurisés  
- Gestion des candidats
- Interface utilisateur intuitive

## Technologies utilisées

- **Smart Contract** : Solidity (Ethereum)
- **Interface** : HTML5, CSS3, JavaScript
- **Blockchain** : Ethereum (avec simulation pour tests)
- **Framework** : Web3.js pour l'interaction blockchain

## Structure du projet

```
voting-system/
├── contracts/
│   └── VotingSystem.sol          # Smart contract principal
├── web/
│   └── index.html               # Interface web
├── docs/
│   └── README.md               # Ce guide
└── tests/
    └── test-scenarios.md       # Scénarios de test
```

## Installation et déploiement

### Prérequis
- Node.js et npm
- Truffle 
- MetaMask (pour tests avec vraie blockchain)
- Serveur web local (Live Server, http-server, etc.)

### Étapes de déploiement

1. **Cloner le projet**
```bash
git clone [url-du-projet]
cd voting-system
```

2. **Installer les dépendances**
```bash
npm install truffle
npm install @openzeppelin/contracts
```

3. **initialisation de truflle**
```bash
truffle init
```

3. **enlever les commentaires dans truffle-config.js pour la config ganache**
```javascript
module.exports = {
  networks: {},
  compilers: {
    solc: {
      version: "0.8.20", // ou la version de Solidity que vous utilisez
    }
  }
};
```
4. **Compiler le smart contract**
```bash
truffle compile
```

5. **Déployer sur réseau local (Ganache)**
```bash
truffle migrate --network development
```

5. **Lancer l'interface web**
```bash
# Option 1: Serveur Python
python -m http.server 8000

# Option 2: Live Server (VS Code)
# Ouvrir index.html avec Live Server

# Option 3: Node.js http-server
npx http-server
```

## Tests et démonstration

### Mode simulation (inclus dans l'interface)
L'interface web inclut un mode simulation qui permet de tester toutes les fonctionnalités sans blockchain réelle :

1. **Test des rôles utilisateur**
   - Admin : Peut ajouter candidats, démarrer/arrêter votes
   - Users : Peuvent seulement voter

2. **Scénarios de test recommandés**
   - Ajouter 3-5 candidats
   - Démarrer le vote
   - Tester avec différents utilisateurs
   - Vérifier l'unicité des votes
   - Consulter les résultats
   - Arrêter le vote

### Tests avec vraie blockchain

1. **Configuration Ganache si pas déjà fait**
```javascript
// truffle-config.js
networks: {
  development: {
    host: "127.0.0.1",
    port: 7545,
    network_id: "*"
  }
}
```

2. **Tests unitaires**
```bash
truffle test
```

## Fonctionnalités principales

### Smart Contract (`VotingSystem.sol`)

**Variables d'état :**
- `candidates` : Mapping des candidats
- `hasVoted` : Tracking des votes par adresse
- `votingOpen` : État du vote
- `owner` : Propriétaire du contract

**Fonctions principales :**
- `addCandidate(string)` : Ajouter un candidat
- `startVoting()` : Démarrer le vote
- `endVoting()` : Terminer le vote
- `vote(uint256)` : Voter pour un candidat
- `getResults()` : Obtenir les résultats
- `getWinner()` : Obtenir le gagnant

**Modificateurs de sécurité :**
- `onlyOwner` : Seul le propriétaire
- `votingIsOpen` : Vote doit être ouvert
- `hasNotVoted` : Utilisateur n'a pas encore voté
- `validCandidate` : ID candidat valide

### Interface Web

**Sections principales :**
1. **État du système** : Statut en temps réel
2. **Administration** : Gestion des candidats et votes
3. **Vote** : Interface de vote pour électeurs
4. **Résultats** : Affichage des résultats et gagnant

**Fonctionnalités UI :**
- Design responsive
- Messages d'erreur/succès
- Simulation multi-utilisateurs
- Actualisation automatique

## Sécurité implémentée

### Smart Contract
- Vote unique par adresse
- Validation des entrées
- Modificateurs d'accès
- Gestion des états
- Événements pour traçabilité

### Interface
- Validation côté client
- Gestion des erreurs
- État cohérent
- Simulation sécurisée

## Résultats de tests

### Test 1 : Fonctionnalités de base
- Ajout de candidats
- Démarrage/arrêt du vote
- Vote unique
- Décompte des votes

### Test 2 : Sécurité
- Prévention double vote
- Accès admin seulement
- Validation des données
- États cohérents

### Test 3 : Interface utilisateur
- Responsive design
- Messages clairs
- Navigation intuitive
- Simulation réaliste

