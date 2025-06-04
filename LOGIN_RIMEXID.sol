// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

contract LogIn {

    address owner;
    address[]  authorizedAddresses;
    mapping (address => bool) public loggedInUsers;
    
    event UserLoggedIn(address indexed _user, string message);
    event AuthorizedAddressChecked(address indexed _user,bool result, string message);
    event AuthorizedAddressAdded(address indexed _user, string message);
    event AuthorizedAddressRemoved(address indexed _user, string message);


    constructor()  {
        owner = msg.sender;
        authorizedAddresses.push(owner);
    }

    function login() public returns (string memory) {
        if (isAuthorized(msg.sender)) {
            loggedInUsers[msg.sender] = true;
            emit UserLoggedIn(msg.sender, "Login Successfully");
            return "Login Successfully";
        } else {
            return "You are not authorized to use this contract.";
        }
    }

    function isAuthorized(address _user) public  returns (bool) {
        bool result = false;
        for (uint256 i = 0; i < authorizedAddresses.length; i++) {
            if (_user == authorizedAddresses[i]) {
                result = true;
                break;
            }
        }
        emit AuthorizedAddressChecked(_user, result, result ? "User has permissions" : "User does not have any permissions");
        return result;
    }

    function addAuthorizedAddress(address _user) public onlyOwner {
        authorizedAddresses.push(_user);
        emit AuthorizedAddressAdded(_user, "Permissions added to this address");
    }

   function removeAuthorizedAddress(address _user) public onlyOwner {
        uint256 indexToRemove;
        for (uint256 i = 0; i < authorizedAddresses.length; i++) {
            if (authorizedAddresses[i] == _user) {
            indexToRemove = i;
            break;
            }
        }

        delete authorizedAddresses[indexToRemove];
        emit AuthorizedAddressRemoved(_user, "Permissions removed from this address");
    }



    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }
}


// The code is a smart contract written in the Solidity programming language for the Ethereum blockchain. The contract defines a "Login" contract with a set of functions and events for controlling access to the contract.

//The owner variable stores the address of the contract's owner.
//The authorizedAddresses array stores a list of addresses that are authorized to use the contract.
//The loggedInUsers mapping is used to keep track of users who have logged in to the contract.
//The events UserLoggedIn, AuthorizedAddressChecked, AuthorizedAddressAdded, and AuthorizedAddressRemoved are emitted to log certain actions taken on the contract.
//The contract's constructor sets the owner to the address of the contract creator and adds the creator's address to the list of authorized addresses.

//The login function checks if the sender's address is authorized to use the contract using the isAuthorized function. If the sender's address is authorized, the function logs in the user by setting the value in the loggedInUsers mapping to true and emitting a UserLoggedIn event. If the sender's address is not authorized, the function returns an error message.

//The isAuthorized function checks if a given address is in the list of authorized addresses and returns true if it is, false otherwise. It also emits an AuthorizedAddressChecked event to log the result of the check.

//The addAuthorizedAddress function adds a new address to the list of authorized addresses and emits an AuthorizedAddressAdded event to log the action.

//The removeAuthorizedAddress function removes an address from the list of authorized addresses and emits an AuthorizedAddressRemoved event to log the action.

//The onlyOwner modifier is used to limit access to certain functions to only the contract owner. Any function with this modifier can only be executed by the contract's owner.

