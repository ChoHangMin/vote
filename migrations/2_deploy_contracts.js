const Token = artifacts.require("Token");
const SetTeam = artifacts.require("SetTeam");
const Vote = artifacts.require("Vote");

module.exports = async function (deployer, network, accounts) {
  // deploy
  await deployer.deploy(Token);
  await deployer.deploy(SetTeam, { from: accounts[0] }); // owner = accounts[0]
  await deployer.deploy(Vote, { from: accounts[0] }); // owner = accounts[0]
};
