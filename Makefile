all:
	javac -cp moa.jar *.java
clean:
	cp lib/moa.jar ./
	find moa -name .DS_Store | xargs rm
install: clean all
	mv DDMSS.class moa/classifiers/core/driftdetection/
	mv EvaluatePrequentialActive.class moa/tasks/
	zip -r moa.jar moa
test: install
	java -Xmx4G -cp moa.jar -javaagent:sizeofag.jar moa.gui.GUI
