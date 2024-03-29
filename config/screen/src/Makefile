#
# Makefile template for screen 
#
# See machine dependant config.h for more configuration options.
#

srcdir = .


DESTDIR = 

# Where to install screen.

prefix = /Users/kokamoto
exec_prefix = ${prefix}

# don't forget to change mandir and infodir in doc/Makefile.
bindir  = $(exec_prefix)/bin

VERSION = 4.0.3
SCREEN = screen-$(VERSION)

ETCSCREENRC = `sed < config.h -n -e '/define ETCSCREENRC/s/^.*"\([^"]*\)"/\1/p'`
SCREENENCODINGS = `sed < config.h -n -e '/define SCREENENCODINGS/s/^.*"\([^"]*\)"/\1/p'`

CC = gcc
CFLAGS = -g -O2
CPPFLAGS = 
LDFLAGS = 
LIBS = -lcurses 

CPP=gcc -E
CPP_DEPEND=$(CC) -MM

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644

AWK = awk

### Chose some debug configuration options:
# -DDEBUG
#	Turn on really heavy debug output. This is written to 
#	/tmp/debug/{SCREEN,screen}.<pid>. Look at these files and quote 
#	questionable sections when sending bug-reports to the author.
# -DDUMPSHADOW
#	With shadow-pw screen would never dump core. Use this option if
#	you still want to have a core. Use only for debugging.
OPTIONS=
#OPTIONS= -DDEBUG

SHELL=/bin/sh

CFILES=	screen.c ansi.c fileio.c mark.c misc.c resize.c socket.c \
	search.c tty.c term.c window.c utmp.c loadav.c putenv.c help.c \
	termcap.c input.c attacher.c pty.c process.c display.c comm.c \
	kmapdef.c acls.c braille.c braille_tsi.c logfile.c layer.c \
	sched.c teln.c nethack.c encoding.c
OFILES=	screen.o ansi.o fileio.o mark.o misc.o resize.o socket.o \
	search.o tty.o term.o window.o utmp.o loadav.o putenv.o help.o \
	termcap.o input.o attacher.o pty.o process.o display.o comm.o \
	kmapdef.o acls.o braille.o braille_tsi.o logfile.o layer.o \
	sched.o teln.o nethack.o encoding.o

all:	screen

screen: $(OFILES)
	$(CC) $(LDFLAGS) -o $@ $(OFILES) $(LIBS)

.c.o:
	$(CC) -c -I. -I$(srcdir) $(M_CFLAGS) $(DEFS) $(OPTIONS) $(CFLAGS) $<

install_bin: .version screen
	-if [ -f $(DESTDIR)$(bindir)/$(SCREEN) ] && [ ! -f $(DESTDIR)$(bindir)/$(SCREEN).old ]; \
		then mv $(DESTDIR)$(bindir)/$(SCREEN) $(DESTDIR)$(bindir)/$(SCREEN).old; fi
	$(INSTALL_PROGRAM) screen $(DESTDIR)$(bindir)/$(SCREEN)
	-chown root $(DESTDIR)$(bindir)/$(SCREEN) && chmod 4755 $(DESTDIR)$(bindir)/$(SCREEN)
# This doesn't work if $(bindir)/screen is a symlink
	-if [ -f $(DESTDIR)$(bindir)/screen ] && [ ! -f $(DESTDIR)$(bindir)/screen.old ]; then mv $(DESTDIR)$(bindir)/screen $(DESTDIR)$(bindir)/screen.old; fi
	rm -f $(DESTDIR)$(bindir)/screen
	(cd $(DESTDIR)$(bindir) && ln -f -s $(SCREEN) screen)
	cp $(srcdir)/utf8encodings/?? $(DESTDIR)$(SCREENENCODINGS)

###############################################################################
install: installdirs install_bin
	cd doc ; $(MAKE) install
	-if [ -d /usr/lib/terminfo ]; then \
		PATH="$$PATH:/usr/5bin" tic ${srcdir}/terminfo/screeninfo.src; \
		chmod 644 /usr/lib/terminfo/s/screen*; \
	fi
# Better do this by hand. E.g. under RCS...
#	cat ${srcdir}/terminfo/screencap >> /etc/termcap
	@echo "termcap entry (${srcdir}/terminfo/screencap) should be installed manually."
	@echo "You may also want to install $(srcdir)/etc/etcscreenrc in" $(ETCSCREENRC)

installdirs:
# Path leading to ETCSCREENRC and Socketdirectory not checked.
	$(srcdir)/etc/mkinstalldirs $(DESTDIR)$(bindir) $(DESTDIR)$(SCREENENCODINGS)
	cd doc ; $(MAKE) installdirs

