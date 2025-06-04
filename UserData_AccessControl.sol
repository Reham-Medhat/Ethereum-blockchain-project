// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/AccessControl.sol";

contract UserData is AccessControl{

    bytes32 public constant ADMIN_ROLE = keccak256("ADMINKAILLINUX_ROLE");
    /// 0xfad356c6b9377812908d02f78497cba8bf0977c97a0b6eedf5241ba9ea6739eb
    bytes32 public constant ADMIN_and_USER_ROLE = keccak256("ADMIN_and_USER_ROLE_KALIILNUX");
    /// 0xf96da2108fe067f377a7208448774d173b6c8757e76c77952d583371ff077adb
    bytes32 public constant USER_ROLE = keccak256("USERKAILLINUX_ROLE");
    /// 0xd300e38a078a5fc92ae2ef002661b36f0fbc0724c50811402973e9f205d19a95
    
    constructor(){
        //Grant the contract deployer the default admin role: it will be able
        //to grant and revoke any roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    address owner ;
    modifier onlyOwner() {
    require(msg.sender == owner, "AccessControl: Only the owner can perform this action");
    _;
}


    struct User {
        string name;
        uint age;
        string gender;
        address walletAddress;
    }
    
    mapping (address => User) private users;

    event LogUserData(string name, uint age, string gender, address walletAddress);
    event LogUserDeleted(address walletAddress);
    event LogUserUpdated(address walletAddress,string name, uint age, string gender );

    function recordData(string memory _name, uint _age, string memory _gender, address _walletAddress) public  {
        require(hasRole(ADMIN_and_USER_ROLE , msg.sender),"You do not have the right to make this mark and you are not authenticated");
        users[_walletAddress].name = _name;
        users[_walletAddress].age = _age;
        users[_walletAddress].gender = _gender;
        users[_walletAddress].walletAddress = _walletAddress;
        emit LogUserData(_name, _age, _gender, _walletAddress);
    }

    function updateData(string memory _name, uint _age, string memory _gender, address _walletAddress) public  {
        require(hasRole(USER_ROLE , msg.sender),"You do not have the right to make this mark and you are not authenticated");
        users[_walletAddress].name = _name;
        users[_walletAddress].age = _age;
        users[_walletAddress].gender = _gender;
        emit LogUserUpdated(_walletAddress,_name,_age,_gender);
    }

    function returnData(address _walletAddress) public view returns (string memory, uint, string memory) {
        require(hasRole(ADMIN_ROLE , msg.sender),"You do not have the right to make this mark and you are not authenticated");
        User storage user = users[_walletAddress];
        return (user.name, user.age, user.gender);
    }

    function deleteData(address _walletAddress) public {
        require(hasRole(ADMIN_ROLE , msg.sender),"You do not have the right to make this mark and you are not authenticated");
        delete users[_walletAddress];
        emit LogUserDeleted(_walletAddress);
    }

    function renounceRole(bytes32 role, address account) override public  onlyOwner {
        require(hasRole(ADMIN_ROLE , msg.sender),"You do not have the right to make this mark and you are not authenticated");
        renounceRole(role , account);
    }
}
