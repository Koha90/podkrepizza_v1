package types

type Category struct {
	ID   int    `json:"id"   db:"id"`
	Name string `json:"name" db:"name"`
}

type Product struct {
	ID          int     `json:"id"          db:"id"`
	Name        string  `json:"name"        db:"name"`
	Description string  `json:"description" db:"description"`
	ImageURL    string  `json:"image_url"   db:"image_url"`
	Category    int     `json:"category"    db:"category"`
	Price       float64 `json:"price"       db:"price"`
}

func NewProduct(
	name string,
	description string,
	imageURL string,
	category int,
	price float64,
) *Product {
	return &Product{
		Name:        name,
		Description: description,
		ImageURL:    imageURL,
		Category:    category,
		Price:       price,
	}
}
