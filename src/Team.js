import React, {Component} from 'react'


class Team extends Component {
    constructor(props) {
        super(props)
        this.state = {
            // for setting the team data
            teamName: '',
            top: '',
            jug: '',
            mid: '',
            adc: '',
            sup: '',
            // for setting the match against 2 teams
            team1: '',
            team2: ''
        }
    }
    handleInputChange = (event) => {
        this.setState({
            [event.target.name]: event.target.value,
        })
    }
    handleSetTeamClick = () => {
        const { teamName, top, jug, mid, adc, sup} = this.state;
        this.props.onSetTeam(teamName, top, jug, mid, adc, sup)
    }

    handleVsTeamClick = () => {
        const { team1, team2 } = this.state;
        this.props.vsTeam(team1, team2)
    }


    render() {
        if (this.props.ownerAddress !== this.props.account) {
            return (
                <div style={{textAlign:'center'}}>you are not the owner of this page.</div>
            )
        }   else {
            return (
                <div id='content' className='mt-3'>
                {/*input team data*/}
                <div className='input-group mb-4'>
                    <ul>
                        <input type='text' placeholder='team name' name = 'teamName' value = {this.state.teamName} onChange={this.handleInputChange} required></input>
                        <input type='text' placeholder='top' name = 'top' value = {this.state.top} onChange={this.handleInputChange} required></input>
                        <input type='text' placeholder='jug' name = 'jug' value = {this.state.jug} onChange={this.handleInputChange} required></input>
                        <input type='text' placeholder='mid' name = 'mid' value = {this.state.mid} onChange={this.handleInputChange} required></input>
                        <input type='text' placeholder='adc' name = 'adc' value = {this.state.adc} onChange={this.handleInputChange} required></input>
                        <input type='text' placeholder='sup' name = 'sup' value = {this.state.sup} onChange={this.handleInputChange} required></input>
                        <button type='setTeam' className='btn btn-primary btn-lg btn-block' onClick={this.handleSetTeamClick}>SET TEAM</button>
                    </ul>
                </div>
                {/*set the match for betting*/}
                <div>
                    <input type='text' placeholder='team1' name = 'team1' value = {this.state.team1} onChange={this.handleInputChange} required></input>
                    &nbsp;VS&nbsp;
                    <input type='text' placeholder='team2' name = 'team2' value = {this.state.team2} onChange={this.handleInputChange} required></input>
                    <br/>
                    <button type='vs' className='btn btn-primary btn-lg btn-block' onClick={this.handleVsTeamClick}>push match</button>
                </div>
            </div>
            )
        }
        
    }
}
export default Team;