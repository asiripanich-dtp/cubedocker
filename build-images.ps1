echo "Start building images"
docker build -f .\Dockerfile.CubeOffline . -t cubebase
docker build -f .\Dockerfile.CubePy3 . -t cubepy3
