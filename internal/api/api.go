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
	"github.com/koha90/podkrepizza_v1/internal/types"
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
		AllowedOrigins: []string{"localhost:3000", "127.0.0.1:3000"},
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

func (s *Server) handleCreateAccount(w http.ResponseWriter, r *http.Request) error {
	req := new(types.CreateAccountRequest)

	if err := json.NewDecoder(r.Body).Decode(req); err != nil {
		return err
	}

	account, err := types.NewAccount(req.Name, req.FirstName, req.LastName, req.Password)
	if err != nil {
		return err
	}
	if err := s.store.CreateAccount(account); err != nil {
		return err
	}

	return WriteJSON(w, http.StatusCreated, account)
}

func (s *Server) handleGetAccounts(w http.ResponseWriter, r *http.Request) error {
	accounts, err := s.store.AllAccounts()
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, accounts)
}

func (s *Server) handleGetAccountByID(w http.ResponseWriter, r *http.Request) error {
	id, err := getID(r)
	if err != nil {
		return err
	}

	acc, err := s.store.AccountByID(id)
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, acc)
}

func (s *Server) handleDeleteAccount(w http.ResponseWriter, r *http.Request) error {
	id, err := getID(r)
	if err != nil {
		return err
	}

	if err := s.store.DeleteAccount(id); err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]int{"deleted": id})
}

func (s *Server) handleUpdateAccount(w http.ResponseWriter, r *http.Request) error {
	id, err := getID(r)
	if err != nil {
		return err
	}

	account := new(types.Account)
	if err := json.NewDecoder(r.Body).Decode(account); err != nil {
		return err
	}

	location, err := time.LoadLocation("Asia/Yekaterinburg")
	if err != nil {
		return err
	}

	account.ID = id
	account.UpdatedAt = time.Now().In(location)

	if err := s.store.UpdateAccount(account); err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, id)
}

func (s *Server) handleGetProducts(w http.ResponseWriter, r *http.Request) error {
	products, err := s.store.AllProducts()
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, products)
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
