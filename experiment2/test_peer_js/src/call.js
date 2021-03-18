import Peer from 'peerjs';

let peer = new Peer(''+Math.floor(Math.random()*2**18).toString(36).padStart(4,0), {
    host: "localhost",
    port: 4000,
    debug: 1,
    path: '/myapp'
});
let callers = []
let setter = null
let local_stream = null;

export function join(peer_ids, setCallers) {
    setter = setCallers
    callers = []
    setter(callers)
    let calls = peer_ids.map((p) => {
        peer.connect(p);
        return peer.call(p, local_stream)
    })
    calls.forEach((call) => call.on('stream', (remoteStream) => {
        console.log(remoteStream);
        callers = [...callers, remoteStream]
        setter(callers)
    }))
}

peer.on('call', (call) => {
    call.answer(local_stream)
    call.on('stream', (remoteStream) => {
        callers = [...callers, remoteStream]
        setter(callers)
        console.log(callers)
    })
})

export async function connect() {
    let resp = await fetch("http://localhost:4000/connect/" + peer.id, {})
    let body = await resp.json()
    local_stream = await navigator.mediaDevices.getUserMedia({video: false, audio: true});
    return body
}
