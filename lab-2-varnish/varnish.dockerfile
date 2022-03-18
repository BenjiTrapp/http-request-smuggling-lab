FROM varnish
COPY conf/default.vcl /etc/varnish/default.vcl
EXPOSE 80