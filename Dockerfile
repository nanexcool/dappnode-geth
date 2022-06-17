ARG UPSTREAM_VERSION

FROM ethereum/client-go:${UPSTREAM_VERSION}

ENTRYPOINT geth --http --http.addr 0.0.0.0 --http.corsdomain "*" --http.vhosts "*" --syncmode ${SYNCMODE:-snap} --metrics --metrics.addr 0.0.0.0 $EXTRA_OPTIONS