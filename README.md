<img src="static/tag.png">

Ready to steal some treasures from Scrooge McDuck's Money Bin?

<p align="center">
<img width="300" src="static/fontaine.gif">
</p>

<img width="400" src="static/help.png">
<br>

Read carefully this [site](https://portswigger.net/web-security/request-smuggling) and finish the tutorial to undertand this vulnerability. This kind of attack is very tricky to understand, but totally awesome when you finally see it in action.


If you still feel lost you can peek into the `SOLUTION.md` file in each of the labs - if you find another path to the flag send me a Pull Request and tell the world how you achieved it.

To get the labs done you will require at least these things:
* Docker and Docker-Compose
* A tool to intercept traffic like: [Burp](https://portswigger.net/burp/communitydownload), [Hetty](https://github.com/dstotijn/hetty) or [OWASP ZAP](https://github.com/zaproxy/zaproxy)
* Your favorite Browser with debugging tools
* Terminal to run curl, netcat etc.
* An IDE with support for the language you like (Spoiler: I used bash and python. Go and Java should work as well)

<br>
<img width="150" src="static/disclaimer.png">
<br>

> The stuff in this repository is meant to be run only as CTF challenge. Do not use in production - use it in an isolated sandbox only. I'm not responsible for any damage caused by this code

<br>
<img width="330" src="static/learn.png">
<br>

* First at all: The technique behind HTTP request smuggling
* Stop using a Proxy as alternative to a Firewall and/or WAF - use it as an additional perimeter
* Don't trust your network blindly! Zero-Trust is hard to achieve but worth to iterate at it as an inspiration

<br>
<br>
<br>
<p align="center">
<img width="600" src="static/panzerknacker.png">
<br> Have fun and keep smuggling
</p>
