# Batch Refund Tool

This repository helps a specific [giver](https://www.arbiscan.io/address/0x1234A72239ecbA742D9A00C6Bec87b5a4ABF481a) refund unclaimed [USDC](https://www.arbiscan.io/address/0xaf88d065e77c8cC2239327C5EDb3A432268e5831) from the [ClaimableLink](https://www.arbiscan.io/address/0x79EE808918cc91Cca19454206dc7027e4fa4A473) contract on Arbitrum One.

## Environment Setup

- Copy the example file and edit:

```bash
$ cp .env.example .env
```

- Set the following variables in `.env`:

```env
RELAYER_PRIVATE_KEY=0x
ALCHEMY_API_KEY=
```

## Run Local Fork Test

- Simulates a batch refund of 168 expired deposit notes on a forked Arbitrum network.
- After execution, the giver should receive the total USDC from these notes.

```bash
$ forge install
$ forge test -vvv
```

## Execute Batch Refund Script

- Ensure the relayer wallet has some ETH for gas.
- After running, verify that the giver received the refunded USDC.

```bash
$ chmod +x script/BatchRefund.sh
$ script/BatchRefund.sh
```

## Appendix: Query giver's USDC balance

```bash
$ RPC_URL="https://arbitrum-one-rpc.publicnode.com" \
&& USDC_ADDRESS="0xaf88d065e77c8cC2239327C5EDb3A432268e5831" \
&& GIVER_ADDRESS="0x1234A72239ecbA742D9A00C6Bec87b5a4ABF481a"

$ cast to-unit $(cast to-dec $(cast call ${USDC_ADDRESS} "balanceOf(address account)" ${GIVER_ADDRESS} --rpc-url ${RPC_URL})) $(cast call ${USDC_ADDRESS} "function decimals() public view returns (uint8)" --rpc-url ${RPC_URL})
```

## Appendix: Execute Batch Refund Script Using Raw Calldata

```bash
$ chmod +x script/CalldataRefund.sh
$ script/CalldataRefund.sh
```
