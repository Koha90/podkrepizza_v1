package storage

import (
	"database/sql"
	"fmt"

	_ "github.com/mattn/go-sqlite3"

	"github.com/koha90/podkrepizza_v1/internal/types"
)

type Storage interface {
	CreateAccount(*types.Account) error
	AccountByID(id int) (*types.Account, error)
	AllAccounts() ([]*types.Account, error)
	DeleteAccount(id int) error
	UpdateAccount(*types.Account) error
	PatchAccount(id int, updates map[string]interface{}) error

	CreateProduct(*types.Product) error
	ProductByID(id int) (*types.Product, error)
	AllProducts() ([]*types.Product, error)
	DeleteProduct(id int) error
	UpdateProduct(*types.Product) error
	PatchProduct(id int, updates map[string]interface{}) error
}

type SQLStorage struct {
	db *sql.DB
}

func NewStore(storagePath string) (*SQLStorage, error) {
	const op = "storage.NewStore"

	db, err := sql.Open("sqlite3", storagePath)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return &SQLStorage{db: db}, nil
}
