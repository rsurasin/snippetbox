package main

import (
	"flag"
	"log/slog"
	"net/http"
	"os"
)

func main() {
	// Define cmd line arg: addr w/ default value :4000
	addr := flag.String("addr", ":4000", "HTTP Network Connection")
	// Read cmd line arg and assign to addr
	flag.Parse()

	// Create structured logger - uses default settings
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))

	mux := http.NewServeMux()
	fileserver := http.FileServer(http.Dir("./ui/static/"))
	mux.Handle("GET /static/", http.StripPrefix("/static", fileserver))
	mux.HandleFunc("GET /{$}", home)
	mux.HandleFunc("GET /snippet/view/{id}", snippetView)
	mux.HandleFunc("GET /snippet/create", snippetCreate)
	mux.HandleFunc("POST /snippet/create", snippetCreatePost)

	logger.Info("Starting Server", "addr", *addr)

	err := http.ListenAndServe(*addr, mux)
	logger.Error(err.Error())
	os.Exit(1)
}
