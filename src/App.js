import './App.css'
import React, { Component } from 'react'
import Web3 from 'web3'
// import compiled smart contract 
import Token from './truffle_abis/Token.json'
import SetTeam from './truffle_abis/SetTeam.json'
import Vote from './truffle_abis/Vote.json'
// import Navbar
import Navbar from './Navbar'
// import Main(buttons are here)
import Main from './Main.js'
// import Team(only owner can use this)
import Team from './Team.js'
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom' // Update the alias for BrowserRouter as Router

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3()
    await this.loadContracts()
  }

  // load metamask address
  async loadWeb3() {
    if(window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('No ethereum browser detected!')
    }
  }
  
  // load smart contracts(Token, SetTeam, Vote)
  async loadContracts() {
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts()
    this.setState({account: accounts[0]})
    const networkId = await web3.eth.net.getId()

    // load Token.sol
    const tokenData = Token.networks[networkId]
    if(tokenData) {
      // get Token contract code
      const token = new web3.eth.Contract(Token.abi, tokenData.address)
      this.setState({token})
      // get token Balance(calls by function: balanceOf())
      let tokenBalance = await token.methods.balanceOf(this.state.account).call()
      this.setState({tokenBalance: tokenBalance.toString()})
      let ownerAddress = await token.methods.showOwner().call();
      this.setState({ownerAddress})
    } else {  // if not detected
      window.alert("Token contract not deployed to detect network!")
    }

    const setTeamData = SetTeam.networks[networkId]
    if(setTeamData) {
      // get SetTeam contract code
      const setTeam = new web3.eth.Contract(SetTeam.abi, setTeamData.address)
      this.setState({setTeam})
    } else {  // if not detected
      window.alert("SetTeam contract not deployed to detect network!")
    }

    const voteData = Vote.networks[networkId]
    if(voteData) {
      // get Vote contract code
      const vote = new web3.eth.Contract(Vote.abi, voteData.address)
      this.setState({vote})
    } else {  // if not detected
      window.alert("Vote contract not deployed to detect network!")
    }
  }
  

  // function Token.sol -> logIn() 
  LogIn_ = async () => {
    const {token, account} = this.state;
    try {
      await token.methods.logIn().send({from: account})
    } catch(error) {
      if (error.code === 4001) {
        window.alert("User denied the transaction. Maybe you have logined alredy")
      } else {
        window.alert("Already Login")
      }
    }
  }
  ShowOwner_ = async () => {
    window.alert(String(this.state.ownerAddress))
  }

  // function SetTeam.sol -> function setTeam
  // (string memory _teamName, string memory _top, string memory _jug, string memory _mid, string memory _adc, string memory _sup) 
  // public onlyOwner
  handleSetTeam_ = async(teamName, top, jug, mid, adc, sup) => {
    const {setTeam, account} = this.state;
    try {
      await setTeam.methods.setTeam(teamName, top, jug, mid, adc, sup).send({ from: account });
      let team1Index = await setTeam.methods.getTeam(teamName).call();

      // Get team data from teams array using the retrieved index
      let teamData = this.state.teams[team1Index];

      // Create a new team object with the updated weight and other data
      let updatedTeam = { ...teamData, top, jug, mid, adc, sup };
      let updatedTeams = [...this.state.teams];
      updatedTeams[team1Index] = updatedTeam;

      this.setState({ teams: updatedTeams });
      console.log(teamName);
      console.log(top);
      console.log(jug);
      console.log(mid);
      console.log(adc);
      console.log(sup);
      window.alert('저장되었습니다.');
    } catch(error) {
      window.alert("Only owner can use this. check the owner address")
    }
  }
  vsTeam_ = async (team1, team2) => {
    const { setTeam } = this.state;
    try {
      let team1Index = await setTeam.methods.getTeam(team1).call();
      let team2Index = await setTeam.methods.getTeam(team2).call();
  
      // Get team data from teams array using the retrieved indices
      let team1Data = this.state.teams[team1Index];
      let team2Data = this.state.teams[team2Index];
  
      this.setState({ team1: team1Data, team2: team2Data });
    } catch (error) {
      window.alert(`${team1} 또는 ${team2}가 블록체인에 존재하지 않습니다!`);
    }
  };

  constructor(props) {
    super(props)
    this.state = {
      ownerAddress: '',
      account: '0x0',   // user`s actual address
      vote: {},         // contract of the Vote.sol
      setTeam: {},      // contract of the SetTeam.sol
      token: {},        // contract of the Token.sol
      tokenBalance: '0',// token Balance
      teams: [],        // initialize teams array
      team1: {},        // Data of the team #1
      team2: {}         // Data of the team #2
    }
  }
  render() {
    return (
      <Router>
        <div className='App'>
          <Navbar account={this.state.account} />
          <div className='container-fluid mt-5'>
            <div className='row'>
              <main
                role='main'
                className='col-lg-12 ml-auto mr-auto'
                style={{ maxWidth: '600px', minHeight: '100vm' }}>
                    
                <Routes>
                  {/* Main 컴포넌트의 경로 */}
                  <Route 
                  path='/' 
                  element={<Main tokenBalance={this.state.tokenBalance} 
                                LogIn={this.LogIn_}
                                teams={this.state.teams}
                                team1={this.state.team1}
                                team2={this.state.team2}/>} />

                  {/* Team 컴포넌트의 경로 */}
                  <Route
                    path='/owner'
                    element={<Team ownerAddress={this.state.ownerAddress} 
                                  account={this.state.account} 
                                  onSetTeam={this.handleSetTeam_}
                                  vsTeam={this.vsTeam_}/>}/>
                </Routes>

              </main>
            </div>
          </div>
          <button onClick={this.ShowOwner_}>Show Owner</button>&nbsp;&nbsp;
          <Link to='/owner'>팀 페이지로 이동(Owner만 사용 가능)</Link>
        </div>
      </Router>
    )
  }
}

export default App;
