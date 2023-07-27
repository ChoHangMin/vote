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
    mapping(string => uint) public teamIndex;   
    
    // 이긴 팀의 index가 설정되는 변수. Vote.sol의 gameEnd()가 실행되면 값이 설정된다.
    // default : invalid index
    uint winnerTeamIndex = INVALID_INDEX;

    // 이긴 팀에 묶였던 돈. 이긴 팀에 베팅한 사람들이 건 돈의 비율만큼 돈을 돌려주기 위해서
    // 비율 계산을 위해 변수를 설정했음
    uint bettingTotalBalance = 0;   
    uint winnerTeamPureBalance = 0;   

    // msg.sender가 owner(ganache의 첫번째 계좌)이어야지 함수가 실행될 수 있는 제한자
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        teamIndex[""] = INVALID_INDEX;
    }

    function setTeam(string memory _teamName, string memory _top, string memory _jug, string memory _mid, string memory _adc, string memory _sup) external onlyOwner {
        // 팀 이름이 적혀있어야 실행
        require(bytes(_teamName).length > 0, "Team name cannot be empty");

        // 이미 teamName이 입력되었는지 확인
        require(teamIndex[_teamName] == 0, "Team name already exists");

        // 입력받은 값들을 Team 구조체에 넣음
        Team memory newTeam = Team({
            teamName: _teamName,
            top: _top,
            jug: _jug,
            mid: _mid,
            adc: _adc,
            sup: _sup
        });
        // teamIndex를 설정
        uint _teamIndex = teams.length;
        // 구조체를 배열에 넣음(나중에 팀 정보를 index에 의해 빼내오기 위해서)
        teams.push(newTeam);    

        // teamIndex를 mapping에 의해 찾을 수 있도록 값 설정
        teamIndex[_teamName] = _teamIndex;
        // team에 배팅된 금액은 0으로 설정
        // ! 궁금점 : mapping 기본값은 0으로 되어있는데, 따로 여기서 0이라고 명시할 필요가 있을까?
        teamWeight[_teamIndex] = 0;
    }

    // Vote.sol에서 사용할 수 있도록, 팀 이름을 받아서 index를 알려줌
    function getTeamIndexByTeamName(string memory _teamName) internal view returns (uint) {
        return teamIndex[_teamName];
    }

    // React에서 팀의 데이터(팀이름, 선수명 등)를 꺼내오기 위해서 설정
    function getTeamDataByTeamName(string calldata  _teamName) external view returns (string memory, string memory, string memory, string memory, string memory, string memory) {
        uint _teamIndex = getTeamIndexByTeamName(_teamName);
        require(_teamIndex != INVALID_INDEX, "Invalid team name"); // check name

        Team memory team = teams[_teamIndex];
        return (team.teamName, team.top, team.jug, team.mid, team.adc, team.sup);
    }

    // Vote.sol에서 사용. 팀에 베팅된 금액을 구하기 위해서 만듬
    function getTeamWeightByTeamName(string calldata _teamName) external view returns (uint) {
        return teamWeight[getTeamIndexByTeamName(_teamName)];
    }
}