uninstall: .version
	rm -f $(DESTDIR)$(bindir)/$(SCREEN)
	rm -f $(DESTDIR)$(bindir)/screen
	-mv $(DESTDIR)$(bindir)/screen.old $(DESTDIR)$(bindir)/screen
	rm -f $(DESTDIR)$(ETCSCREENRC)
	cd doc; $(MAKE) uninstall

shadow:
	mkdir shadow;
	cd shadow; ln -s ../*.[ch] ../*.in ../*.sh ../configure ../doc ../terminfo ../etc .
	rm -f shadow/term.h shadow/tty.c shadow/comm.h shadow/osdef.h
	echo "install all Makefiles and config:" > shadow/Makefile
	echo "	rm -f config.cache" >> shadow/Makefile
	echo "	sh ./configure" >> shadow/Makefile
	
term.h: term.c term.sh
	AWK=$(AWK) srcdir=$(srcdir) sh $(srcdir)/term.sh

kmapdef.c: term.h

tty.c:	tty.sh 
	sh $(srcdir)/tty.sh tty.c

comm.h: comm.c comm.sh config.h
	AWK=$(AWK) CC="$(CC) $(CFLAGS)" srcdir=${srcdir} sh $(srcdir)/comm.sh

osdef.h: osdef.sh config.h osdef.h.in
	CPP="$(CPP) $(CPPFLAGS)" srcdir=${srcdir} sh $(srcdir)/osdef.sh

docs:
	cd doc; $(MAKE) dvi screen.info

dvi info screen.info:
	-cd doc; $(MAKE) $@

mostlyclean:
	rm -f $(OFILES) screen config.cache osdef0.c osdef1.sed osdef2.sed

clean celan: mostlyclean
	rm -f tty.c term.h comm.h osdef.h kmapdef.c core

# Delete all files from the current directory that are created by 
# configuring or building the program.
# building of term.h/comm.h requires awk. Keep it in the distribution
# we keep config.h, as this file knows where 'make dist' finds the ETCSCREENRC.
#distclean:	mostlyclean
#	rm -f $(SCREEN).tar $(SCREEN).tar.gz
#	rm -f config.status Makefile
#	rm -f osdef.h doc/Makefile

maintainer-clean:
	@echo "This command is not even intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."


# Delete everything from the current directory that can be
# reconstructed with this Makefile.
realclean: .version mostlyclean
	rm -f $(SCREEN).tar $(SCREEN).tar.gz
	rm -f config.status Makefile doc/Makefile
	rm -f tty.c term.h comm.h osdef.h kmapdef.c
	rm -f config.h
	echo "install all Makefiles and config:" > Makefile
	echo "  sh ./configure" >> Makefile

tags TAGS: $(CFILES)
	-ctags    *.sh $(CFILES) *.h
	-ctags -e *.sh $(CFILES) *.h

dist: .version $(SCREEN).tar.gz

$(SCREEN).tar: .version term.h comm.h tty.c kmapdef.c
	-rm -rf dist
	mkdir dist
	mkdir dist/$(SCREEN)
	ln acls.h ansi.h display.h extern.h logfile.h mark.h os.h \
	   layer.h patchlevel.h screen.h window.h image.h \
	   osdef.h.in term.sh tty.sh comm.sh osdef.sh braille.h \
	   sched.h \
	   $(CFILES) \
	   ChangeLog COPYING INSTALL NEWS* TODO install.sh \
	   dist/$(SCREEN)
	cd dist/$(SCREEN); mv tty.c tty.c.dist
	cd dist/$(SCREEN); mv kmapdef.c kmapdef.c.dist
	ln configure.in configure dist/$(SCREEN)
	sed -e 's@"/local/screens@"/tmp/screens@' -e 's@"/local@"/usr/local@g' < config.h.in > dist/$(SCREEN)/config.h.in
	sed -e 's@[	 ]/local@ /usr/local@g' -e 's/^CFLAGS = -g/CFLAGS = -O/' < Makefile.in > dist/$(SCREEN)/Makefile.in
	ln term.h dist/$(SCREEN)/term.h.dist
	ln comm.h dist/$(SCREEN)/comm.h.dist
	ln README dist/$(SCREEN)/README
	mkdir dist/$(SCREEN)/terminfo
	cd terminfo; ln 8bits README checktc.c screencap \
	  screeninfo.src test.txt tetris.c \
	  ../dist/$(SCREEN)/terminfo
	mkdir dist/$(SCREEN)/etc
	cd etc; ln * ../dist/$(SCREEN)/etc
	mkdir dist/$(SCREEN)/utf8encodings
	cd utf8encodings; ln * ../dist/$(SCREEN)/utf8encodings
	# sed -e 's/^startup/#startup/' -e 's/^autodetach/#autodetach/' < $(ETCSCREENRC) > dist/$(SCREEN)/etc/etcscreenrc 
	cp $(HOME)/.screenrc dist/$(SCREEN)/etc/screenrc
	mkdir dist/$(SCREEN)/doc
	sed -e 's@/local/emacs@/usr/local@g' < doc/Makefile.in > dist/$(SCREEN)/doc/Makefile.in
	cd doc; ln FAQ README.DOTSCREEN screen.1 screen.texinfo fdpat.ps make.help window_to_display.ps \
	  ../dist/$(SCREEN)/doc
	cd doc; if test -f screen.info; then ln screen.info* \
	   ../dist/$(SCREEN)/doc; fi
	cd dist/$(SCREEN)/doc; ln -s ../install.sh .
	cd dist/$(SCREEN); ln -s doc/FAQ .
	echo "install all Makefiles and config:" > dist/$(SCREEN)/Makefile
	echo "	rm -f config.cache" >> dist/$(SCREEN)/Makefile
	echo "	sh ./configure"     >> dist/$(SCREEN)/Makefile
	cd dist; tar cf ../$(SCREEN).tar $(SCREEN)
	rm -rf dist

$(SCREEN).tar.gz: $(SCREEN).tar
	gzip -nf $(SCREEN).tar || gzip -f $(SCREEN).tar

# Perform self-tests (if any).
check:

lint:
	lint -I. $(CFILES)

saber:
	#load $(CFLAGS) screen.c ansi.c $(LIBS)

config:
	rm -f config.cache
	sh ./configure


###############################################################################

.version:
	@rev=`sed < $(srcdir)/patchlevel.h -n -e '/#define REV/s/#define REV  *//p'`; \
	vers=`sed < $(srcdir)/patchlevel.h -n -e '/#define VERS/s/#define VERS  *//p'`; \
	pat=`sed < $(srcdir)/patchlevel.h -n -e '/#define PATCHLEVEL/s/#define PATCHLEVEL  *//p'`; \
	if [ "$${rev}.$${vers}.$${pat}" != "$(VERSION)" ]; then \
	echo "This distribution is screen-$${rev}.$${vers}.$${pat}, but"; \
	echo "the Makefile is from $(VERSION). Please update!"; exit 1; fi

