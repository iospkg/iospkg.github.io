#!/bin/bash

if [[ "$(uname)" == Darwin ]]; then
  echo "Checking for Homebrew, wget, xz, & zstd..."
  if test ! "$(which brew)"; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  brew list --verbose wget || brew install wget
  brew list --verbose xz || brew install xz
  brew list --verbose zstd || brew install zstd
  clear

  # 检查并下载 apt-ftparchive
  if [ ! -e './apt-ftparchive' ]; then
    echo "apt-ftparchive compiled by @Diatrus"
    wget -q -nc https://apt.procurs.us/apt-ftparchive
    sudo chmod 751 ./apt-ftparchive
  fi

  # 清除缓存打包内容
  rm Packages Packages.bz2 Packages.xz Packages.zst Release Release.gpg

  # 开始打包
  echo "[Repository] Generating Packages..."
  ./apt-ftparchive packages ./debians > Packages
  zstd -q -c19 Packages > Packages.zst
  xz -c9 Packages > Packages.xz
  bzip2 -c9 Packages > Packages.bz2

  # 生成Release文件
  echo "[Repository] Generating Release..."
  ./apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="iospkg" \
		-o APT::FTPArchive::Release::Label="iospkg" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="1.0" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm iphoneos-arm64" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="iospkg self." \
		release . > Release

	# 生成 Release GPG 签名
	echo "[Repository] Signing Release using Amy's GPG Key..."
  gpg -abs -u 40A63AC25D0A5711A42DCCCC951BC6C8FEB3632F -o Release.gpg Release

  echo "[Repository] Finished"
else
    echo "Currently, updates are only supported under MacOS."
fi