// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './Token.sol';

// SetTeam.sol
contract SetTeam is Token {
    // 아마도 Team의 데이터를 모두 올리는 것은 분명 gas비가 많이, 자주 지출될 것이다.
    // react에서 json파일을 만들어서 관리하는 방법도 있겠지만, 
    // 연습용으로 struct에 team data를 올려보자
    struct Team {
        // Name of the team
        string teamName;
        // players
        string top;
        string jug;
        string mid;
        string adc;
        string sup;
    }
    Team[] public teams;
    mapping(uint => uint) public teamWeight;    // TeamIndex -> teamWeight

    // the team index which have won   -> updated by Vote.sol function gameEnd()
    // default : invalid index
    uint winnerTeamIndex = uint(-1);
    // weigth of the winner. for calculation of ratio("before" Vote.sol function gameEnd()) 
    uint winnerTeamTotalBalance = 0;      

    // modifier which can allow only owner to do something
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // add team
    function setTeam(string memory _teamName, string memory _top, string memory _jug, string memory _mid, string memory _adc, string memory _sup) public onlyOwner {
        //ex. _team = ['T1', 'Zeus', 'Oner', 'Faker', 'Gumayusi', 'Keria']
        // check the team name if it is already in here
        require(getTeamIndexByTeamName(_teamName) != uint(-1));
        teams.push(Team({
            teamName: _teamName,
            top: _top,
            jug: _jug,
            mid: _mid,
            adc: _adc,
            sup: _sup
        }));
        teamWeight[getTeamIndexByTeamName(_teamName)] = 0;
    }

    // for Vote.sol, get the index of the team
    function getTeamIndexByTeamName(string memory _teamName) internal view returns (uint) {
        for (uint i = 0; i < teams.length; i++) {
            if (keccak256(bytes(teams[i].teamName)) == keccak256(bytes(_teamName))) {
                return i;
            }
        }
        // If the team name is not found, return an invalid index value (-1)
        return uint(-1);
    }

    // for React, to get the data of the team
    function getTeamDataByTeamName(string calldata  _teamName) external view returns (string memory, string memory, string memory, string memory, string memory, string memory) {
        uint teamIndex = getTeamIndexByTeamName(_teamName);
        require(teamIndex != uint(-1), "Wrong name"); // check name

        Team memory team = teams[teamIndex];
        return (team.teamName, team.top, team.jug, team.mid, team.adc, team.sup);
    }

    function getTeamWeightByTeamName(string calldata _teamName) external view returns (uint) {
        return teamWeight[getTeamIndexByTeamName(_teamName)];
    }
}
