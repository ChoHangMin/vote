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
                <p>teams : {this.props.teams}</p>
            </div>
        )
    }
}
export default Main;