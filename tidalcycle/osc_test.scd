//for send OSC TO TIDAL
o = NetAddr.new("127.0.0.1", 6010);

//trace every OSC calls
OSCFunc.trace(true)

OSCFunc.trace(false)


//useful, debug purpose
o.sendMsg("/ctrl", "slow",2); // from 2 to 6

o.sendMsg("/ctrl", "crusher", 3); // from 1 to 15

o.sendMsg("/ctrl", "cutoff", 15000); // from 400 to 15000

o.sendMsg("/ctrl", "offset", 0.5); // from 0 to 1




//for send OSC TO PYTHON SERVER
p = NetAddr.new("192.168.1.67", 9000);


// send cps (BPM) info to Processing
x = OSCFunc({ arg msg, time, addr, recvPort; p.sendMsg("/tidalcode", msg[2]); }, '/play2');
// get the cps and sent it  to Processing

x.free;    // remove the OSCFunc when you are done.


