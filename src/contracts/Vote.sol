// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './SetTeam.sol';
// Vote.sol

contract Vote is SetTeam {
    function vote(uint256 _amount, string memory _teamName) public returns(bool) {
        // Check if the user have voetd
        require(!userData[msg.sender].voted);
        // Needs more balance than the amount you want to invest
        require(balanceOf(msg.sender) >= _amount, 'Not enough tokens!');

        // get the index of the team which you want to vote 
        uint index = getTeamIndexByTeamName(_teamName);
        // transfers tokens to the team, voteBalance 
        userData[msg.sender].balance -= _amount;
        teamWeight[index] += _amount;
        userData[msg.sender].voteBalance += _amount; 

        // user have voted
        userData[msg.sender].voted = true;
        userData[msg.sender].teamIndex = index;
        
        return true;
    }

    // update winnerTeamIndex(in SetTeam.sol)
    function gameEnd(string memory _teamNameWin, string memory _teamNameLose) public onlyOwner returns(uint) {
        // get the winner team index
        uint _winnerTeamIndex = getTeamIndexByTeamName(_teamNameWin);
        uint _LoserTeamIndex = getTeamIndexByTeamName(_teamNameLose);
        require(_winnerTeamIndex != uint(-1));
        require(_LoserTeamIndex != uint(-1));

        winnerTeamIndex = _winnerTeamIndex;
        // Loser Team weight -> Winer Team weight
        winnerTeamTotalBalance = teamWeight[_winnerTeamIndex];      // update winner Team Total Balance for function returnBettingResult()
        teamWeight[_winnerTeamIndex] += teamWeight[_LoserTeamIndex];
        teamWeight[_LoserTeamIndex] = 0;

        return _winnerTeamIndex;
    }

    function returnBettingResult() public returns(bool) {
        require(winnerTeamIndex != uint(-1));                               // not default(after function gameEnd)
        require(getUserVotedTeamIndex(msg.sender) == winnerTeamIndex);      // check the team which user have voted
        
        uint ratio = voteBalanceOf(msg.sender) / winnerTeamTotalBalance;
        userData[msg.sender].balance += winnerTeamTotalBalance * ratio;             // return betting balance by ratio
        teamWeight[winnerTeamIndex] -= winnerTeamTotalBalance * ratio;     // from teamWeight[_winnerTeamIndex]
        return true;
    }
}