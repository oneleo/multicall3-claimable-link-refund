source .env

forge script script/BatchRefund.s.sol:BatchRefundScript --broadcast -vvv --private-key ${RELAYER_PRIVATE_KEY} --rpc-url ${ARB_MAINNET_NODE_RPC_URL}
