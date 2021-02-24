#!/bin/sh
set -e -x

mkdir -p ~/.ssh 

echo "$private_key" > ~/.ssh/aur

echo "
Host aur.archlinux.org
  IdentityFile ~/.ssh/aur
  User aur" >> ~/.ssh/config
  
if [ -d deskreen-aur ]
then
rm -rf deskreen-aur
fi


git clone ssh://aur@aur.archlinux.org/deskreen.git deskreen-aur
cd deskreen-aur
sed -i "/pkgver=/c\pkgver=$version" PKGBUILD

echo "$version"
_pkgname=Deskreen
pkgname=deskreen
pkgver=$version

wget https://github.com/pavlobu/${pkgname}/releases/download/v${pkgver//_/-}/${_pkgname}-${pkgver}.AppImage
arr=(`sha256sum *.AppImage`)

echo $arr


sed -i "20s/.*/ '$arr'  /" PKGBUILD

curl -L https://bit.ly/3jBbJDx > makepkg
chmod +x makepkg
./makepkg --printsrcinfo > .SRCINFO

git add .
git config user.name "$name"
git config user.email "$email"
git commit -m "updated pkgbuild to $version"
git push

rm ~/.ssh/aur
