// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;

contract Auction{
    uint256 public buyNowPrice;
    string public  description;
    bool public bidMade;
    uint256	public closingTimer;
	uint256 public blockTiming;
	bool public isAlive;
    User public seller; //owner of the Auction
	mapping(User => uint256) private highestBid; //should always stay length 1 dictionary - string is the username of the highest Bid and Integer is the amount
 
 
    constructor(){
		//closingTimer = 43200; //30 days worth of minutes
		isAlive = true;//not really adding timer functionality rn
		User defaultUser = new User( "default", "default", 0.0);
		highestBid = new mapping(User => uint256);
		highestBid.put(defaultUser, 0.0);
		seller = User();
	}
	


	function makeBid(Double amount, User person) public aliveAuction{
		bidMade = true;
		
		if(amount < getHighestBidAmount()) {
			System.out.println("bid not allowed");
		}
		else if(amount > person.getBalance()) {
			System.out.println("bid not allowed");
			
		}
		else {
			highestBid.put(person, amount);
			highestBid.remove(getHighestBidder());

		}

	}

	function  pullHighestBid ()  public onlyHighestBidder aliveAuction{ // does not go to the second highest bidder, clears the auction and extends time instead
		
			highestBid.remove(person);
		
		this.extendTime(5.0);//adds 5 min

	}

	function extendTime (Double addedTime) public{
		closingTimer += addedTime;
	}

	function finishAuction() public aliveAuction{
		isAlive = false;
		User winner = getHighestBidder();
		Double winningAmnt = getHighestBidAmount();

		winner.setBalance(winner.getBalance() - winningAmnt);
		
		System.out.println(winner.getUsername() + " has won this auction with a bid of " + winningAmnt + "");

	}
	
	function getHighestBidder() public returns(User) {
		return highestBid.entrySet().iterator().next().getKey();
	}
	
	function getHighestBidAmount() public returns (uint256){
		return highestBid.entrySet().iterator().next().getValue();
	}
	

    modifier onlyHighestBidder() {
        require(msg.sender == getHighestBidder, "Not highest bidder");
        _;
    }


    modifier aliveAuction() {
        require(isAlive, "Not a live auction");
        _;
    }
}
    
    
    