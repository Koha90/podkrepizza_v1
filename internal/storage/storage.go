package storage

import (
	"database/sql"
	"fmt"
	"time"

	_ "github.com/mattn/go-sqlite3"

	"github.com/koha90/podkrepizza_v1/internal/types"
)

type Storage interface {
	CreateAccount(*types.Account) error
	AccountByID(id int) (*types.Account, error)
	AllAccount() ([]*types.Account, error)
	DeleteAccount(id int) error
	UpdateAccount(*types.Account) error
	PatchAccount(id int, updates map[string]interface{}) error
}

type Store struct {
	db *sql.DB
}

func NewStore(storagePath string) (*Store, error) {
	const op = "storage.NewStore"

	db, err := sql.Open("sqlite3", storagePath)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return &Store{db: db}, nil
}

func (s *Store) CreateAccount(acc *types.Account) error {
	const op = "storage.CreateAccount"

	query := `INSERT INTO Account
  (name, first_name, last_name, encrypted_password, role, created_at, updated_at)
  VALUES ($1, $2, $3, $4, $5, $6, $7);`
	_, err := s.db.Exec(
		query,
		acc.Name,
		acc.FirstName,
		acc.LastName,
		acc.EncryptedPassword,
		acc.Role,
		acc.CreatedAt,
		acc.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (s *Store) DeleteAccount(id int) error {
	_, err := s.db.Exec("DELETE FROM Account WHERE id = $1", id)
	if err != nil {
		return err
	}

	return nil
}

func (s *Store) AllAccount() ([]*types.Account, error) {
	const op = "storage.AllAccount"

	query := "SELECT * FROM Account"
	rows, err := s.db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	accounts := []*types.Account{}
	for rows.Next() {
		account, err := scanIntoAccount(rows)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", op, err)
		}

		accounts = append(accounts, account)
	}

	return accounts, nil
}

func (s *Store) AccountByID(id int) (*types.Account, error) {
	const op = "storage.AccountByID"

	query := "SELECT * FROM Account WHERE id = $1"
	rows, err := s.db.Query(query, id)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}
	defer rows.Close()

	for rows.Next() {
		return scanIntoAccount(rows)
	}

	return nil, fmt.Errorf("%s: account with id = [%d] not found", op, id)
}

func (s *Store) UpdateAccount(acc *types.Account) error {
	const op = "storage.UpdateAccount"

	query := `UPDATE Account
  SET name = $1, first_name = $2, last_name = $3, role = $4, encrypted_password = $5, updated_at = $6
  WHERE id = $7;`

	_, err := s.db.Exec(
		query,
		acc.Name,
		acc.FirstName,
		acc.LastName,
		acc.Role,
		acc.EncryptedPassword,
		time.Now().UTC(),
		acc.ID,
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (s *Store) PatchAccount(id int, updates map[string]interface{}) error {
	const op = "storage.PatchAccount"

	if len(updates) == 0 {
		return fmt.Errorf("%s: no updates provided", op)
	}

	query := "UPDATE Account SET "
	args := []interface{}{}
	i := 1
	for field, value := range updates {
		query += fmt.Sprintf("%s = %d, ", field, i)
		args = append(args, value)
		i++
	}
	query += fmt.Sprintf("updated_at = $%d", i)
	args = append(args, time.Now().UTC())

	query += "WHERE id = $1"
	args = append(args, id)

	_, err := s.db.Exec(query, args...)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func scanIntoAccount(rows *sql.Rows) (*types.Account, error) {
	const op = "storage.scanIntoAccount"

	account := new(types.Account)

	var createdAtStr string
	var updatedAtStr string
	var role sql.NullString

	err := rows.Scan(
		&account.ID,
		&account.Name,
		&account.FirstName,
		&account.LastName,
		&role,
		&account.EncryptedPassword,
		&createdAtStr,
		&updatedAtStr,
	)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	createdAt, err := time.Parse(time.RFC3339, createdAtStr)
	if err != nil {
		return nil, fmt.Errorf("%s: created at: %w", op, err)
	}
	account.CreatedAt = createdAt

	updatedAt, err := time.Parse(time.RFC3339, updatedAtStr)
	if err != nil {
		return nil, fmt.Errorf("%s: updated at: %w", op, err)
	}
	account.UpdatedAt = updatedAt

	if role.Valid {
		account.Role = role.String
	} else {
		account.Role = "user"
	}

	return account, nil
}
