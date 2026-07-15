.PHONY: help check bootstrap install tag release clean

help:
	@echo "Available targets:"
	@echo "  make check                  Run project validation"
	@echo "  make bootstrap              Run bootstrap.sh"
	@echo "  make install                Run install.sh"
	@echo "  make tag VERSION=x.y.z      Create an annotated Git tag"
	@echo "  make release VERSION=x.y.z  Push the tag and create a GitHub release"
	@echo "  make clean                  Show cleanup status"

check:
	./tests/check.sh

bootstrap:
	./bootstrap.sh

install:
	./install.sh

tag:
	@test -n "$(VERSION)" || (echo "Usage: make tag VERSION=x.y.z" && exit 1)
	@git rev-parse "v$(VERSION)" >/dev/null 2>&1 && \
		(echo "Tag v$(VERSION) already exists." && exit 1) || true
	git tag -a "v$(VERSION)" -m "v$(VERSION)"

release:
	@test -n "$(VERSION)" || (echo "Usage: make release VERSION=x.y.z" && exit 1)
	@git rev-parse "v$(VERSION)" >/dev/null 2>&1 || \
		(echo "Tag v$(VERSION) does not exist. Run make tag VERSION=$(VERSION) first." && exit 1)
	git push
	git push origin "v$(VERSION)"
	gh release create "v$(VERSION)" --generate-notes

clean:
	@echo "Nothing to clean."
