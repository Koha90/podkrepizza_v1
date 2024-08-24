package api

import (
	"net/http"
)

func (s *Server) handleGetProducts(w http.ResponseWriter, r *http.Request) error {
	products, err := s.store.AllProducts()
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, products)
}
