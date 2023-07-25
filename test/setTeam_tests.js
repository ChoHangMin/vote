const Token = artifacts.require("Token");
const SetTeam = artifacts.require("SetTeam");
const Vote = artifacts.require("Vote");
const fs = require('fs');

module.exports = async function (deployer, network, accounts) {
  // 배포 시작
  await deployer.deploy(Token);
  const tokenInstance = await Token.deployed();

  await deployer.deploy(SetTeam, { from: accounts[0] }); // SetTeam 컨트랙트를 배포하고 첫 번째 계정으로 소유권 설정
  const setTeamInstance = await SetTeam.deployed();

  await deployer.deploy(Vote, { from: accounts[0] }); // Vote 컨트랙트를 배포하고 첫 번째 계정으로 소유권 설정
  const voteInstance = await Vote.deployed();

  // Vote 컨트랙트에 Token 컨트랙트와 SetTeam 컨트랙트 주소 연결
  await voteInstance.setTokenContractAddress(tokenInstance.address);
  await voteInstance.setSetTeamContractAddress(setTeamInstance.address);

  // JSON 파일 읽기
  fs.readFile('../lck_json/lck.json', 'utf8', async (err, data) => {
    if (err) {
      console.error('Error reading the file:', err);
      return;
    }

    try {
      // Parse JSON data
      const lckData = JSON.parse(data);
      const teams = lckData.data;

      // Loop through each team and call the setTeam function
      Object.keys(teams).forEach(async (teamName) => {
        const teamInfo = teams[teamName];
        const _team = [
          teamName,
          teamInfo.top,
          teamInfo.jug,
          teamInfo.mid,
          teamInfo.bot,
          teamInfo.spt,
        ];

        // Call the setTeam function here
        await setTeamInstance.setTeam(_team, { from: accounts[0] });
      });

      console.log('All teams have been set.');

    } catch (error) {
      console.error('Error parsing JSON data:', error);
    }
  });
};
