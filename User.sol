// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;

contract User{

    
    string private  username;
    uint256 private balance;

    constructor(){
        username = msg.sender;
    	balance = msg.sender.balance;
    }

	function getBalance() public returns(uint256) {
		return balance;
	}

	function setBalance(uint256 _balance) public{
	    balance = _balance;
	}

	function getUsername() public returns(string){
		return username;
	}

	function setUsername(string _username) public{
		username = _username;
	}
	
	function makeBid(Auction auction, uint256 amount) public {
		auction.makeBid(amount, this);
	}
}