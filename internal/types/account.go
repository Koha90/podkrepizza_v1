package types

import (
	"fmt"
	"time"

	"golang.org/x/crypto/bcrypt"
)

type CreateAccountRequest struct {
	Name      string `json:"name"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name,omitempty"`
	Password  string `json:"password"`
}

type Account struct {
	ID                int       `json:"id"`
	Name              string    `json:"name"`
	FirstName         string    `json:"first_name"`
	LastName          string    `json:"last_name,omitempty"`
	Role              string    `json:"role"`
	EncryptedPassword string    `json:"-"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
}

func (a *Account) ValidatePassword(pw string) bool {
	return bcrypt.CompareHashAndPassword([]byte(a.EncryptedPassword), []byte(pw)) == nil
}

func NewAccount(name, firstName, lastName, password string) (*Account, error) {
	const op = "internal.types.NewAccount"

	encpw, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("%s: could not generate password: %w", op, err)
	}

	role := "user"

	location, err := time.LoadLocation("Asia/Yekaterinburg")
	if err != nil {
		return nil, fmt.Errorf("%s: could not load location: %w", op, err)
	}

	currentTime := time.Now().In(location)

	return &Account{
		Name:              name,
		FirstName:         firstName,
		LastName:          lastName,
		Role:              role,
		EncryptedPassword: string(encpw),
		CreatedAt:         currentTime,
		UpdatedAt:         currentTime,
	}, nil
}
