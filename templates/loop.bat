for /L %%x IN () DO (curl 10.0.2.4
echo:
curl 10.0.2.5
echo:
curl 10.0.2.6
echo:
echo "this machine's ip address is "
curl https://ipconfig.io/ip
echo:
timeout /t 5) 