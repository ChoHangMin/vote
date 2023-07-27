// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18 <0.9.0;
// Token.sol
// 주석에서 설명하는 토큰, 돈은 모두 같은 개념
// 실제 배포용이 아닌 testnet에서 하는 것이기 때문에 가스비 제외하고는 실제 Eth를 사용하는 과정은 없음
contract Token {
    uint256 public totalSupply = 1000000 * (10 ** 18);      // 총 토큰 발행량
    uint8 public decimals = 18;                             // 소수점 자리 수
    string public name = 'lol token';                       // 토큰 이름
    string public symbol = 'lt';                            // 단위
    address public owner;                                   // owner 주소(constructor에 의해서 정해짐)

    struct User {
        uint256 balance;    // user의 돈
        bool voted;         // 한 팀에 베팅하면, 추가 베팅을 못하게 하는 변수
        uint teamIndex;     // user가 베팅한 팀의 index(결국 팀의 이름을 구할 수 있음)
        uint voteBalance;   // 그 팀에 얼마를 박았는가?(박은 비율에 따라서 돈을 되돌려주기 때문에 설정했음)
    }


    mapping(address => User) userData;          // struct User에 접근하기 위해서 설정
    mapping(address => bool) registeredUsers;   // logIn()함수가 계좌당 한 번만 실행되기 위해서 설정

    uint public INVALID_INDEX = 100;            // SetTeam.sol, Token.sol에서 올바르지 않은 값은 모두 이거로 설정했음

    constructor()  {                            // owner 값 저장해둠
        owner = msg.sender;
    }    

    // 주소에 따른 잔액을 표시
    function balanceOf(address _address) view public returns(uint) {
        return userData[_address].balance;
    }
    // 주소에 따른 베팅금액 표시
    function voteBalanceOf(address _address) view public returns(uint) {
        return userData[_address].voteBalance;
    }
    // 주소에 따른 베팅을 한 팀 index 표시
    function getUserVotedTeamIndex(address _address) view public returns(uint) {
        return userData[_address].teamIndex;
    }


    function logIn() public {
        // logIn()은 한 번만 실행될 수 있음(by mapping -> registeredUsers)
        // 토큰 총 발행량을 넘어서는 유저의 수는 안됨
        require(!registeredUsers[msg.sender], 'You have already registered');
        require(totalSupply >= 10 * (10 ** 18), 'Not enough totalSupply!');
        registeredUsers[msg.sender] = true;

        // user에게 기본 자본, 투표권 등 지급 및 세팅 설정
        userData[msg.sender] = User({
            balance: 10 * (10 ** 18),
            voted: false,
            teamIndex: INVALID_INDEX,
            voteBalance: 0
        });
        totalSupply -= 10 * (10 ** 18);
    }

    // 없어도 됨. react에서 owner의 주소를 잘 받아오는지 표기하기 위해서 인위적으로 만들었음
    function showOwner() public view returns(address) {
        return owner;
    }
}