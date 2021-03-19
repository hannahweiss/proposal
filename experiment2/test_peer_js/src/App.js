import {join, connect} from './call'
import {useState} from 'react'
import './App.css'

function Call() {
    // List of <media streams>
    const [calls, setCalls] = useState([])
    function join_call() {
        connect().then((peers) => {
            join(peers, setCalls) 
        })
    }
    return (
    <div>
        <button onClick={join_call}> Join </button>
        {calls.map((c, i) => (<div key={`user_${i}`}> 
            <audio controls autoPlay={true} ref={audio => {if (audio) audio.srcObject = c}}/> 
            User {i}
        </div>)) }
    </ div>
    )
}

function App() {
  return (
    <div className="App">
        <Call />
    </div>
  );
}

export default App;
