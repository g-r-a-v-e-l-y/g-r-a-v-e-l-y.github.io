---
title: ESMTP humor?
date: 2004-02-25 11:52:00.00 -8
categories: geeky
---
Ok, more geek shit, from ~2 seconds of a real Exim log this time:

```
x:x:13 SMTP connection from [221.232.74.44]:2373 (TCP/IP connection count = 1)
x:x:13 SMTP syntax error in "GET http://hpcgi1.nifty.com/trino/ProxyJ/prxjdg.cgi HTTP/1.0" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP syntax error in "Accept: */*" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP syntax error in "Accept-Language: en-us" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP syntax error in "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP syntax error in "Host: hpcgi1.nifty.com" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP syntax error in "Connection: Keep-Alive" H=[221.232.74.44]:2373 unrecognized command
x:x:13 SMTP call from [221.232.74.44]:2373 dropped: too many unrecognized commands
x:x:14 SMTP connection from [221.232.74.44]:2394 (TCP/IP connection count = 1)
x:x:14 SMTP connection from [221.232.74.44]:2394 lost (error: Connection reset by peer)
x:x:15 SMTP connection from [221.232.74.44]:2409 (TCP/IP connection count = 1)
x:x:15 SMTP connection from [221.232.74.44]:2409 lost (error: Connection reset by peer)
```

**GET** is an http command. SMTP is how mail is sent, it is not how web sites are served. People rarely go to the post office and scream GIVE ME A BIG MAC AND A LARGE SHAKE into their p.o. boxes. Well, most people.

It looks to me like the spammer is looking for open proxies on any port that will accept a connection and logging their existance at [http://hpcgi1.nifty.com/trino/ProxyJ/prxjdg.cgi?en](http://hpcgi1.nifty.com/trino/ProxyJ/prxjdg.cgi?en)

Isn't it annoying how computers make repetitive otherwise unsurmountable tasks mindlessly trivial? Ah, irony.