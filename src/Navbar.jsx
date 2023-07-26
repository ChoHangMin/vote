import React from 'react'

export default function Navbar({account}) {

        return (
            <nav className='navbar navbar-dark fixed-top shadow p-0 ' style={{backgroundColor: 'black', height:'100px'}}>
                <a style={{color:'white'}} href='https://github.com/Minkun00/vote'>VOTE FOR LEAGUE OF LEGEND CHAMPIONSHIP KOREA </a>
                <ul>
                    <ul style={{color:'white'}}>
                        Account Number: {account}<br/>
                    </ul>
                </ul>
            
            </nav>
        )
}
