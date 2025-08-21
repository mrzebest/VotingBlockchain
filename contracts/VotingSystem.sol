// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Structure pour représenter un candidat
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    
    // Variables d'état
    address public owner;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint256 public candidatesCount;
    bool public votingOpen;
    
    // Événements
    event CandidateAdded(uint256 candidateId, string name);
    event VoteCast(address voter, uint256 candidateId);
    event VotingStarted();
    event VotingEnded();
    
    // Modificateurs
    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut executer cette fonction");
        _;
    }
    
    modifier votingIsOpen() {
        require(votingOpen, "Le vote n'est pas ouvert");
        _;
    }
    
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "Vous avez deja vote");
        _;
    }
    
    modifier validCandidate(uint256 _candidateId) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Candidat invalide");
        _;
    }
    
    // Constructeur
    constructor() {
        owner = msg.sender;
        votingOpen = false;
    }
    
    // Ajouter un candidat (seulement le propriétaire)
    function addCandidate(string memory _name) public onlyOwner {
        require(!votingOpen, "Impossible d'ajouter des candidats pendant le vote");
        require(bytes(_name).length > 0, "Le nom du candidat ne peut pas etre vide");
        
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        
        emit CandidateAdded(candidatesCount, _name);
    }
    
    // Démarrer le vote
    function startVoting() public onlyOwner {
        require(!votingOpen, "Le vote est deja ouvert");
        require(candidatesCount > 0, "Aucun candidat ajoute");
        
        votingOpen = true;
        emit VotingStarted();
    }
    
    // Arrêter le vote
    function endVoting() public onlyOwner {
        require(votingOpen, "Le vote n'est pas ouvert");
        
        votingOpen = false;
        emit VotingEnded();
    }
    
    // Voter pour un candidat
    function vote(uint256 _candidateId) 
        public 
        votingIsOpen 
        hasNotVoted 
        validCandidate(_candidateId) 
    {
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }
    
    // Obtenir les informations d'un candidat
    function getCandidate(uint256 _candidateId) 
        public 
        view 
        validCandidate(_candidateId) 
        returns (uint256, string memory, uint256) 
    {
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
    
    // Obtenir le nombre total de candidats
    function getCandidatesCount() public view returns (uint256) {
        return candidatesCount;
    }
    
    // Vérifier si une adresse a déjà voté
    function hasAddressVoted(address _address) public view returns (bool) {
        return hasVoted[_address];
    }
    
    // Vérifier si le vote est ouvert
    function isVotingOpen() public view returns (bool) {
        return votingOpen;
    }
    
    // Obtenir tous les résultats (fonction utilitaire)
    function getAllResults() public view returns (string[] memory names, uint256[] memory votes) {
        names = new string[](candidatesCount);
        votes = new uint256[](candidatesCount);
        
        for (uint256 i = 1; i <= candidatesCount; i++) {
            names[i-1] = candidates[i].name;
            votes[i-1] = candidates[i].voteCount;
        }
        
        return (names, votes);
    }
    
    // Obtenir le gagnant (en cas d'égalité, retourne le premier trouvé)
    function getWinner() public view returns (string memory winnerName, uint256 winnerVotes) {
        require(candidatesCount > 0, "Aucun candidat");
        
        uint256 winningVoteCount = 0;
        uint256 winningCandidateId = 0;
        
        for (uint256 i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }
        
        if (winningCandidateId != 0) {
            winnerName = candidates[winningCandidateId].name;
            winnerVotes = winningVoteCount;
        } else {
            winnerName = "Aucun vote";
            winnerVotes = 0;
        }
    }
}