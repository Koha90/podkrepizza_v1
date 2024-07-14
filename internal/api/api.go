package api

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"

	"github.com/koha90/podkrepizza_v1/internal/config"
	"github.com/koha90/podkrepizza_v1/internal/storage"
)

type Server struct {
	srv   *http.Server
	store storage.Storage
}

func NewServer(cfg config.Config, store storage.Storage) *Server {
	srv := &http.Server{
		Addr:         cfg.HTTP.Port,
		Handler:      &chi.Mux{},
		ReadTimeout:  cfg.HTTP.Timeout,
		WriteTimeout: cfg.HTTP.Timeout,
		IdleTimeout:  cfg.HTTP.IdleTimeout,
	}

	return &Server{srv: srv, store: store}
}

func (s *Server) Run() {
	r := chi.NewMux()

	r.Use(cors.Handler(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"},
		AllowedHeaders: []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		MaxAge:         300,
	}))
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Use(middleware.Timeout(30 * time.Second))

	r.Post("/account", makeHTTPHandleFunc(s.handleCreateAccount))
	r.Get("/account", makeHTTPHandleFunc(s.handleGetAccounts))
	r.Get("/account/{id}", makeHTTPHandleFunc(s.handleGetAccountByID))
	r.Delete("/account/{id}", makeHTTPHandleFunc(s.handleDeleteAccount))
	r.Put("/account/{id}", makeHTTPHandleFunc(s.handleUpdateAccount))

	r.Get("/products", makeHTTPHandleFunc(s.handleGetProducts))

	http.ListenAndServe(s.srv.Addr, r)
}

func WriteJSON(w http.ResponseWriter, status int, v any) error {
	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(status)

	return json.NewEncoder(w).Encode(v)
}

type apiFunc func(http.ResponseWriter, *http.Request) error

type APIError struct {
	Error string `json:"error"`
}

func makeHTTPHandleFunc(f apiFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if err := f(w, r); err != nil {
			WriteJSON(w, http.StatusBadRequest, APIError{Error: err.Error()})
		}
	}
}

func getID(r *http.Request) (int, error) {
	strID := chi.URLParam(r, "id")
	id, err := strconv.Atoi(strID)
	if err != nil {
		return id, fmt.Errorf("invalid id given: %s", strID)
	}

	return id, nil
}
