package config

import (
	"log"
	"os"
	"time"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	HTTP    HTTP    `yaml:"http"`
	Logger  Logger  `yaml:"logger"`
	Storage Storage `yaml:"storage"`
}

type HTTP struct {
	Port            string        `yaml:"port"`
	Timeout         time.Duration `yaml:"timeout"`
	IdleTimeout     time.Duration `yaml:"idle_timeout"`
	ShutdownTimeout time.Duration `yaml:"shutdown_timeout"`
}

type Logger struct {
	Env string `yaml:"env"`
}

type Storage struct {
	Path string `env:"STORAGE_PATH" env-required:"true"`
}

func MustConfig() *Config {
	cfgPath := os.Getenv("CONFIG_PATH")
	if cfgPath == "" {
		log.Fatal("CONFIG_PATH is empty. Add path to config in .env")
	}

	if _, err := os.Stat(cfgPath); os.IsNotExist(err) {
		log.Fatalf("config file does not exists: %s", cfgPath)
	}

	var cfg Config
	err := cleanenv.ReadConfig(cfgPath, &cfg)
	if err != nil {
		log.Fatalf("cannot read config file: %s", err)
	}
	return &cfg
}
