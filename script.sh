#!/bin/bash

# local setup
npx snarkjs powersoftau new bls12381 8 local_setup_8_0.ptau -v
npx snarkjs powersoftau contribute local_setup_8_0.ptau local_setup_8_1.ptau -n="contribution1" -v -e=$(openssl rand -base64 32)
npx snarkjs powersoftau contribute local_setup_8_1.ptau local_setup_8_2.ptau -n="contribution2" -v -e=$(openssl rand -base64 32)
npx snarkjs powersoftau contribute local_setup_8_2.ptau local_setup_8_3.ptau -n="contribution3" -v -e=$(openssl rand -base64 32)
npx snarkjs powersoftau beacon local_setup_8_3.ptau local_setup_8_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="final_beacon"
npx snarkjs powersoftau prepare phase2 local_setup_8_beacon.ptau local_setup_8_final.ptau -v
npx snarkjs powersoftau verify local_setup_8_final.ptau

# circuit build
circom ./Multiplier.circom --wasm --r1cs --prime bls12381
mv ./Multiplier.r1cs ./Multiplier_js/Multiplier.r1cs
npx snarkjs plonk setup ./Multiplier_js/Multiplier.r1cs ./local_setup_8_final.ptau circuit.zkey
npx snarkjs zkey export verificationkey circuit.zkey verification_key.json
npx snarkjs plonk fullprove ./input.json ./Multiplier_js/Multiplier.wasm ./circuit.zkey proof.json public.json

# offchain verification
npx snarkjs plonk verify verification_key.json public.json proof.json

# onchain verification
npx snarkjs zkey export solidityverifier circuit.zkey verifier.sol
npx snarkjs zkey export soliditycalldata public.json proof.json
