#!/bin/sh

# Older installations use the deprecated option "--rpcapi" so replace it by "--http.api"
export EXTRA_OPTS_PARSED=`echo -n $EXTRA_OPTS | sed s/--rpcapi/--http\.api/g`
export GETH_CMD="/usr/local/bin/geth --datadir /root/.ethereum/ethchain-geth --http --http.addr 0.0.0.0 --http.corsdomain "*" --http.vhosts "*" --ws --ws.origins "*" --ws.addr 0.0.0.0 --rpc.gascap 0 --cache 4096 $EXTRA_OPTS_PARSED"

echo "EXTRA_OPTS=$EXTRA_OPTS"
echo "EXTRA_OPTS_PARSED=$EXTRA_OPTS_PARSED"
echo "GETH_CMD=$GETH_CMD"

/usr/bin/supervisord -c /etc/supervisord.conf
