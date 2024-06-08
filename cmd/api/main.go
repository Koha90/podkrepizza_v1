package main

import (
	"log/slog"
	"os"

	"github.com/koha90/podkrepizza_v1/internal/api"
	"github.com/koha90/podkrepizza_v1/internal/config"
	"github.com/koha90/podkrepizza_v1/internal/storage"
)

const (
	envLocal = "local"
	envDev   = "dev"
	envProd  = "prod"
)

func main() {
	cfg := config.MustConfig()
	log := setupLogger(cfg.Logger.Env)

	log.Debug("debug mod is enabled")

	store, err := storage.NewStore(cfg.Storage.Path)
	if err != nil {
		log.Error("cannot initializin storage", "error", err)
	}

	log.Info("server has started", "port", cfg.HTTP.Port, "store enabled on", cfg.Storage.Path)

	srv := api.NewServer(cfg.HTTP.Port, store)
	srv.Run()
}

// setupLogger - устанавливает уровень логирования.
func setupLogger(env string) *slog.Logger {
	var log *slog.Logger

	switch env {
	case envLocal:
		log = slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug}))
	case envDev:
		log = slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug}))
	case envProd:
		log = slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelInfo}))
	}

	return log
}
