
# If you do not have libexpat and you have no use for reading any input
# type that is XML-ish (i.e. gpx or geocaching.com's/loc) you can uncomment
# INHIBIT_EXPAT and coment out LIBEXPAT on just to get a build working quickly.
# INHIBIT_EXPAT=-DNO_EXPAT
LIBEXPAT=-lexpat #-lefence

# USB may required non-standard libraries (like libusb) be installed
# and may not be available on all OSes.  Uncomment this to remove the key
# parts of USB from the build.
INHIBIT_USB=-DNO_USB

#
# Enable either or both of these as you wish.
#
OPTIMIZATION=-O $(EXTRA_OPTIMIZATION)
DEBUGGING=-g $(EXTRA_DEBUGGING)
# add -DDEBUG_MEM to turn on memory allocation logging
CFLAGS=$(EXTRA_CFLAGS) $(DEBUGGING) -Icoldsync $(INHIBIT_EXPAT) $(INHIBIT_USB) $(OPTIMIZATION)
INSTALL_TARGETDIR=/usr/local/

FMTS=magproto.o gpx.o geo.o mapsend.o mapsource.o garmin_tables.o \
	gpsutil.o pcx.o cetus.o copilot.o gpspilot.o magnav.o \
	psp.o holux.o garmin.o tmpro.o tpg.o \
	xcsv.o gcdb.o tiger.o internal_styles.o easygps.o quovadis.o \
	gpilots.o saroute.o navicache.o psitrex.o geoniche.o delgpl.o \
	ozi.o nmea.o text.o html.o palmdoc.o netstumbler.o hsa_ndv.o \
	igc.o brauniger_iq.o

FILTERS=position.o duplicate.o arcdist.o polygon.o smplrout.o reverse_route.o sort.o stackfilter.o

OSJEEPS=jeeps/gpslibusb.o
JEEPS=jeeps/gpsapp.o jeeps/gpscom.o \
	jeeps/gpsmath.o jeeps/gpsmem.o  \
	jeeps/gpsprot.o jeeps/gpsread.o \
	jeeps/gpsrqst.o jeeps/gpssend.o jeeps/gpsserial.o jeeps/gpsutil.o \
	jeeps/gpsusbread.o jeeps/gpsusbsend.o jeeps/gpsusbstub.o $(OSJEEPS)
# Extra modules in Jeeps that we don't use
# 	jeeps/gpsfmt.o jeeps/gpsinput.o jeeps/gpsproj.o


COLDSYNC=coldsync/util.o coldsync/pdb.o

LIBOBJS = queue.o route.o waypt.o filter_vecs.o util.o vecs.o mkshort.o \
          csv_util.o grtcirc.o vmem.o util_crc.o \
	$(COLDSYNC) $(GARMIN) $(JEEPS) $(FMTS) $(FILTERS)
OBJS = main.o $(LIBOBJS)

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

all: gpsbabel

gpsbabel: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o gpsbabel $(LIBEXPAT) -lm

main.o:
	$(CC) -c $(CFLAGS) -DVERSION=\"$(VERSIOND)\" $<

clean:
	rm -f $(OBJS) gpsbabel gpsbabel.exe

check:
	./testo

torture:
	./testo
	./torture_test

#
# This will only work on UNIX-like substances.
#
install:
	install gpsbabel  $(INSTALL_TARGETDIR)/bin

# Nerdy release stuff that needs to work only on Linux.

leaktest:
	make EXTRA_CFLAGS=-DDEBUG_MEM
	tools/cleardebug
	./testo
	tools/memdebug | grep -v '^command line:'