###############################################################################

mdepend: $(CFILES) term.h
	@rm -f DEPEND ; \
	for i in ${CFILES} ; do \
	  echo "$$i" ; \
	  echo `echo "$$i" | sed -e 's/.c$$/.o/'`": $$i" `\
            cc -E $$i |\
            grep '^# .*"\./.*\.h"' |\
            (sort -t'"' -u -k 2,2 2>/dev/null || sort -t'"' -u +1 -2) |\
            sed -e 's/.*"\.\/\(.*\)".*/\1/'\
          ` >> DEPEND ; \
	done


depend: depend.in
	./config.status || ./configure
	
depend.in: $(CFILES) term.h
	cp Makefile.in Makefile.in~
	sed -e '/\#\#\# Dependencies/q' < Makefile.in > tmp_make
	for i in $(CFILES); do echo $$i; $(CPP_DEPEND) $$i >> tmp_make; done 
	mv tmp_make Makefile.in

###############################################################################

### Dependencies:
screen.o: screen.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h braille.h \
 patchlevel.h logfile.h extern.h
ansi.o: ansi.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h braille.h extern.h \
 logfile.h
fileio.o: fileio.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
mark.o: mark.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h mark.h extern.h
misc.o: misc.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
resize.o: resize.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
socket.o: socket.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
search.o: search.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h mark.h extern.h
tty.o: tty.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
term.o: term.c term.h
window.o: window.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
utmp.o: utmp.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
loadav.o: loadav.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
putenv.o: putenv.c config.h
help.o: help.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
termcap.o: termcap.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
input.o: input.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
attacher.o: attacher.c config.h screen.h os.h osdef.h ansi.h \
 acls.h comm.h layer.h term.h image.h display.h window.h extern.h
pty.o: pty.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
process.o: process.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
display.o: display.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
comm.o: comm.c config.h acls.h comm.h
kmapdef.o: kmapdef.c config.h
acls.o: acls.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
braille.o: braille.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
braille_tsi.o: braille_tsi.c config.h screen.h os.h osdef.h ansi.h \
 acls.h comm.h layer.h term.h image.h display.h window.h extern.h \
 braille.h
logfile.o: logfile.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
layer.o: layer.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
sched.o: sched.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
teln.o: teln.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
nethack.o: nethack.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
encoding.o: encoding.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
