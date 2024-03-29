#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/parity"
mkdir -p "${ROOTFS_DIR}/etc/parity/network"
install -m 644 files/config.toml "${ROOTFS_DIR}/etc/parity/"
install -m 700 "${PARITY_BINARY_DIR}/${PARITY_BINARY_NAME}" "${ROOTFS_DIR}/usr/bin/"
mv "${ROOTFS_DIR}/usr/bin/${PARITY_BINARY_NAME}" "${ROOTFS_DIR}/usr/bin/parity"
install -m 644 files/parity.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
if [ "${IS_TESTNET}" == "1" ]; then
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DucatusX/ducatusx/master/configs/testnet/chain.json
else
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DucatusX/ducatusx/master/configs/mainnet/chain.json
fi

systemctl enable parity
EOF
