package test

import (
	"testing"

	"google.golang.org/appengine/aetest"
	"google.golang.org/appengine/datastore"
)

type ExampleEntity struct {
	Name string
}

func TestDatastoreStress(t *testing.T) {
	ctx, done, ctx_err := aetest.NewContext()
	if ctx_err != nil {
		t.Fatal(ctx_err)
	}
	defer done()

	for i := 0; i < 75000; i += 1 {
		e := ExampleEntity{Name: "some string value"}

		key := datastore.NewKey(ctx, "ExampleEntity", "", int64(i), nil)

		_, put_err := datastore.Put(ctx, key, &e)

		if put_err != nil {
			t.Fatalf("Failed after %d iterations: %s", i, put_err)
		}
	}
}
