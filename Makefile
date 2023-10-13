all: clean web

clean:
	rm -rf build/*

_md_web:
	mkdir -p build/web

web: _md_web
	godot --headless --export-release Web build/web/index.html \
	&& cd build/web \
	&& rm -f **/*.import

web_deploy:
	scp build/web/* vps:/var/server/htdocs/edugames/vhosts/default/games/cash_or_card/