dep:
	make clean && make CC="gcc -MMD"  && cat *.d */*.d > /tmp/dep && rm *.d */*.d
	(echo -n "internal_styles.c: mkstyle.sh " ; echo style/*.style ; /bin/echo -e '\t./mkstyle.sh > internal_styles.c || (rm -f internal_styles.c ; exit 1)' ) >> /tmp/dep
	echo Edit Makefile and bring in /tmp/dep

VERSIONU=1_2_4_beta09012004-steve
VERSIOND=1.2.4_beta09012004-steve
#VERSIONU=1_2_3
#VERSIOND=1.2.3

release:
	cvs commit
	./chkdoc
	make clean &&  cd mingw ; make clean 
	rm -fr gpsbabel-$(VERSIOND)
	cvs tag -F gpsbabel_$(VERSIONU)
	cvs export -r gpsbabel_$(VERSIONU) -d gpsbabel-$(VERSIOND) gpsbabel
	tar czf /tmp/gpsbabel-$(VERSIOND).tar.gz gpsbabel-$(VERSIOND)
	cd /tmp ; tar xzf gpsbabel-$(VERSIOND).tar.gz
	touch /tmp/gpsbabel-$(VERSIOND)/internal_styles.c
	cd /tmp/gpsbabel-$(VERSIOND)/mingw ; make
	curl -u anonymous:anonymous --upload-file /tmp/gpsbabel-$(VERSIOND).tar.gz ftp://upload.sf.net/incoming/
	curl -u anonymous:anonymous --upload-file /tmp/gpsbabel-$(VERSIOND).zip ftp://upload.sf.net/incoming/

mac-build:
	make LIBEXPAT=/sw/lib/libexpat.a EXTRA_CFLAGS="-I/sw/include"

mac-release:
	mkdir -p usr/bin usr/share/gpsbabel/doc
	cp gpsbabel usr/bin/
	cp README* COPYING usr/share/gpsbabel/doc
	tar cvzf gpsbabel-osx.tgz usr/bin/gpsbabel
	curl -u anonymous:anonymous --upload-file gpsbabel-osx.tgz ftp://upload.sf.net/incoming/

# Machine generated from here down.  
arcdist.o: arcdist.c defs.h queue.h grtcirc.h
brauniger_iq.o: brauniger_iq.c defs.h queue.h jeeps/gpsserial.h \
  jeeps/gps.h jeeps/gpsport.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
cetus.o: cetus.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
copilot.o: copilot.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
csv_util.o: csv_util.c defs.h queue.h csv_util.h grtcirc.h
delgpl.o: delgpl.c defs.h queue.h
duplicate.o: duplicate.c defs.h queue.h
easygps.o: easygps.c defs.h queue.h
filter_vecs.o: filter_vecs.c defs.h queue.h
garmin.o: garmin.c defs.h queue.h jeeps/gps.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h \
  jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h \
  garmin_tables.h
garmin_tables.o: garmin_tables.c garmin_tables.h
gcdb.o: gcdb.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
geo.o: geo.c defs.h queue.h
geoniche.o: geoniche.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
gpilots.o: gpilots.c defs.h queue.h coldsync/palm.h coldsync/pdb.h \
  garmin_tables.h
gpspilot.o: gpspilot.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
gpsutil.o: gpsutil.c defs.h queue.h magellan.h
gpx.o: gpx.c defs.h queue.h
grtcirc.o: grtcirc.c defs.h queue.h
holux.o: holux.c defs.h queue.h holux.h
hsa_ndv.o: hsa_ndv.c defs.h queue.h
html.o: html.c defs.h queue.h jeeps/gpsmath.h jeeps/gps.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h jeeps/gpsinput.h \
  jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h
igc.o: igc.c defs.h queue.h
internal_styles.o: internal_styles.c defs.h queue.h
magnav.o: magnav.c defs.h queue.h coldsync/palm.h coldsync/pdb.h
magproto.o: magproto.c defs.h queue.h magellan.h
main.o: main.c defs.h queue.h
mapsend.o: mapsend.c defs.h queue.h mapsend.h magellan.h
mapsource.o: mapsource.c defs.h queue.h garmin_tables.h
mkshort.o: mkshort.c defs.h queue.h
navicache.o: navicache.c defs.h queue.h
netstumbler.o: netstumbler.c defs.h queue.h csv_util.h
nmea.o: nmea.c defs.h queue.h
ozi.o: ozi.c defs.h queue.h csv_util.h
palmdoc.o: palmdoc.c defs.h queue.h jeeps/gpsmath.h jeeps/gps.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h \
  jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h \
  coldsync/palm.h coldsync/pdb.h
pcx.o: pcx.c defs.h queue.h garmin_tables.h
polygon.o: polygon.c defs.h queue.h
position.o: position.c defs.h queue.h grtcirc.h
psitrex.o: psitrex.c defs.h queue.h garmin_tables.h
psp.o: psp.c defs.h queue.h
queue.o: queue.c queue.h
quovadis.o: quovadis.c quovadis.h defs.h queue.h coldsync/palm.h \
  coldsync/pdb.h
reverse_route.o: reverse_route.c defs.h queue.h
route.o: route.c defs.h queue.h
saroute.o: saroute.c defs.h queue.h
smplrout.o: smplrout.c defs.h queue.h grtcirc.h
sort.o: sort.c defs.h queue.h
stackfilter.o: stackfilter.c defs.h queue.h
text.o: text.c defs.h queue.h jeeps/gpsmath.h jeeps/gps.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h jeeps/gpsinput.h \
  jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h
tiger.o: tiger.c defs.h queue.h csv_util.h
tmpro.o: tmpro.c defs.h queue.h csv_util.h
tpg.o: tpg.c defs.h queue.h jeeps/gpsmath.h jeeps/gps.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h jeeps/gpsinput.h \
  jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h
util.o: util.c defs.h queue.h
util_crc.o: util_crc.c
vecs.o: vecs.c defs.h queue.h csv_util.h
vmem.o: vmem.c defs.h queue.h
waypt.o: waypt.c defs.h queue.h
xcsv.o: xcsv.c defs.h queue.h csv_util.h
coldsync/pdb.o: coldsync/pdb.c coldsync/config.h coldsync/palm.h \
  coldsync/pdb.h
coldsync/util.o: coldsync/util.c coldsync/config.h coldsync/pconn/util.h \
  coldsync/palm.h
jeeps/gpsapp.o: jeeps/gpsapp.c jeeps/gps.h defs.h queue.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h \
  jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h
jeeps/gpscom.o: jeeps/gpscom.c jeeps/gps.h defs.h queue.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h \
  jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h
jeeps/gpsmath.o: jeeps/gpsmath.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h jeeps/gpsdatum.h
jeeps/gpsmem.o: jeeps/gpsmem.c jeeps/gps.h defs.h queue.h jeeps/gpsport.h \
  jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h jeeps/gpsutil.h \
  jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h jeeps/gpsfmt.h \
  jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h jeeps/gpsrqst.h \
  jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h jeeps/gpsnmeaget.h \
  jeeps/garminusb.h
jeeps/gpsprot.o: jeeps/gpsprot.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
jeeps/gpsread.o: jeeps/gpsread.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
jeeps/gpsrqst.o: jeeps/gpsrqst.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
jeeps/gpssend.o: jeeps/gpssend.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
jeeps/gpsserial.o: jeeps/gpsserial.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
jeeps/gpsutil.o: jeeps/gpsutil.c jeeps/gps.h defs.h queue.h \
  jeeps/gpsport.h jeeps/gpsserial.h jeeps/gpssend.h jeeps/gpsread.h \
  jeeps/gpsutil.h jeeps/gpsapp.h jeeps/gpsprot.h jeeps/gpscom.h \
  jeeps/gpsfmt.h jeeps/gpsmath.h jeeps/gpsnmea.h jeeps/gpsmem.h \
  jeeps/gpsrqst.h jeeps/gpsinput.h jeeps/gpsproj.h jeeps/gpsnmeafmt.h \
  jeeps/gpsnmeaget.h
internal_styles.c: mkstyle.sh style/README.style style/arc.style style/csv.style style/custom.style style/dna.style style/fugawi.style style/gpsdrive.style style/gpsman.style style/mapconverter.style style/mxf.style style/nima.style style/s_and_t.style style/saplus.style style/tabsep.style style/xmap.style style/xmapwpt.style
	./mkstyle.sh > internal_styles.c || (rm -f internal_styles.c ; exit 1)
