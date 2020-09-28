FROM ethereum/client-go:v1.9.14

ENTRYPOINT geth --datadir /root/.ethereum/ethchain-geth --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "*" --rpcvhosts "*" --ws --wsorigins "*" --wsaddr 0.0.0.0 $EXTRA_OPTS
