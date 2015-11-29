all:
	javac -cp moa.jar *.java
clean:
	cp lib/moa.jar ./
	find moa -name .DS_Store | xargs rm
install: clean all
	mv DDMSS.class moa/classifiers/core/driftdetection/
	zip -r moa.jar moa
