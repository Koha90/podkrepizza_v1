package api

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/koha90/podkrepizza_v1/internal/types"
)

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
