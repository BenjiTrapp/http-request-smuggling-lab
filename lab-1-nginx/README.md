<img src="../static/lab1.png">

This first lab is based on NGINX. Your mission is to access the hidden location placed at `/_hidden/index.html` and grab the flag.

<br>
<br>
<img width="220" src="../static/composition.png">
</p>

NGINX 1.17.6 - it's all that is required to train 
<br>
<br>

<img width="270" src="../static/build_check.png">

<br>

**Build**:
```bash
docker-compose up -d
```
<br>

**Check**:The NGINX Webserver will start on the port 9015. 

```bash
$ chmod +x check.sh;./check.sh | grep HTTP
HTTP/1.1 302 Moved Temporarily
```

If you can see the HTTP Code 302, everything is fine. 

<br>

<p align="center">
<img width="600" src="../static/this_is_fine.jpg">
</p>

<br>
<br>
<br>
<p align="center">
<img width="600" src="../static/enjoy.png">
</p>
