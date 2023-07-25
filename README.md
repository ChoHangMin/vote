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
실행화면 1 (https://localhost:3000, log in 버튼 누른 상태임)  
![image](https://github.com/Minkun00/LCK_vote/assets/139968456/62421c6f-0b71-4640-82a1-a952fa18cccd)  
실행화면 2 (http://localhost:3000/owner)  
![image](https://github.com/Minkun00/LCK_vote/assets/139968456/f9a15072-3acc-449e-9426-5f6f74f38704)




## 간단한 설명(2023.07.25)
### contract

>|Token.sol|설명|
>|---|---|
>|struct User|user 데이터(balance, firstEnter, voted)|    
>|mapping(address => user) userData|address로 struct User접근|  
>|mapping(address => bool) registeredUsers|for logIn(default - false)|  
>|balanceOf( )|잔액 반환|  
>|voteBalanceOf( )| voteBalance 반환|
>|getUserVotedTeamIndex( )| teamIndex(user가 투표한 팀의 index) 반환|  
>|logIn( )|처음 접속 시 token 지급, registeredUsers -> true|  
>|giveRightToVote( )|처음 접속 시, 투표 불가능. owner허락으로 투표 가능함|  
>|showOwner( )|owner 주소 표시(react 연습용)|<br>
<br>

>|SetTeam.sol|설명|
>|---|---|
>|struct Team| team 데이터(teamName, position별 5인(string))<br>Team[ ] public teams|
>|mapping(uint => uint) public teamWeight|teamIndex로 teamWeight 접근|
>|winnerTeamIndex|이긴 팀의 index. Vote.sol에서 배당금 분배시 사용될예정|
>|winnerTeamTotalBalance|비율에 따라서 Balance 반환하기 위한 계산용 변수|
>|modifier onlyOwner|owner이어야만 허락|
>|setTeam( )|team list 추가(onlyOwner)|
>|getTeamIndexByTeamName( )|teamName 입력받고, list에 해당하는 index return|
>|getTeamDataByTeamName( )|teamName 입력받고, 해당하는 team의 데이터 return|	
<br>

>|Vote.sol|설명|
>|---|---|
>|vote( )|_amount, _teamName입력받고 베팅. team.weigth 업데이트 <br> userData[msg.sender].voted를통해서 다른 팀에 베팅했는지 확인|
>|gameEnd( )|결과 나오면 실행. 진팀 weight -> 이긴팀 weight<br> winnerTeamIndex 업데이트(onlyOwner)|
>|returnBettingResult( )|user가 각자 실행. <br> 자기가 배팅한 금액에 따라 이긴팀 weight 분배받음|

## 구조 
1. logIn -> owner가 giveRightToVote 실행(베팅 가능)<br>
2. owner가 setTeam으로 팀 데이터 업로드<br>
3. UI <- getTeamDataByTeamName()으로 표시<br>
4. user가 vote() 실행. <br>