// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;
import "./Auction.sol";

contract User{

    
    address private  username;
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

	function getUsername() public returns( address ){
		return username;
	}

	function setUsername(address _username) public{
		username = _username;
	}
	
//	function makeBid(Auction auction, uint256 amount) public {
//		auction.makeBid(amount, this);
//	}
}