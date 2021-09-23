#!/bin/bash
# REV01 Thu 23 Sep 2021 14:42:00 WIB
# REV00 Thu 16 Sep 2021 13:40:00 WIB
# START Thu 16 Sep 2021 13:40:00 WIB

REC2="zetaprawira7@gmail.com"
REC1="operatingsystems@vlsm.org"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"

[ -d $HOME/RESULT/ ] || mkdir -p $HOME/RESULT/
pushd $HOME/RESULT/
for II in W?? ; do
    [ -d $II ] || continue
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    rm -f $TARFILE $TARFASC
    echo "tar cfj $TARFILE $II/"
    tar cfj $TARFILE $II/
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
done
popd

for II in $HOME/RESULT/myW*.tar.bz2.asc ; do
   echo "Check and move $II..."
   [ -f $II ] && mv -f $II .
done

echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

echo "sha256sum -c $SHA"
sha256sum -c $SHA

echo "gpg --output $SHA.asc --armor --sign --detach-sign $SHA"
gpg --output $SHA.asc --armor --sign --detach-sign $SHA

echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

exit 0
