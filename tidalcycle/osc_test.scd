o = NetAddr.new("127.0.0.1", 6010);

// Change the three to any value you like
o.sendMsg("/ctrl", "user1", 0.4);

o.sendMsg("/ctrl", "user2", 1);

o.sendMsg("/ctrl", "user3", 2);

o.sendMsg("/ctrl", "user4", 4);

