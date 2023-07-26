// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18 <0.9.0;
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
    mapping(uint => uint) public teamWeight;    // Team Index -> team Weight
    // Team Name -> Team index(setTeam 설정할 때 default가 0이어서 하나씩 밀려서 표기하도록 함)
    // ex. ['T1', 'Gen.G', 'KT'..]있을 때 원래 0, 1, 2가 index이지만 
    // mapping teamIndex는 1, 2, 3을 return함. 다른 함수에서 사용될 때 -1을 해야 정상적인 팀이 표기됨됨
    mapping(string => uint) public teamIndex;   
    


    // the team index which have won   -> updated by Vote.sol function gameEnd()
    // default : invalid index
    uint winnerTeamIndex = INVALID_INDEX;
    // weigth of the winner. for calculation of ratio("before" Vote.sol function gameEnd()) 
    uint bettingTotalBalance = 0;   
    uint winnerTeamPureBalance = 0;   

    // modifier which can allow only owner to do something
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        teamIndex[""] = INVALID_INDEX;
    }

    function setTeam(string memory _teamName, string memory _top, string memory _jug, string memory _mid, string memory _adc, string memory _sup) external onlyOwner {
        // Check if the team name is not empty
        require(bytes(_teamName).length > 0, "Team name cannot be empty");

        // Check if the team name is unique (not already added)
        require(teamIndex[_teamName] == 0, "Team name already exists");

        // Create a new Team struct and add it to the teams array
        Team memory newTeam = Team({
            teamName: _teamName,
            top: _top,
            jug: _jug,
            mid: _mid,
            adc: _adc,
            sup: _sup
        });

        uint _teamIndex = teams.length;
        teams.push(newTeam);    

        // Update the team index mapping with the new team index
        teamIndex[_teamName] = _teamIndex;
        // Set the team weight to 0 initially
        teamWeight[_teamIndex] = 0;
    }

    // for Vote.sol, get the index of the team
    function getTeamIndexByTeamName(string memory _teamName) internal view returns (uint) {
        return teamIndex[_teamName];
    }

    // for React, to get the data of the team
    function getTeamDataByTeamName(string calldata  _teamName) external view returns (string memory, string memory, string memory, string memory, string memory, string memory) {
        uint _teamIndex = getTeamIndexByTeamName(_teamName);
        require(_teamIndex != INVALID_INDEX, "Invalid team name"); // check name

        Team memory team = teams[_teamIndex];
        return (team.teamName, team.top, team.jug, team.mid, team.adc, team.sup);
    }

    function getTeamWeightByTeamName(string calldata _teamName) external view returns (uint) {
        return teamWeight[getTeamIndexByTeamName(_teamName)];
    }
}
