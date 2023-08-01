// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0; //>=0.8.18 <0.9.0
import './SetTeam.sol';
// Vote.sol

contract Vote is SetTeam {
    // user가 베팅하는 함수
    function vote(uint256 _amount, string memory _teamName) public returns(bool) {
        // 투표는 한 번만 가능하기에 이미 했었는지 확인
        require(!userData[msg.sender].voted, "You have already voted!");
        // 자신이 가진 돈 이하만 베팅할 수 있어야함
        require(balanceOf(msg.sender) >= _amount, "Not enough tokens!");

        // 베팅하고 싶은 팀의 index 받아옴
        uint index = getTeamIndexByTeamName(_teamName);
        require(index != INVALID_INDEX, "Invalid team name");

        // 박은 돈 -> 팀의 베팅 묶인 돈으로 옮김
        userData[msg.sender].balance -= _amount;
        teamWeight[index] += _amount;
        // 나중에 gameEnd()가 실행됬을 때, 돈을 되돌려 받을 때 비율 계산을 위해서 박은 돈의 양 저장
        userData[msg.sender].voteBalance += _amount; 

        // 베팅 했으니 겜 끝날 때까지 베팅 못하도록 제한걸어둠
        userData[msg.sender].voted = true;
        // 어떤 팀에 베팅했었는지 저장
        userData[msg.sender].teamIndex = index;
        
        return true;
    }

    // 어떤 팀이 이겼었는지 설정함
    // SetTeam.sol에 있는 winnerTeamIndex값을 초기화함.
    function gameEnd(string memory _teamNameWin, string memory _teamNameLose) public onlyOwner returns(uint) {
        // 이긴 팀, 진 팀의 index 받아와서
        uint _winnerTeamIndex = getTeamIndexByTeamName(_teamNameWin);
        uint _loserTeamIndex = getTeamIndexByTeamName(_teamNameLose);
        require(_winnerTeamIndex != INVALID_INDEX, "Invalid winner team name");
        require(_loserTeamIndex != INVALID_INDEX, "Invalid loser team name");

        winnerTeamIndex = _winnerTeamIndex;
        // 순수 winner team 총 베팅 금액(비율 계산용)
        winnerTeamPureBalance = teamWeight[_winnerTeamIndex];      
        // 진 팀에 묶인 돈을 모두 이긴 팀에 옮김
        teamWeight[_winnerTeamIndex] += teamWeight[_loserTeamIndex];

        // 총 묶인 돈 : bettingTotalBalance(계산 용으로 따로 빼둠)
        bettingTotalBalance = teamWeight[_winnerTeamIndex];
        teamWeight[_loserTeamIndex] = 0;

        return _winnerTeamIndex;
    }


    // 진 팀 베팅한 사람 : 나중에 투표 또 할 수 있게 투표권 다시 부여
    // 이긴 팀 베팅한 사람 : 돈 주고, 투표권 다시 부여
    function returnBettingResult() public {
        require(winnerTeamIndex != INVALID_INDEX, "winner team index not set");

        if (getUserVotedTeamIndex(msg.sender) == winnerTeamIndex) {
            // 자신이 넣은 돈에 비례해서
            uint amountToReturn = (voteBalanceOf(msg.sender) / winnerTeamPureBalance) * bettingTotalBalance;
            // teamWeight[winner]에서 차감되면서 user에게 나누어줌
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
        winnerTeamIndex = INVALID_INDEX;
    }
}