o = NetAddr.new("127.0.0.1", 6010);

// Change the three to any value you like

o.sendMsg("/ctrl", "slow",5); // from 2 to 6

o.sendMsg("/ctrl", "crusher", 3); // from 1 to 15

o.sendMsg("/ctrl", "cutoff", 10000); // from 400 to 15000

o.sendMsg("/ctrl", "offset", 0.5); // from 0 to 1



