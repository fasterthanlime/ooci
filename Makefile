.PHONY: all clean

all:
	rock ooci.ooc -v +-DROCK_BUILD_DATE='"ooci"' +-DROCK_BUILD_TIME='"ooci"' ${OOC_DIST}/source/rock/frontend/NagaQueen.c

clean:
	rm -rf .libs rock_tmp/ ooci
