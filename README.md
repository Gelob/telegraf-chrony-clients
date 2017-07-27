# telegraf-chrony-clients
grab total number of chrony clients for telegraf/influxdb

This is an exec script meant for [telegraf](https://github.com/influxdata/telegraf) in order to export the total number of clients that are communicating with chrony. It could be easily modified to POST directly to influxdb if you wanted.

You will need to give the telegraf user read access to /etc/chrony.keys (default) in order for it to be able to read the network key to contact chronyd as the clients command is not available over the UNIX socket. If you don't you'll see telegraf reporting 0 clients. The script also needs to be set as an executeable

`setfacl -m user:telegraf:r /etc/chrony.keys`

`chmod +x /opt/chronyclients.sh`

You can test that the telegraf user has proper access by running: `su -s /bin/bash -c '/opt/chronyclients.sh' telegraf`

Example telegraf.conf:
```yaml
[[inputs.exec]]
   commands = [ "/opt/chronyclients.sh" ]
   interval = "1m"
   timeout = "5s"
   data_format = "influx"
   ```
 Example bash output:
 ```bash
 [root@myserver ~]# /opt/chronyclients.sh
 chrony,host=myserver.mydomain.com clients=500
 ```
 Example telegraf output:
 ```bash
[root@myserver ~]# telegraf --config /etc/telegraf/telegraf.conf --input-filter exec --test
* Plugin: inputs.exec, Collection 1
* Internal: 1m0s
> chrony,host=myserver.mydomain.com clients=500 1501160403000000000
```
Example grafana influxdb query:

`SELECT "clients" FROM "chrony" WHERE "host" =~ /^$host$/ AND $timeFilter GROUP BY "host"`
