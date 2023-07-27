# Vote for lck teams by solidity
의도 : lck대회의 승패를 token으로 베팅하기  
contracts >> src/contracts/  
> Token.sol : 투표를 위한 토큰 발행  
> SetTeam.sol : 투표할 팀 설정 및 확인  
> Vote.sol : 투표 실행  


compiled contracts >> src/truffle_abis  
> truffle compile을 통해 생성된 .json파일들  
> Token.json  
> SetTeam.json  
> Vote.json  
   
React를 위한 파일들 >> src/  
> App.js : compiled contracts들을 가지고 실행  
> Navbar.js, Main.js등 포함

실행 준비 과정  
> 1. truffle(vscode ver), ganache 다운로드
> 2. ganache에 truffle-config.js연결
> 3. metamask에 ganache 연결, 계좌 연결(0(owner용도), 1(user용도)번 계좌)
> 4. terminal에서 ```npm i``` 실행(package.json에 해당하는 node_modules 다운받기)
> 5. npm run start로 실행

## 간단한 설명(2023.07.27)
### contract(src/contracts/)

|Token.sol|설명|
|---|---|
|struct User|user 데이터(balance, voted, teamIndex, voteBalance)|    
|mapping(address => user) userData|address로 struct User접근|  
|mapping(address => bool) registeredUsers|for logIn(default - false)|  
|balanceOf( )|잔액 반환|  
|voteBalanceOf( )| voteBalance 반환|
|getUserVotedTeamIndex( )| teamIndex(user가 투표한 팀의 index) 반환|  
|logIn( )|처음 접속 시 token 지급, registeredUsers -> true|  
|giveRightToVote( )|처음 접속 시, 투표 불가능. owner허락으로 투표 가능함|  
|showOwner( )|owner 주소 표시(react 연습용)|<br>
<br>

|SetTeam.sol|설명|
|---|---|
|struct Team| team 데이터(teamName, position별 5인(string))<br>Team[ ] public teams|
|mapping(uint => uint) public teamWeight|teamIndex로 teamWeight 접근|
|winnerTeamIndex|이긴 팀의 index. Vote.sol에서 배당금 분배시 사용될예정|
|winnerTeamTotalBalance|비율에 따라서 Balance 반환하기 위한 계산용 변수|
|modifier onlyOwner|owner이어야만 허락|
|setTeam( )|team list 추가(onlyOwner)|
|getTeamIndexByTeamName( )|teamName 입력받고, list에 해당하는 index return|
|getTeamDataByTeamName( )|teamName 입력받고, 해당하는 team의 데이터 return|
|getTeamWeightByTeamName( )|teamName 입력받고, 해당하는 team에 베팅된 돈의 양 return|	
<br>

|Vote.sol|설명|
|---|---|
|vote( )|_amount, _teamName입력받고 베팅. team.weigth 업데이트 <br> userData[msg.sender].voted를통해서 다른 팀에 베팅했는지 확인|
|gameEnd( )|결과 나오면 실행. 진팀 weight -> 이긴팀 weight<br> winnerTeamIndex 업데이트(onlyOwner)|
|returnBettingResult( )|user가 각자 실행. <br> 자기가 배팅한 금액에 따라 이긴팀 weight 분배받음|
|returnBettingResultOver( )|일정 시간 지난 시점에서 실행. 새로운 게임을 설정하기 위해서 변수들 초기화.|

### python(src/python/)
selenium으로 대회 일정 있는 [사이트](https://game.naver.com/esports/League_of_Legends/schedule/lck)를 크롤링 -> json파일로 데이터를 받아오게 함(chromedriver 필요)<br>
-> LCK_MATCH.json으로 저장됨
## 실행 과정
1. logIn -> owner가 giveRightToVote 실행(베팅 가능)<br>
2. owner가 setTeam으로 팀 데이터 업로드<br>
3. UI <- getTeamDataByTeamName( )으로 표시<br>
4. user가 vote( ) 실행 <br>
5. owner가 gameEnd( ) 실행<br>
6. user가 returnBettingResult( ) 실행<br>
7. 일정 시간 이후, owner가 returnBettingResultOver( ) 실행 <br>

## 아쉬운 점
1. 보통 하루에 2개의 경기가 있는데, vote가 한번하고 돈을 받을 때까지 베팅을 못하기에 여러 게임을 투표할 방법이 없음(고치자면 고치겠지만 아직은 고려대상이 아님)<br>
2. gas비를 줄일 방법이 더 있겠지만, 조금 더 확인이 필요할 것으로 보임