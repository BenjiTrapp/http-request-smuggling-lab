<img width="1300" src="static/../../static/lab2.png">
<br>
<br>

Can't get enough? Want to learn some more fancy things? How's about tricking a Varnish Cache? This scenario helps to understand how you could reach a hidden website f.e. an Intranet webserver with internal information. Pretty sneaky right? 

Now to your goal: To get the flag at the internal network `flask.net` you need to open `/flag`. Obviously you can't access the `/flag` from the outer apache `apache.net` network. As a valuable hint you might need to investiage `socket.io` in the requests and watch out for `html` stuff. It really help to use `Burp` or another attack proxy to time your attack and investiage the target. 

To achive the flag - you probably need to write some code this time :)


<p align="center">
<img width="300" src="../static/sad.gif">
</p>

<img width="200" src="static/../../static/composition.png">

The setup of this challenge is based on three components:
1. Varnis cache to accelerate the routing between the webservices
2. Apache Webserver running at `apache.net` - this mimes a regular public website of a company
3. Flask Webserver running at `flask.net` - the target that we want to access to get valuable internal information


<p align="center">
<img width="600" src="img/architecture.png">
</p>

<br>
<br>
<img width="300" src="static/../../static/build_check.png">
<br>
<br>

To build simply run: 

```bash
docker-compose up
```

The varnish server will on the port 9020. To check if everything works visit http://localhost:9020/. After accessing the site, you will see this:

<p align="center">
<img width="600" src="img/img1.png">
</p>

This means everything is fine

By visiting http://localhost:9020/websocket.html, you will see a websocket example.

<p align="center">
<img width="600" src="img/img2.png">
</p>

# Since this challenge is hard to tackle:

<p align="center">
<img width="600" src="img/dangerous_alone.png">
</p>

The WebSocket communication consists of two parts: 
* handshake 
* data transfer

Like always, as a first step the TCP or TLS connection needs to be established with the backend. Next the handshake will be performed over the established connection. In the final step the WebSocket frames will be **transferred through the same TCP or TLS connection**. 

As a real hacker it's time to read how the WebSocket protocol is described in [RFC 6455](https://tools.ietf.org/html/rfc6455).

Let us inspect the handshake part which is performed over the HTTP protocol version 1.1 (as it is described in RFC 6455). The Client sends a GET request (aka **Upgrade request**) to the backend with the set of special HTTP headers. These are typically: `Upgrade`, `Sec-WebSocket-Version` and `Sec-WebSocket-Key`.

Such a request can look like this:

```yaml
GET /socket.io/?EIO=3&transport=websocket HTTP/1.1
Host: websocket.example.com
Sec-WebSocket-Version: 13
Origin: http://websocket.example.com
Sec-WebSocket-Key: U2Nyb29nZSBNY0R1Y2s6IEkgTWFkZSBpdCBieSBiZWluZyB0b3VnaGVyIHRoZW4gdGhlIHRvdWdoaWVzLCBhbmQgc21hcnRlciB0aGVuIHRoZSBzbWFydGllcyEgQW5kIEkgbWFkZSBpdCBTUVVBUkUK
Connection: keep-alive, Upgrade
Pragma: no-cache
Cache-Control: no-cache
Upgrade: websocket
```

Now let's dissect the most important Headers from the request above:
* `Sec-WebSocket-Version` contains WebSocket protocol version (most of the times only version `13` is supported)
* `Sec-WebSocket-Key` contains usually a random nonce that is base64 encoded
* `Upgrade` header contain value `websocket`

Most of the time a Backend should respond with HTTP status code `101` and acknowledge the nonce which was sent by the client. The Backend should compute a value to confirm the request by using the nonce from client and is sent back to the client inside the `Sec-WebSocket-Accept` HTTP Header.

```yaml
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: xUFfT1/AIvZnGdK/XSbIr7zQO10=
```

After performing a successfull handshake, the client or backend can transfer data using WebSocket frames. Intressting to know is that there are multipe kinds of frames. Each frame has a field `opcode` which tells more about its type.

As a picture this would look like this:

<p align="center">
<img width="600" src="img/smuggling-highlevel.png">
</p>

If we mediate about this architecture diagram we can see that this setup is pretty common regarding regular business web applications. The client has to communicate with a (public) backend through a reverse proxy. The green box can be abstracted as a corporate network. Usually most of the web servers, load balancer, HTTP proxies allow to proxy WebSocket traffic.

Now let us bring this WebSocket Communication into a flow:
1. The Client sends an `Upgrade` request to the reverse proxy. The reverse proxy checks the HTTP method and the different Headers: `Upgrade`, `Sec-WebSocket-Verson` and usually the presence of `Sec-WebSocket-Key`and more if present. If the request was performed correctly, the Proxy will forword the `Upgrade` request of the client to the backend
2. The Backend answers to the reverse proxy with a HTTP response (and status code 101). This Response has the `Upgrade`and `Sec-WebSocket-Accept` headers set. The reverse proxy will validate the corectness and propagate the response from the backend to the client
3. The reverse proxy doesn't close the TCP/TLS connection between the client and the backend since both agreed to use this connection for WebSocket communication. If this point is reached - the client and backend can send WebSocket data frames back and forth. The only duty of the reverse proxy now is to check, that the client sends masked WebSocket frames.

Where to attack now? After performing a valid request to the public backend we can send the malicious request piggybacked to the internal network and access things that should be hidden from your eyes. 

When ever you build something with WebSockets: **It's important that a client must perform a client-to-server masking!** Masking is done to mitigate potential attacks on the infrastructure, that proxies the WebSocket connections between client and backend. As pointed in RFC 6455, there was a [research](http://www.adambarth.com/papers/2011/huang-chen-barth-rescorla-jackson.pdf) done that showed a proof for cache poisoning attacks against proxies in case the client doesn't perform a client-to-server masking. This will also lead to a possible successful HTTP smuggling attack.

Wrapping up and concentrate the info about masking:
* Masking key is 32bit long and passed inside a data frame
* As shown above - the client must send the masked data
* MASKED = MASK xor DATA
* As told above usefull against cache poisoning and http smuggling attacks


<br>
<br>
<br>
<p align="center">
<img width="600" src="../static/enjoy.png">
</p>

