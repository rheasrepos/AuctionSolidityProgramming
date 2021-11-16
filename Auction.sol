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
    uint256 public highestBid; //should always stay length 1 dictionary - string is the username of the highest Bid and Integer is the amount
    User public highestBidder;
    IERC721 public nft;
    uint256 public  nftID;
 
    constructor(){
		//closingTimer = 43200; //30 days worth of minutes
		isAlive = true;//not really adding timer functionality rn
		User defaultUser = new User();
	    highestBidder = defaultUser;
		highestBid=0;
	//	seller = User();

	}
	
	function createNFT(address realNft, uint256 realNftID) public{
	    nft = IERC721(realNft);
		nftID = realNftID;
	}
	


	function makeBid(uint256 amount, User person) public aliveAuction{
	    	bidMade = true;
	if(!(amount > person.getBalance()) || !(amount < highestBid)){
	    highestBid = amount;
	    highestBidder = person;
	}
	

	}

	function  pullHighestBid ()  public onlyHighestBidder aliveAuction{ // does not go to the second highest bidder, clears the auction and extends time instead
		
		highestBid = 0;
		highestBidder = new User();//empty user
		
		extendTime(5);//adds 5 min

	}

	function extendTime (uint256 addedTime) public{
		closingTimer += addedTime;
	}

	function finishAuction() public payable aliveAuction isOwner{
		isAlive = false;
		User winner = highestBidder;
		uint256 winningAmnt = highestBid;
        
		winner.setBalance(winner.getBalance() - winningAmnt);
		nft.safeTransferFrom(address(this), winner, nftID);
		nft.approve(winner, nftID);
		require(true, winner.getUsername() + " has won this auction with a bid of " + winningAmnt + "");
        
	}
	

	
	function transferFrom(User tFrom, User to, nftID) public payable{
	    if(isAlive == false){
	        
	    }	
	}

    modifier onlyHighestBidder() {
       require(msg.sender == highestBidder, "Not highest bidder");
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

    
    
    