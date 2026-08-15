PORT := 8080
PIDFILE := .site-server.pid

.PHONY: build site serve stop clean

build:
	lake build

site: build
	lake exe generate-site

serve: site
	@if [ -f $(PIDFILE) ] && kill -0 "$$(cat $(PIDFILE))" 2>/dev/null; then \
		echo "Server already running at http://localhost:$(PORT) (pid $$(cat $(PIDFILE)))"; \
	else \
		nohup python3 -m http.server $(PORT) --directory _site > .site-server.log 2>&1 & \
		echo $$! > $(PIDFILE); \
		echo "Serving at http://localhost:$(PORT)"; \
	fi

stop:
	@if [ -f $(PIDFILE) ]; then \
		kill "$$(cat $(PIDFILE))" 2>/dev/null && echo "Stopped server" || echo "No running server found"; \
		rm -f $(PIDFILE); \
	else \
		echo "No server pid file found"; \
	fi

clean:
	rm -rf _site
