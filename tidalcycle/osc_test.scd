o = NetAddr.new("127.0.0.1", 6010);

// Change the three to any value you like
o.sendMsg("/ctrl", "filter", 0.4);

o.sendMsg("/ctrl", "delay", 2);

o.sendMsg("/ctrl", "every", 2);

o.sendMsg("/ctrl", "pan", 2);



