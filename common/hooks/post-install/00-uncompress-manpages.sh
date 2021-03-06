# This hook uncompresses man(1) files.

hook() {
	local f lnkat mandir=${PKGDESTDIR}/usr/share/man

	if [ -d ${PKGDESTDIR}/usr/man ]; then
		msg_error "${pkgver}: /usr/man directory is not allowed, use /usr/share/man.\n"
	fi

	if [ ! -d $mandir ] ||
	   [ -z "$(find $mandir -regex '.*\.\(gz\|bz2\)' -print -quit)" ]; then
		return 0
	fi

	# rewrite symlinks
	find $mandir -type l -regex '.*\.\(gz\|bz2\)' | while read f
	do
		lnkat=$(readlink "$f")
		ln -s ${lnkat%.*} ${f%.*}
		rm $f
	done

	find $mandir -type f -name '*.gz' -exec gunzip -v {} + &>/dev/null
	find $mandir -type f -name '*.bz2' -exec bunzip2 -v {} + &>/dev/null
}
