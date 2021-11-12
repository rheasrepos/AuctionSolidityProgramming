// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;
import "./User.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction{
    uint256 public buyNowPrice;
    string public  description;
    bool public bidMade;
    uint256	public closingTimer;
	uint256 public blockTiming;
	bool public isAlive;
    User public seller; //owner of the Auction
	mapping(User => uint256) private highestBid; //should always stay length 1 dictionary - string is the username of the highest Bid and Integer is the amount
    IERC721 public immutable nft;
    uint256 public immutable nftID;
 
    constructor(address realNft, uint256 realNftID){
		//closingTimer = 43200; //30 days worth of minutes
		isAlive = true;//not really adding timer functionality rn
		User defaultUser = new User();
	//	highestBid = new mapping(User => uint256);
		highestBid.push(defaultUser, 0);
		seller = User();
		nft = realNft;
		nftID = realNftID;
	}
	


	function makeBid(uint256 amount, User person) public aliveAuction{
	    	bidMade = true;
		
			require(!(amount > person.getBalance()) || !(amount < getHighestBidAmount()), highestBid.put(person, amount));
		
		    if(highestBid.length() > 1){
		    	highestBid.remove(getHighestBidder());
		    }
		
	

	}

	function  pullHighestBid ()  public onlyHighestBidder aliveAuction{ // does not go to the second highest bidder, clears the auction and extends time instead
		
		highestBid.remove(1);
		
		extendTime(5);//adds 5 min

	}

	function extendTime (uint256 addedTime) public{
		closingTimer += addedTime;
	}

	function finishAuction() public aliveAuction isOwner{
		isAlive = false;
		User winner = getHighestBidder();
		uint256 winningAmnt = getHighestBidAmount();
        
		winner.setBalance(winner.getBalance() - winningAmnt);
		nft.safeTransferFrom(seller, winner, nftID);
		nft.approve(winner, nftID);
		require(true, winner.getUsername() + " has won this auction with a bid of " + winningAmnt + "");
        
	}
	
	function getHighestBidder() public returns(User) {
		return highestBid.entrySet().iterator().next().getKey();
	}
	
	function getHighestBidAmount() public returns (uint256){
		return highestBid.entrySet().iterator().next().getValue();
	}
	
//	function transferFrom(User tFrom, User to, nftID) public payable{
	   // if(isAlive == false){
	        
	   // }	
//	}

    modifier onlyHighestBidder() {
        require(msg.sender == getHighestBidder, "Not highest bidder");
        _;
    }


    modifier aliveAuction() {
        require(isAlive, "Not a live auction");
        _;
    }
    
    modifier isOwner(){
        require(msg.sender == seller, "you cannot perform this acttion, you are not the seller");
        _;
    }
    
}

    
    
    