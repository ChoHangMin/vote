import React, {Component} from 'react'

class Navbar extends Component {
    render() {
        return (
            <nav className='navbar navbar-dark fixed-top shadow p-0' style={{backgroundColor: 'black', height:'100px'}}>
                <a style={{color:'white'}} href='https://github.com/Minkun00/LCK_vote'>VOTE FOR LEAGUE OF LEGEND CHAMPIONSHIP KOREA </a>
                <ul>
                    <ul style={{color:'white'}}>
                        Account Number: {this.props.account}<br/>
                    </ul>
                </ul>

            </nav>
        )
    }
}

export default Navbar;