PROJECT_NAME=image-block-x
EXCLUDE := .git .gitignore Makefile assets/** **.md
SOURCE=ImageBlockX
ASSETS=assets


IMAGE_SIZES := 16 24 32 64 128 256 512
BLOCKED := $(IMAGE_SIZES:%=image_allowed-%.png)
ALLOWED := $(IMAGE_SIZES:%=image_blocked-%.png)


all: make  ## Default target, generate package

make: $(BLOCKED) $(ALLOWED)  ## Generate requirements and bundle into package
	@which optipng || echo "optipng is required to build" && exit 1
	-optipng -o7 ${SOURCE}/icons/*.png # compress icons if `optipng` is available
	cd ${SOURCE}; zip -r ${PROJECT_NAME}.zip * -x ${EXCLUDE}; mv ${PROJECT_NAME}.zip ..; cd -

image_blocked-%.png:  ## Generate "blocked" images
	@which convert || echo "imagemagick is required to build" && exit 1
	convert -transparent white -geometry $*x$* ${ASSETS}/icons/image_blocked_default.svg ${SOURCE}/icons/image_blocked-$*.png

image_allowed-%.png:  ## Generate "allowed" images
	@which convert || echo "imagemagick is required to build" && exit 1
	convert -transparent white -geometry $*x$* ${ASSETS}/icons/image_allowed_default.svg ${SOURCE}/icons/image_allowed-$*.png


.PHONY: clean help
clean:  ## Remove autogenerated files
	rm -fv ${PROJECT_NAME}.zip
	rm -fv ${SOURCE}/icons/*.png

help:  ## Print this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
