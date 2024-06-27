package storage

import (
	"database/sql"
	"fmt"

	"github.com/koha90/podkrepizza_v1/internal/types"
)

func (s *SQLStorage) CreateProduct(prod *types.Product) error {
	const op = "storage.CreateProduct"

	query := `INSERT INTO Products
  (name, description, image_url, category, price)
  VALUES ($1, $2, $3, $4, $5);`
	_, err := s.db.Exec(
		query,
		prod.Name,
		prod.Description,
		prod.ImageURL,
		prod.Category,
		prod.Price,
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (s *SQLStorage) DeleteProduct(id int) error {
	_, err := s.db.Exec("DELETE FROM Products WHERE id = $1", id)
	if err != nil {
		return err
	}

	return nil
}

func (s *SQLStorage) AllProducts() ([]*types.Product, error) {
	const op = "storage.AllProducts"

	query := "SELECT * FROM Products"
	rows, err := s.db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	products := []*types.Product{}
	for rows.Next() {
		product, err := scanIntoProduct(rows)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", op, err)
		}

		products = append(products, product)
	}

	return products, nil
}

func (s *SQLStorage) ProductByID(id int) (*types.Product, error) {
	const op = "storage.ProductByID"

	query := "SELECT * FROM Account WHERE id = $1"
	rows, err := s.db.Query(query, id)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}
	defer rows.Close()

	for rows.Next() {
		return scanIntoProduct(rows)
	}

	return nil, fmt.Errorf("%s: product with id = [%d] not found", op, id)
}

func (s *SQLStorage) UpdateProduct(prod *types.Product) error {
	const op = "storage.UpdateAccount"

	query := `UPDATE Products
  SET name = $1, description = $2, image_url = $3, category = $4, price = $5, WHERE id = $6;`

	_, err := s.db.Exec(
		query,
		prod.Name,
		prod.Description,
		prod.ImageURL,
		prod.Category,
		prod.Price,
		prod.ID,
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (s *SQLStorage) PatchProduct(id int, updates map[string]interface{}) error {
	const op = "storage.PatchProduct"

	if len(updates) == 0 {
		return fmt.Errorf("%s: no updates provided", op)
	}

	query := "UPDATE Products SET "
	args := []interface{}{}
	i := 1
	for field, value := range updates {
		query += fmt.Sprintf("%s = %d, ", field, i)
		args = append(args, value)
		i++
	}
	// query += fmt.Sprintf("updated_at = $%d", i)
	// args = append(args, time.Now().UTC())

	query += "WHERE id = $1"
	args = append(args, id)

	_, err := s.db.Exec(query, args...)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func scanIntoProduct(rows *sql.Rows) (*types.Product, error) {
	const op = "storage.scanIntoProduct"

	product := new(types.Product)

	err := rows.Scan(
		&product.ID,
		&product.Name,
		&product.Description,
		&product.ImageURL,
		&product.Category,
		&product.Price,
	)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}
	//
	// createdAt, err := time.Parse(time.RFC3339, createdAtStr)
	// if err != nil {
	// 	return nil, fmt.Errorf("%s: created at: %w", op, err)
	// }
	// account.CreatedAt = createdAt
	//
	// updatedAt, err := time.Parse(time.RFC3339, updatedAtStr)
	// if err != nil {
	// 	return nil, fmt.Errorf("%s: updated at: %w", op, err)
	// }
	// account.UpdatedAt = updatedAt
	//
	// if role.Valid {
	// 	account.Role = role.String
	// } else {
	// 	account.Role = "user"
	// }

	return product, nil
}
