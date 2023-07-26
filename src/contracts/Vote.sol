// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18 <0.9.0;
import './SetTeam.sol';
// Vote.sol

contract Vote is SetTeam {
    function vote(uint256 _amount, string memory _teamName) public returns(bool) {
        // Check if the user have voetd
        require(!userData[msg.sender].voted, "You have already voted!");
        // Needs more balance than the amount you want to invest
        require(balanceOf(msg.sender) >= _amount, "Not enough tokens!");

        // get the index of the team which you want to vote 
        uint index = getTeamIndexByTeamName(_teamName);
        require(index != INVALID_INDEX, "Invalid team name");

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
        uint _loserTeamIndex = getTeamIndexByTeamName(_teamNameLose);
        require(_winnerTeamIndex != INVALID_INDEX, "Invalid winner team name");
        require(_loserTeamIndex != INVALID_INDEX, "Invalid loser team name");

        winnerTeamIndex = _winnerTeamIndex;
        // Loser Team weight -> Winer Team weight
        winnerTeamPureBalance = teamWeight[_winnerTeamIndex];      // 순수 winner team 총 베팅 금액(비율 계산용)
        teamWeight[_winnerTeamIndex] += teamWeight[_loserTeamIndex];

        // 총 묶인 돈 : bettingTotalBalance
        bettingTotalBalance = teamWeight[_winnerTeamIndex];
        teamWeight[_loserTeamIndex] = 0;

        return _winnerTeamIndex;
    }


    // 진 팀 베팅한 사람은 voted 여전히 true로 남아남남
    function returnBettingResult() public {
        require(winnerTeamIndex != INVALID_INDEX, "winner team index not set");

        if (getUserVotedTeamIndex(msg.sender) == winnerTeamIndex) {
            uint amountToReturn = (voteBalanceOf(msg.sender) / winnerTeamPureBalance) * bettingTotalBalance;

            userData[msg.sender].balance += amountToReturn;
            teamWeight[winnerTeamIndex] -= amountToReturn;
        }
        // user betting 관련 data 초기화
         userData[msg.sender].teamIndex = INVALID_INDEX;
        userData[msg.sender].voteBalance = 0;
        userData[msg.sender].voted = false;
    }

    // 아직까지 안받아갔어도 늦은 죄로 못받음(ex. 강제 종료)
    // 남은 돈 totalSupply로 이동
    // winner team weight = 0
    function returnBettingResultOver() public onlyOwner {
        require(winnerTeamIndex != INVALID_INDEX, "winner team index not set");
        totalSupply += teamWeight[winnerTeamIndex];
        teamWeight[winnerTeamIndex] = 0;
    }
}