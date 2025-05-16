#!/bin/bash

# Load environment variables
source .env

# Run the simulation (dry-run) of the script
echo "[INFO] Running dry-run..."
forge script script/BatchRefund.s.sol:BatchRefundScript -vvv --private-key ${RELAYER_PRIVATE_KEY} --rpc-url ${ARB_MAINNET_NODE_RPC_URL}

# If the simulation succeeds, broadcast the transaction (requires sufficient funds)
if [ $? -eq 0 ]; then
        echo "[INFO] Dry-run succeeded. Broadcasting transaction..."
        forge script script/BatchRefund.s.sol:BatchRefundScript --broadcast -vvv --private-key ${RELAYER_PRIVATE_KEY} --rpc-url ${ARB_MAINNET_NODE_RPC_URL}
else
        echo "[ERROR] Dry-run failed. Broadcast skipped."
fi
