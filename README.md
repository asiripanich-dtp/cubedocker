# How to create a CUBE Docker image?

Build the image and run it

```
docker build -f Dockerfile.CubeOffline -t cube651
docker run --rm -it  cube651:latest
```

Once inside the image, login to the connection client with your bentley account using the provided powershell script
```
powershell
./conn_client_logon_script.ps1 "username" "password"
```

Test that CUBE 6.5.1 works
```
runtpp.exe test.S
```

# Acknowledgement

A huge thank you to Filippo Contiero for coordinating the efforts to make this work! ( ͡~ ͜ʖ ͡°) 