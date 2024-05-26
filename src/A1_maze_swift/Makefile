CXX = xcodebuild
APPNAME = A1_maze_swift
BUILD = buildA1
DOCS = docsA1

all: install

install:
	$(CXX) -list -project $(APPNAME).xcodeproj/ -target $(APPNAME)
	$(CXX) build SYMROOT=$(BUILD)
	mv -i $(BUILD)/Release/$(APPNAME).app $(APPNAME).app
	open ./$(APPNAME).app

uninstall:
	rm -rf $(BUILD)
	rm -rf $(DOCS)
	rm -rf $(APPNAME).app

clean:
	rm -rf dist.tar
	rm -rf /$(BUILD)/*
	rm -rf /$(DOCS)/*

dvi:
	$(CXX) docbuild -scheme $(APPNAME) -derivedDataPath $(DOCS)
	cd $(DOCS)/Build/Products/Debug/; open $(APPNAME).doccarchive

dist:
	tar -cvzf dist.tar $(APPNAME) $(APPNAME).xcodeproj

tests:
	$(CXX) test -project $(APPNAME).xcodeproj/ -scheme $(APPNAME)
	
