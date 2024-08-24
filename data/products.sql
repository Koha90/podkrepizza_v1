DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Cart;

-- Таблица пользователей сайта.
CREATE TABLE IF NOT EXISTS Account (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT,
  role TEXT DEFAULT 'user',
  encrypted_password TEXT NOT NULL,
  created_at DATETIME,
  updated_at DATETIME
);

-- Таблица категорий блюд.
CREATE TABLE IF NOT EXISTS Categories (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

-- Таблица блюд.
CREATE TABLE IF NOT EXISTS Products (
  id INTEGER NOT NULL PRIMARY KEY,mrKoha
  name TEXT,
  description TEXT,
  image_url TEXT,
  category INTEGER,
  price DECIMAL(8, 2),
  CONSTRAINT CatRef FOREIGN KEY(Category) REFERENCES Categories(id)
);

-- Таблица корзмны.
CREATE TABLE IF NOT EXISTS Cart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  paid BOOLEAN,
  created_at DATETIME,
  updatet_at DATETIME,
  FOREIGN KEY (account_id) REFERENCES Account(id)
  FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE INDEX IF NOT EXISTS idx_products_category_id ON Products (category);
CREATE INDEX IF NOT EXISTS idx_cart_account_id ON Cart (account_id);
CREATE INDEX IF NOT EXISTS idx_cart_product_id ON Cart (product_id);

-- Вставка категории.
INSERT INTO Categories (name) VALUES
  ('Пицца'),
  ('Роллы'),
  ('Шаурма'),
  ('Шаверма'),
  ('Сеты'),
  ('Маки роллы'),
  ('Горячие блюда'),
  ('Супы'),
  ('Фаст фуд'),
  ('Соусы'),
  ('Напитки');

INSERT INTO Products (name, description, image_url, category, price) VALUES
-- Pizza
  ('Гавайская', 'Копченая курица, Ветчина, Ананасы, Чесночный соус, Сыр моцарелла.', './img/pizza/hawaiian.jpg', 1, 790.00),
  ('4 сыра', 'Пармезан, Дор-блю, Гауда, Моцарелла, Сливочный соус.', './img/pizza/four_cheeses.jpg', 1, 880.00),
  ('Пепперони', 'Пепперони, Томат, Огурцы маринованные, Перец халапеньо, Маслины, Томатный соус, Сыр моцарелла.', './img/pizza/pepperoni.jpg', 1, 810.00),
  ('Маргарита', 'Томат, Томатный соус, Сыр моцарелла.', './img/pizza/margarita.jpg', 1, 540.00),
  ('Лас Вегас', 'Куриное филе, Копченая курица, Пепперони, бекон, Шампиньоны, Огурцы Маринованные, Томат, Чесночный соус, Сыр моцарелла.', './img/pizza/las_vegas.jpg', 1, 820.00),mrKoha
  ('Ветчина бекон', 'Ветчина, Томат, Бекон, Чесночный соус, Сыр моцарелла.', './img/pizza/ham_and_bacon.jpg', 1, 700.00),
  ('Мясная', 'Свинина, Окорок, Бекон, Шампиньоны, Огурцы маринованные, Томат, Перец болгарский, Сырный соус, Сыр моцарелла.', './img/pizza/meat.jpg', 1, 990.00),
  ('Жюльен', 'Куриное филе, Шампиньоны, Лук, Сливочный соус, Сыр моцарелла.', './img/pizza/julien.jpg', 1, 840.00),
  ('Баварская', 'Баварские колбаски, Копченая курица, Бекон, Шампиньоны, Огурцы маринованные, Чесrочный соус, Сыр моцарелла.', './img/pizza/bavarian.jpg', 1, 860.00),
  ('Грибная', 'Маринованные опята, Шампиньоны, Лук, Сырный соус, Сыр моцарелла.', './img/pizza/mushroom.jpg', 1, 940.00),
  ('Ассорти', '1/4 Лас-Вегас, 1/4 Ветчина грибы, 1/4 Пицца-Шаверма, 1/4 Американо.', './img/pizza/assorti.jpg', 1, 1020.00),
  ('Американа', 'Куриное филе, Копченая курица, Огурцы Маринованные, Томат, Чесночный соус, Сыр моцарелла.', './img/pizza/americana.jpg', 1, 720.00),
  ('Сливночная', 'Копченая курица, Бекон, Шампиньоны, Томат, Сливочный соус, Сыр моцарелла.', './img/pizza/creamy.jpg', 1, 780.00),
  ('Пицца-Шаверма', 'Куриное филе, Томат, Огурцы маринованные, Морковь по-корейски, Чесночный соус, Фирменный соус-шаверма, Сыр моцарелла.', './img/pizza/shaverma.jpg', 1, 780.00),
  ('Диабло', 'Пепперони, салями, шампиньоны, перец халапеньо, томаты, оливки, томатный соус , сыр моцарелла', './img/pizza/diablo.jpg', 1, 860.00),
  ('Морская', 'Мидии, кальмар, креветки, лосось, томат, сливочный соус, сыр моцарелла.', './img/pizza/morska.jpg', 1, 1190.00),
  ('Деревенская', 'Копченая курица, куриное филе, шампиньоны, опята маринованные , огурцы маринованные, красный лук, горчичный соус, чесночный соус, сыр моцарелла.', './img/pizza/deresenska.jpg', 1, 990.00),
-- Rolls
  ('Филадельфия классик', 'Лосось, Сливочный сыр, Огурец.', './img/rolls/philadelphia_classic.jpg', 2, 580.00),
  ('Филадельфия с копченым лососем', 'Копченый лосось, Сливочный сыр, Огурец.', './img/rolls/philadelphia_smoked_salmon.jpg', 2, 580.00),
  ('Филадельфия креветка', 'Креветка, Огурец, Сливочный сыр.', './img/rolls/philadelphia_shrimp.jpg', 2, 520.00),
  ('Филадельфия Lite', 'Лосось, Сливочный сыр, Огурец.', './img/rolls/philadelphia_lite.jpg', 2, 360.00),
  ('Калифорния', 'Лосось, Сливочный сыр, Авокадо, Икра тобико', './img/rolls/california.jpg', 2, 420.00),
  ('Запеченный лосось', 'Лосось, Сливочный сыр, Авокадо, Икра тобика, Сырный соус.', './img/rolls/baked_salmon.jpg', 2, 520.00),
  ('Запеченная креветка', 'Креветка, Сливочный сыр, Авокадо, Сырный соус.', './img/rolls/baked_shrimp.jpg', 2, 480.00),
  ('Креветка темпура', 'Креветка, Сливочный сыр, Снежный краб.', './img/rolls/tempura_shrimp.jpg', 2, 460.00),
  ('Запеченный бонито с угрем', 'угорь, сливочный сыр, огурец, стружка тунца, сырный соус.', './img/rolls/baked_bonito_eel.jpg', 2, 470.00),
  ('Копченый лосось с манго', 'Копченый лосось, Сливочный сыр, Огурец, Манго соус.', './img/rolls/smoked_salmon_mango.jpg', 2, 500.00),
  ('Лосось темпура', 'Лосось, Сливочный сыр.', './img/rolls/tempura_salmon.jpg', 2, 450.00),
  ('Кальмар темпура', 'Кальмарб Сливочный сыр, Сырный соус, Зелёный лун.', './img/rolls/tempura_squid.jpg', 2, 380.00),
-- Shaurma
  ('Шаурма классик', 'Курица с гриля, Огурцы свежие, Томат, Морковь по-корейски, Соус шаверма, Кетчуп.', './img/shaurma/shaurma_classic.jpg', 3, 240.00),
  ('Сырная шаурма', 'Курица с гриля, Сыр моцарелла, Томат, Сыр фета, Морковь по-корейски, Соус шаверма, Сырный соус.', './img/shaurma/chees_shaurma.jpg', 3, 300.00),
  ('Острая шаурма', 'Курица с гриля, Пепперони, Лук красный, Перец халапеньо, Томат, Морковь по-корейски, Соус шрирача, Соус шаверма.', './img/shaurma/spicy_shaurma.jpg', 3, 310.00),
-- Shaverma
  ('Шаверма', 'Курица с гриля, Огурцы свежие, Томат, Морковь по-корейски, Соус шаверма, Кетчуп.', './img/shaverma/shaverma.jpg', 4, 260.00),
-- Sets
  ('Классика сет', 'Филадельфия Lite, Калифорния, Ролл с сыром и лососем, Ролл с омлетом', './img/sets/classic_set.jpg', 5, 1190.00),
  ('Филадельфия сет', 'Филадельфия классик, Филадельфия с копченым лососем, Филадельфия креветка, Филадельфия лосось с манго', './img/sets/philadelphia_set.jpg', 5, 1780.00),
  ('Темпурный сет', 'Лосось темпура, Кальмар темпура, Маки угорь темпура', './img/sets/tempurer_set.jpg', 5, 1060.00),
  ('Запеченный сет', 'Запеченный лосось с крабом, Токио, Малибу', './img/sets/baked_set.jpg', 5, 1220.00),
  ('Сытно и точка', 'Филадельфия Lite, Кальмар темпура, Запеченный лосось с крабом, Ролл с угрем и сыром, Ролл с омлетом', './img/sets/tasty_and_dot.jpg', 5, 1540.00),
-- Maki rolls
  ('Ролл с лососем', ' ', './img/maki_rolls/salmon.jpg', 6, 210.00),
  ('Ролл с лососем и огурцом', ' ', './img/maki_rolls/salmon_and_cucumber.jpg', 6, 220.00),
  ('Ролл с сыром и лососем', ' ', './img/maki_rolls/cheese_and_salmon.jpg', 6, 270.00),
  ('Ролл с копчёным лососем', ' ', './img/maki_rolls/smoked_salmon.jpg', 6, 260.00),
  ('Ролл с сыром и угрём', ' ', './img/maki_rolls/cheese_and_eel.jpg', 6, 330.00),
  ('Ролл омлетом', ' ', './img/maki_rolls/omelette.jpg', 6, 190.00),
  ('Ролл с огурцом', ' ', './img/maki_rolls/cucumber.jpg', 6, 150.00),
  ('Ролл с креветкой', ' ', './img/maki_rolls/shrimp.jpg', 6, 260.00),
  ('Ролл с крабом', ' ', './img/maki_rolls/crab.jpg', 6, 200.00),
-- Hot dishes
  ('Феттуччине с лососем', 'Паста, Лосось, Сливки, Сыр пармезан.', './img/hot_dishes/fettuccine_with_salmon.jpg', 7, 570.00),
  ('Феттуччине с грибами', 'Паста, Куриное филе, Шампиньоны, Сливки, Сыр пармезан.', './img/hot_dishes/fettuccine_with_mushrooms.jpg', 7, 420.00),
-- Soups
  ('Суп дня', ' ', './img/soups/soup_of_the_day.jpg', 8, 240.00),
  ('Том-Ям', '*подается  с рисом. Бульон том-ям, Мидии, Креветки, Кальмар, Шампиньоны, Томаты черри, Кокосовое молоко, Соус чили.', './img/soups/tom_yam.jpg', 8, 590.00),
-- Fast food
  ('Нагетсы куриные', ' ', './img/fast_food/chicken_nuggets.jpg', 9, 260.00),
  ('Картофель фри', ' ', './img/fast_food/french_fries.jpg', 9, 160.00),
  ('Чизбургер', 'Булочка с кужутом, Домашняя котлета, Сыр, Томат, Огурцы маринованные, Лист салата, Лук красный, Кетчуп, Соус чесночный, Сырный соус.', './img/fast_food/cheeseburger.jpg', 9, 450.00),
  ('Тёмная сторона', 'Булочка с кунжутом, Говяжья котлета, Сыр, бекон, Лист салата, Огурцы маринованные, Лук красный, Сырный соус, Чесночный соус, Кетчуп.', './img/fast_food/dark_side.jpg', 9, 450.00),
-- Sauce
  ('Сырный', ' ', './img/sauce/cheese_sauce.jpg', 10, 90.00),
  ('Чесночный', ' ', './img/sauce/garlic_sauce.jpg', 10, 90.00),
  ('Томатный', ' ', './img/sauce/tomato_sauce.jpg', 10, 90.00),
  ('Кетчуп', ' ', './img/sauce/ketchup.jpg', 10, 90.00),
  ('Барбекю', ' ', './img/sauce/bbq.jpg', 10, 90.00),
  ('Майонез', ' ', './img/sauce/mayonnaise.jpg', 10, 90.00),
  ('Кисло-сладкий', ' ', './img/sauce/sweet_and_sour.jpg', 10, 90.00),
  ('Чилли-острый', ' ', './img/sauce/chilli_ostre.jpg', 10, 90.00),
-- Drinkables
  ('Морс', ' ', './img/drinkables/mors.jpg', 11, 80.00),
  ('Молочный коктейль', 'Клубничный, Ванильный или Шоколадный', './img/drinkables/milk_shake.jpg', 11, 240.00),
  ('Чай в чайнике', ' ', './img/drinkables/tea_in_a_teapot.jpg', 11, 250.00);
  -- Burgers
  
