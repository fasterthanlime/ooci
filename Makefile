.PHONY: all clean

OOC?=rock

all:
	${OOC} ooci.ooc -v +-DROCK_BUILD_DATE='"ooci"' +-DROCK_BUILD_TIME='"ooci"' ${OOC_DIST}/source/rock/frontend/NagaQueen.c +-w

clean:
	rm -rf .libs rock_tmp/ ooci
