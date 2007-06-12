BINDIR=/usr/bin
LOCALESDIR=/usr/share/locale
MANDIR=/usr/share/man/man1
WARNFLAGS=-Wall  -W -Wshadow
CFLAGS?=-O2 -g ${WARNFLAGS}
CC?=gcc


# 
# The w in -lncursesw is not a typo; it is the wide-character version
# of the ncurses library, needed for multi-byte character languages
# such as Japanese and Chinese etc.
#
# On Debian/Ubuntu distros, this can be found in the
# libncursesw5-dev package. 
#
powertop: powertop.c config.c process.c misctips.c bluetooth.c display.c suggestions.c wireless.c cpufreq.c sata.c xrandr.c Makefile powertop.h
	$(CC) ${CFLAGS}  powertop.c config.c process.c misctips.c bluetooth.c display.c suggestions.c wireless.c cpufreq.c sata.c xrandr.c -lncursesw -o powertop
	@(cd po/ && $(MAKE))

powertop.1.gz: powertop.1
	gzip -c $< > $@

install: powertop powertop.1.gz
	mkdir -p ${DESTDIR}${BINDIR}
	cp powertop ${DESTDIR}${BINDIR}
	mkdir -p ${DESTDIR}${MANDIR}
	cp powertop.1.gz ${DESTDIR}${MANDIR}
	@(cd po/ && env LOCALESDIR=$(LOCALESDIR) DESTDIR=$(DESTDIR) $(MAKE) $@)

# This is for translators. To update your po with new strings, do :
# svn up ; make uptrans LG=fr # or de, ru, hu, it, ...
uptrans:
	xgettext -C -s -k_ -o po/powertop.pot *.c *.h
	@(cd po/ && env LG=$(LG) $(MAKE) $@)

clean:
	rm -f *~ powertop powertop.1.gz po/powertop.pot DEADJOE svn-commit*
	@(cd po/ && $(MAKE) $@)


dist:
	rm -rf .svn po/.svn DEADJOE po/DEADJOE todo.txt Lindent svn-commit.* dogit.sh git/ *.rej *.orig
