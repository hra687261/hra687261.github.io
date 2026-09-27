PORT := 8080
PIDFILE := .site-server.pid
CV_YAML := cv/cv.yaml
CV_DIR := assets/cv
CV_OUT := cv/rendercv_output

.PHONY: build site serve stop clean cv cv-hacking

build:
	lake build

cv:
	rendercv render --dont-generate-markdown --dont-generate-png "$(CV_YAML)"
	mkdir -p $(CV_DIR)
	cp $(CV_OUT)/*.pdf $(CV_DIR)/CV.pdf
	rm -rf $(CV_OUT)

cv-hacking:
	rendercv render --watch --dont-generate-markdown --dont-generate-png \
		--pdf-path "../$(CV_DIR)/CV.pdf" "$(CV_YAML)"

site: build cv
	lake exe generate-site
	cp 404.html _site/

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
