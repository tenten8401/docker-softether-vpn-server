# Lightweight [SoftEther VPN](https://github.com/SoftEtherVPN/SoftEtherVPN) Server

This docker only contains a working **SoftEther VPN Server**. Other components have been removed.
___

# What is SoftEther VPN Server
> SoftEther VPN ("SoftEther" means "Software Ethernet") is one of the world's most powerful and easy-to-use multi-protocol VPN software. It runs on Windows, Linux, Mac, FreeBSD and Solaris.

> SoftEther VPN is open source. You can use SoftEther for any personal or commercial use for free charge.

>SoftEther VPN is an optimum alternative to OpenVPN and Microsoft's VPN servers. SoftEther VPN has a clone-function of OpenVPN Server. You can integrate from OpenVPN to SoftEther VPN smoothly. SoftEther VPN is faster than OpenVPN. SoftEther VPN also supports Microsoft SSTP VPN for Windows Vista / 7 / 8. No more need to pay expensive charges for Windows Server license for Remote-Access VPN function.

>SoftEther VPN can be used to realize BYOD (Bring your own device) on your business. If you have smartphones, tablets or laptop PCs, SoftEther VPN's L2TP/IPsec server function will help you to establish a remote-access VPN from your local network. SoftEther VPN's L2TP VPN Server has strong compatible with Windows, Mac, iOS and Android.

[SoftEther Website](https://www.softether.org/)

# About this image
This image is make'd from [the official SoftEther VPN GitHub Repository](https://github.com/SoftEtherVPN/SoftEtherVPN).

Nothing else have been edited. So when you will start it the first time you will get the default configuration which is:
* **/!\ Administration without any password /!\**
* Server listenning on 443/tcp, 992/tcp, 1194/tcp+udp, tcp/5555
* A Virtual hub named "HUB" Without any user and SecureNAT off
* Connection on 443/tcp, 992/tcp, 1194/tcp, 5555/tcp with SoftEther VPN Protocol
* Connection on 1194/udp, 443/tcp, 992/tcp, 1194/tcp, 5555/tcp with OpenVPN Protocol
* MS-SSTP Connection
* Dynamic DNS

You will have to configure it. To do so use the [SoftEther VPN Server Manager][http://softether-download.com] (Windows, Mac OS X, or Linux w/ Wine)
You can alo edit `vpn_server.config` by hand then restart the server (Not Recommended)

# How to use this image
For auto-restarting with config persistance (Recommended):
```
docker run --restart=always -d --cap-add NET_ADMIN --name softether-vpn-server -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp -v softether-config:/etc/vpnserver:Z -v softether-logs:/var/log/vpnserver:Z tenten8401/softether-vpn-server
```
Add/remove any ```-p $PORT:$PORT/{tcp,udp}``` depending on your will.

For use without persistance (Not Recommended):
```
docker run -d --cap-add NET_ADMIN --name softether-vpn-server -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp tenten8401/softether-vpn-server
```