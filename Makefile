export GOPATH        := $(abspath go)
export GOAPP         := $(abspath go_appengine/goapp)
export GOAPP-PATCHED := $(abspath go_appengine_patched/goapp)

.PHONY: all test-original test-patched

all: test-original test-patched

test-original: $(GOAPP)
	$(GOAPP) test -i go/src/test/ds_test.go
	$(GOAPP) test -v go/src/test/ds_test.go

test-patched: $(GOAPP-PATCHED)
	$(GOAPP-PATCHED) test -i go/src/test/ds_test.go
	$(GOAPP-PATCHED) test -v go/src/test/ds_test.go

$(GOAPP): go_appengine_sdk_darwin_amd64-1.9.54.zip
	unzip -q go_appengine_sdk_darwin_amd64-1.9.54.zip
	touch $(GOAPP)

$(GOAPP-PATCHED): $(GOAPP) 1.9.54.patch
	cp -R go_appengine go_appengine_patched
	patch -p2 -d go_appengine_patched/goroot <1.9.54.patch
	patch -p2 -d go_appengine_patched/goroot-1.6 <1.9.54.patch
	rm go_appengine_patched/goroot/pkg/darwin_amd64_appengine/appengine/aetest.a
	rm go_appengine_patched/goroot-1.6/pkg/darwin_amd64_appengine/appengine/aetest.a
	touch $(GOAPP-PATCHED)

go_appengine_sdk_darwin_amd64-1.9.54.zip:
	curl -O https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.54.zip
