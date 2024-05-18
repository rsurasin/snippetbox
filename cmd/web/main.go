package main

import (
	"flag"
	"log/slog"
	"net/http"
	"os"
)

type application struct {
	logger *slog.Logger
}

func main() {
	// Define cmd line arg: addr w/ default value :4000
	addr := flag.String("addr", ":4000", "HTTP Network Connection")
	// Read cmd line arg and assign to addr
	flag.Parse()

	// Create structured logger - uses default settings
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
	app := &application{logger: logger}

	logger.Info("Starting Server", "addr", *addr)

	err := http.ListenAndServe(*addr, app.routes())
	logger.Error(err.Error())
	os.Exit(1)
}
