// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
// Token.sol
contract Token {
    uint256 public totalSupply = 1000000 * (10 ** 18);
    uint8 public decimals = 18;
    string public name = 'lol token';
    string public symbol = 'lt';
    address public owner;

    struct User {
        uint256 balance;    // tokens
        bool firstEnter;    // is it first try?
        bool voted;         // true: already voted(default), false: have right to vote(by giveRightToVote())
        uint teamIndex;     // the teamIndex where user have voted
        uint voteBalance;   // the amount user have voted(not the Balance that goes back. according to ratio)
    }


    mapping(address => User) userData;          // get access to 'struct User' by address(ex. msg.sender)
    mapping(address => bool) registeredUsers;   // To check the msg.sender has registered in this DApp(default : false)


    constructor() public {
        owner = msg.sender;
    }    

    // get balance by address
    function balanceOf(address _address) view public returns(uint) {
        return userData[_address].balance;
    }
    // get vote balance by address
    function voteBalanceOf(address _address) view public returns(uint) {
        return userData[_address].voteBalance;
    }
    function getUserVotedTeamIndex(address _address) view public returns(uint) {
        return userData[_address].teamIndex;
    }

    function logIn() public {
        // Ensure the user doesn't exist already
        // require the total Supply is enough to send to users
        require(!registeredUsers[msg.sender], 'You have already registered');
        require(totalSupply >= 10 * (10 ** 18), 'Not enough totalSupply!');
        registeredUsers[msg.sender] = true;

        // Create the new user
        userData[msg.sender] = User({
            balance: 10 * (10 ** 18),
            firstEnter: true,
            voted: true,
            teamIndex: uint(-1),
            voteBalance: 0
        });
        totalSupply -= 10 * (10 ** 18);
    }
    
    function giveRightToVote(address _address) public returns(bool) {
        require(msg.sender == owner, 'Only owner can give acceess');
        // set the user to vote
        userData[_address].voted = false;
        return true;
    }

    function showOwner() public view returns(address) {     // for check the address of owner(just for experience)
        return owner;
    }
}