#!/bin/sh

# Older installations use the deprecated option "--rpcapi" so replace it by "--http.api"
export EXTRA_OPTS_PARSED=$(echo -n $EXTRA_OPTS | sed s/--rpcapi/--http\.api/g)

# Get JWT Token
JWT_TOKEN="/root/.ethereum/ethchain-geth/geth/jwttoken"
mkdir -p $(dirname ${JWT_TOKEN})
until $(curl --silent --fail "http://dappmanager.my.ava.do/jwttoken.txt" --output "${JWT_TOKEN}"); do
  echo "Waiting for the JWT Token"
  sleep 5
done

export GETH_CMD="/usr/local/bin/geth \
    --datadir /root/.ethereum/ethchain-geth\
    --mainnet \
    --http \
    --http.addr=\"0.0.0.0\" \
    --http.corsdomain=\"*\" \
    --http.vhosts=\"*\" \
    --ws \
    --ws.origins=\"*\" \
    --ws.addr=\"0.0.0.0\" \
    --authrpc.vhosts=\"*\" \
    --authrpc.addr=\"0.0.0.0\" \
    --authrpc.port=\"8551\" \
    --authrpc.jwtsecret=\"${JWT_TOKEN}\" \
    --rpc.gascap 0 \
    ${EXTRA_OPTS_PARSED}"

echo "EXTRA_OPTS=$EXTRA_OPTS_PARSED"
echo "GETH_CMD=$GETH_CMD"

# Print version to the log
/usr/local/bin/geth version

# Start supervisor
# (using exec: https://madflojo.medium.com/shutdown-signals-with-docker-entry-point-scripts-5e560f4e2d45)
exec /usr/bin/supervisord -c /etc/supervisord.conf
