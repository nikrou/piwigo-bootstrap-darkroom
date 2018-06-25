DIST=.dist
THEME_NAME=$(shell basename `pwd`)
SOURCE=./*
TARGET=../target

config: clean manifest
	npm run build
	mkdir -p $(DIST)/$(THEME_NAME)

	# copy stuff from node_modules : @TODO move job in webpack
	cp -p node_modules/photoswipe/dist/photoswipe.min.js node_modules/photoswipe/dist/photoswipe-ui-default.min.js	\
	node_modules/slick-carousel/slick/slick.min.js									\
	node_modules/jquery/dist/jquery.min.js node_modules/jquery-migrate/dist/jquery-migrate.min.js			\
	node_modules/popper.js/dist/umd/popper.min.js									\
	node_modules/bootstrap-material-design/dist/js/bootstrap-material-design.min.js					\
	node_modules/bootstrap/dist/js/bootstrap.min.js									\
	node_modules/selectize/dist/js/standalone/selectize.min.js js/

	cp -pr admin assets BUGS.md CHANGELOG.md COPYING css include js language README.md screenshot.png template themeconf.inc.php img $(DIST)/$(THEME_NAME)/; \
	find $(DIST) -name '*~' -exec rm \{\} \;


dist: config
	cd $(DIST); \
	mkdir -p $(TARGET); \
	zip -v -r9 $(TARGET)/$(THEME_NAME)-$$(grep Version $(THEME_NAME)/themeconf.inc.php | sed -e 's/.*Version: //').zip $(THEME_NAME)/*; \

manifest:
	@find ./ -type f|egrep -v '(*~|.git|.gitignore|.dist|scss|package.json|postcss\.config\.js|package-lock.json|css/.*\.js|css/.*\.js\.map|node_modules|target|modele_complete|Makefile|rsync_exclude)'|sed -e 's/\.\///' -e 's/\(.*\)/$(THEME_NAME)\/&/'> ./MANIFEST

clean:
	rm -fr $(DIST)
