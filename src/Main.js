// Main.js
import React, {Component} from 'react'

class Main extends Component {
    // every constructor of the file is restricted


    render() {
        return (
            <div id='content' className='mt-3'>
                <table className='table text-muted text-center'>
                    <thread>
                        <tr style={{color:"black"}}>
                            <th scope='col'>Token Balance: {this.props.tokenBalance}</th>
                        </tr>
                    </thread>
                </table>
                <div className='card mb-2' style={{opaacity: '.9'}}>
                    <form className='mb-3'>
                        <div className='input-group mb-4'>
                            <input type='text' placeholder='0' required>
                            </input>
                        </div>
                        <button type='submit' className='btn btn-primary btn-lg btn-block'>VOTE</button>
                    </form>
                </div>
                    <button type='login' className='btn btn-primary btn-lg btn-block' onClick={this.props.LogIn}>LOG IN</button>
                <div className="row">
                    <div className="col">
                        {this.props.team1 && this.props.team1.length > 0 ? (
                        <p>
                            <ul>
                                <li>teamname: {this.props.team1[0]}</li>
                                <li>top: {this.props.team1[1]}</li>
                                <li>jug: {this.props.team1[2]}</li>
                                <li>mid: {this.props.team1[3]}</li>
                                <li>adc: {this.props.team1[4]}</li>
                                <li>sup: {this.props.team1[5]}</li>
                            </ul>
                        </p>
                        ) : null}
                    </div>
                    <div className="col">
                        {this.props.team2 && this.props.team2.length > 0 ? (
                        <p>
                            <ul>
                            <li>teamname: {this.props.team2[0]}</li>
                            <li>top: {this.props.team2[1]}</li>
                            <li>jug: {this.props.team2[2]}</li>
                            <li>mid: {this.props.team2[3]}</li>
                            <li>adc: {this.props.team2[4]}</li>
                            <li>sup: {this.props.team2[5]}</li>
                            </ul>
                        </p>
                        ) : null}
                    </div>
                </div>
            </div>
        )
    }
}   
export default Main;