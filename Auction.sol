// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9 <0.9.0;
//import "./User.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction{
    uint256 public buyNowPrice;
    bool public bidMade;
    uint256	public closingTimer;
	uint256 public blockTiming;
	bool public isAlive;
    address payable public  seller; //owner of the Auction
    uint256 public highestBid; //should always stay length 1 dictionary - string is the username of the highest Bid and Integer is the amount
    address public highestBidder;
    IERC721 public nft;
    uint256 public  nftID;
 
    constructor(){
		closingTimer = 43200; //30 days worth of minutes
		isAlive = true;//not really adding timer functionality rn
		
		highestBid=0;
	//	seller = User();
	
	

	}
	
	function createNFT(address realNft, uint256 realNftID) public{
	    nft = IERC721(realNft);
		nftID = realNftID;
	}
	


	function makeBid(uint256 amount) public payable aliveAuction{
	    	bidMade = true;
    	if(!(amount > msg.sender.balance) || !(amount < highestBid)){
	    highestBid = amount;
	    highestBidder = msg.sender;
	}


	}
	


	function  pullHighestBid ()  public onlyHighestBidder aliveAuction{ // does not go to the second highest bidder, clears the auction and extends time instead
		
		highestBid = 0;

		extendTime(5);//adds 5 min

	}

	function extendTime (uint256 addedTime) public{
		closingTimer += addedTime;
	}

	function finishAuction() public payable aliveAuction isOwner{
		isAlive = false;
		address winner = highestBidder;
		uint256 winningAmnt = highestBid;
		closingTimer = 0; //for right now im just manually adjusting the timer and finishing the auction
        
	//	winner.setBalance(winner.getBalance() - winningAmnt);
		nft.safeTransferFrom(address(this), winner, nftID);
		nft.approve(winner, nftID);
		seller.transfer(msg.value);
	}
	


    modifier onlyHighestBidder() {
       require(msg.sender == highestBidder, "Not highest bidder");
        _;
    }


    modifier aliveAuction() {
        require(isAlive && closingTimer != 0, "Not a live auction");
        _;
    }
    
    modifier isOwner(){
        require(msg.sender == seller, "you cannot perform this acttion, you are not the seller");
        _;
    }
    
}

    
    
    