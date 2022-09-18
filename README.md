# Zondocker

This is a WIP. Since there are still parts that have not been fully configured, such as where to mount the data, I hope that you will refer only to the Zond build part.

## 1. Install requirements

[Docker Desktop](https://www.docker.com/products/docker-desktop/) needs to be installed on Windows to run docker commands.


## 2. Docker build
```ps
docker image build -t zondocker:version .
```

## 2. Docker run

```ps
docker run -it zondocker:version /bin/bash
```

## 3. Run Zond node
```ps
cd ~/zond
./gzond
```

For more information on Zond node documentation, please refer to the [official documentation](https://zond-docs.theqrl.org)