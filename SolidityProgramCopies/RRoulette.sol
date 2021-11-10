// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;

contract RRoulette{
    
    address[] players;
    address[] public losers;
    uint256 odds;
    uint256 playersTurn; // index of the next player to play
    address public creator;
    
    constructor(){
        creator = msg.sender;
    }
    
    function setOdds(uint256 oneInThisMany) public{
        if(msg.sender == creator){
            odds = oneInThisMany;
        }
    }
    
    function addPlayer(address Player) public{
        if(contains(losers, Player) == false || isALoser(Player) == false){
            players.push(Player);
            
        }
        else{
            require(true, "you cannot be added to the player list. you have either already lost or are currently playing");
        }
    }
    
    function lose(address Player) internal{
        
        delete players; //clears the player array of all of its elements
        losers.push(Player);
        
    }
    
    function random(uint _modulus) internal returns(uint){
        
        uint randNonce = 0;
        
        randNonce++;
        return (uint(keccak256(abi.encodePacked(block.timestamp, msg.sender,randNonce))) % _modulus);
        
        //https://www.geeksforgeeks.org/random-number-generator-in-solidity-using-keccak256/ 
        
    }
    
    function play() public{
        
        playersTurn = 0;
        if(random(10) == 1){
            lose(players[playersTurn]);
        }
        else{
            playersTurn ++;
        }
        
    }
    
    function isALoser (address person) public returns(bool){
       return contains(losers, person);
    }
    
    function contains(address[] memory array, address Player) public returns(bool) {
        for(uint256 i = 0; i< array.length; i++){
            if(array[i] == Player){
                return true;
            }
        }
        
        return false;
    }
    
    
    
    
    
}