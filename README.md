gmqx-rel
========

The Release Project for EMQ X Broker.

NOTICE: Requires Erlang/OTP R21.0+ to build since EMQ X R3.0

Build on Linux/Unix/Mac
-----------------------

```
git clone -b X https://github.com/gmqx/gmqx-rel.git gmqx-rel
cd gmqx-rel && make
cd _rel/gmqx && ./bin/gmqx console
```

Build Docker Image
------------------

```
git clone -b X https://github.com/gmqx/gmqx-docker.git gmqx_docker
cd gmqx_docker && docker build -t gmqx:latest .
```

Build on Windows
----------------

Install Erlang/OTP-R21.0 and MSYS2-x86_64 for erlang.mk:

```
https://erlang.mk/guide/installation.html#_on_windows
```

Clone and build the EMQ X Broker with erlang.mk:

```
git clone -b X https://github.com/gmqx/gmqx-rel.git gmqx-rel
cd gmqx-rel
make
cd _rel\gmqx
bin\gmqx console
```

License
-------

Apache License Version 2.0

Author
------

EMQ X Team.
