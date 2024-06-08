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
  id INTEGER NOT NULL PRIMARY KEY,
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
  ('Гавайская', 'Копченая курица, Ветчина, Ананасы, Чесночный соус, Сыр моцарелла.', './images/pizza/hawaiian.jpg', 1, 790.00),
  ('Греческая', 'Томат, Перец Болгарский, Огурцы Маринованные, Сыр фетака, Маслины, Лук красный, Томатный соус, Сыр моцарелла.', './images/pizza/greek.jpg', 1, 660.00),
  ('4 сыра', 'Пармезан, Дор-блю, Гауда, Моцарелла, Сливочный соус.', './images/pizza/four_cheeses.jpg', 1, 880.00),
  ('Пепперони', 'Пепперони, Томат, Огурцы маринованные, Перец халапеньо, Маслины, Томатный соус, Сыр моцарелла.', './images/pizza/pepperoni.jpg', 1, 810.00),
  ('Маргарита', 'Томат, Томатный соус, Сыр моцарелла.', './images/pizza/margarita.jpg', 1, 540.00),
  ('Ветчина и грибы', 'Ветчина, Томат, Шампиньоны, Чесночный соус, Сыр моцарелла.', './images/pizza/ham_and_mushrooms.jpg', 1, 670.00),
  ('Лас Венас', 'Куриное филе, Копченая курица, Пепперони, бекон, Шампиньоны, Огурцы Маринованные, Томат, Чесночный соус, Сыр моцарелла.', './images/pizza/las_vegas.jpg', 1, 820.00),
  ('Цезарь', 'Куриное филе, Лист салата, Томат, Томаты черри, Цезарь соус, Сыр моцарелла, Сыр пармезан.', './images/pizza/caesar.jpg', 1, 840.00),
  ('Ветчина бекон', 'Ветчина, Томат, Бекон, Чесночный соус, Сыр моцарелла.', './images/pizza/ham_and_bacon.jpg', 1, 700.00),
  ('Мясная', 'Свинина, Окорок, Бекон, Шампиньоны, Огурцы маринованные, Томат, Перец болгарский, Сырный соус, Сыр моцарелла.', './images/pizza/meat.jpg', 1, 990.00),
  ('Жюльен', 'Куриное филе, Шампиньоны, Лук, Сливочный соус, Сыр моцарелла.', './images/pizza/julien.jpg', 1, 840.00),
  ('Баварская', 'Баварские колбаски, Копченая курица, Бекон, Шампиньоны, Огурцы маринованные, Чесrочный соус, Сыр моцарелла.', './images/pizza/bavarian.jpg', 1, 860.00),
  ('Грибная', 'Маринованные опята, Шампиньоны, Лук, Сырный соус, Сыр моцарелла.', './images/pizza/mushroom.jpg', 1, 940.00),
  ('Ассорти', '1/2 Лас-Вегас, 1/2 Ветчина грибы, 1/2 Пицца-Шаверма, 1/2 Американо.', './images/pizza/assorti.jpg', 1, 1020.00),
  ('Барбекю', 'Копченая курица, Баварские колбаски, Томат, Шампиньоны, Лук красный, Барбекю соус, Сыр моцарелла.', './images/pizza/barbecue.jpg', 1, 860.00),
  ('Том-Ям', 'Креветки, Кальмар, Куриное филе, Шампиньоны, Томаты черри, Соус том-ям, Сыр моцарелла.', './images/pizza/tom_yam.jpg', 1, 1050.00),
  ('Американа', 'Куриное филе, Копченая курица, Огурцы Маринованные, Томат, Чесночный соус, Сыр моцарелла.', './images/pizza/americana.jpg', 1, 720.00),
  ('Итальяно', 'Пиперине, Ветчина, Чесночный соус, Сыр моцарелла, Сыр пармезан, Орегано.', './images/pizza/italiano.jpg', 1, 790.00),
  ('Сливночная', 'Копченая курица, Бекон, Шампиньоны, Томат, Сливочный соус, Сыр моцарелла.', './images/pizza/creamy.jpg', 1, 780.00),
  ('Пицца-Шаверма', 'Куриное филе, Томат, Огурцы маринованные, Морковь по-корейски, Чесночный соус, Фирменный соус-шаверма, Сыр моцарелла.', './images/pizza/shaverma.jpg', 1, 780.00),
  ('Карбонара', 'Окорок, Бекон, Томат, Яйцо, Чесночный соус, Сыр моцарелла, Сыр пармезан.', './images/pizza/carbonara.jpg', 1, 760.00),
  ('Филадельфия', 'Лосось, Снежный краб, Сливочный сыр, Сыр моцарелла.', './images/pizza/philadelphia.jpg', 1, 1000.00),
-- Rolls
  ('Филадельфия классик', 'Лосось, Сливочный сыр, Огурец.', './images/rolls/philadelphia_classic.jpg', 2, 580.00),
  ('Филадельфия с копченым лососем', 'Копченый лосось, Сливочный сыр, Огурец.', './images/rolls/philadelphia_smoked_salmon.jpg', 2, 580.00),
  ('Филадельфия креветка', 'Креветка, Огурец, Сливочный сыр.', './images/rolls/philadelphia_shrimp.jpg', 2, 520.00),
  ('Филадельфия Lite', 'Лосось, Сливочный сыр, Огурец.', './images/rolls/philadelphia_lite.jpg', 2, 360.00),
  ('Калифорния', 'Лосось, Сливочный сыр, Авокадо, Икра тобико', './images/rolls/california.jpg', 2, 420.00),
  ('Канада', 'Лосось, Угорь, Сливочный сыр, Авокадо.', './images/rolls/canada.jpg', 2, 550.00),
  ('Запеченный лосось', 'Лосось, Сливочный сыр, Авокадо, Икра тобика, Сырный соус.', './images/rolls/baked_salmon.jpg', 2, 520.00),
  ('Запеченная креветка', 'Креветка, Сливочный сыр, Авокадо, Сырный соус.', './images/rolls/baked_shrimp.jpg', 2, 480.00),
  ('Запеченный лосось с крабом', 'Лосось жареный, Снежный краб, Сырный соус, лук кранч.', './images/rolls/baked_salmon_crab.jpg', 2, 500.00),
  ('Токио', 'Лосось, Сливочный сыр, Огурец, Салат, Икра, Соус спайси, Соус унаги.', './images/rolls/tokyo.jpg', 2, 490.00),
  ('Малибу', 'Лосось, Омлет, Сливочный сыр, Огурец, Кунжут, Соуса, Икра тобика.', './images/rolls/malibu.jpg', 2, 480.00),
  ('Креветка темпура', 'Креветка, Сливочный сыр, Снежный краб.', './images/rolls/tempura_shrimp.jpg', 2, 460.00),
  ('Угорь темпура', 'Угорь, Сливочный сыр, Авокадо.', './images/rolls/tempura_eel.jpg', 2, 550.00),
  ('Запеченный бонито с угрем', 'угорь, сливочный сыр, огурец, стружка тунца, сырный соус.', './images/rolls/baked_bonito_eel.jpg', 2, 470.00),
  ('Копченый лосось с манго', 'Копченый лосось, Сливочный сыр, Огурец, Манго соус.', './images/rolls/smoked_salmon_mango.jpg', 2, 500.00),
  ('Лосось темпура', 'Лосось, Сливочный сыр.', './images/rolls/tempura_salmon.jpg', 2, 450.00),
  ('Кальмар темпура', 'Кальмарб Сливочный сыр, Сырный соус, Зелёный лун.', './images/rolls/tempura_squid.jpg', 2, 380.00),
-- Shaurma
  ('Шаурма классик', 'Курица с гриля, Огурцы свежие, Томат, Морковь по-корейски, Соус шаверма, Кетчуп.', './images/shaurma/shaurma_classic.jpg', 3, 260.00),
  ('Барбекю шаурма', 'Курица копченая, Курица с гриля, Бекон, Картофель фри, Томат, Огурцы Маринованные, Соус шаверма, Соус барбекю.', './images/shaurma/bbq_shaurma.jpg', 3, 350.00),
  ('Сырная шаурма', 'Курица с гриля, Сыр моцарелла, Томат, Сыр фета, Морковь по-корейски, Соус шаверма, Сырный соус.', './images/shaurma/chees_shaurma.jpg', 3, 300.00),
  ('Острая шаурма', 'Курица с гриля, Пепперони, Лук красный, Перец халапеньо, Томат, Морковь по-корейски, Соус шрирача, Соус шаверма.', './images/shaurma/spicy_shaurma.jpg', 3, 310.00),
  ('Гавайская шаурма', 'Курица копченая, Курица с гриля, Ананас, Томат, Морковь по-корейски, Сыр Моцарелла, Соус шаверма.', '.images/shaurma/hawaiian_shaurma.jpg', 3, 310.00),
  ('Том-ям шаурма', 'Креветки, Курица с гриля, Шампиньоны, Салат, Томат, Лук, Соус том-ям.', './images/shaurma/tom_yam_shaurma.jpg', 3, 380.00),
-- Shaverma
  ('Шаверма', 'Курица с гриля, Огурцы свежие, Томат, Морковь по-корейски, Соус шаверма, Кетчуп.', './images/shaverma/shaverma.jpg', 4, 380.00),
-- Sets
  ('Классика сет', 'Филадельфия Lite, Калифорния, Ролл с сыром и лососем, Ролл с омлетом', './images/sets/classic_set.jpg', 5, 1190.00),
  ('Филадельфия сет', 'Филадельфия классик, Филадельфия с копченым лососем, Филадельфия креветка, Филадельфия лосось с манго', './images/sets/philadelphia_set.jpg', 5, 1780.00),
  ('Темпурный сет', 'Лосось темпура, Кальмар темпура, Маки угорь темпура', './images/sets/tempurer_set.jpg', 5, 1060.00),
  ('Запеченный сет', 'Запеченный лосось с крабом, Токио, Малибу', './images/sets/baked_set.jpg', 5, 1220.00),
  ('Сытно и точка', 'Филадельфия Lite, Кальмар темпура, Запеченный лосось с крабом, Ролл с угрем и сыром, Ролл с омлетом', './images/sets/tasty_and_dot.jpg', 5, 1540.00),
-- Maki rolls
  ('Ролл с лососем', ' ', './images/maki_rolls/salmon.jpg', 6, 210.00),
  ('Ролл с лососем и огурцом', ' ', './images/maki_rolls/salmon_and_cucumber.jpg', 6, 220.00),
  ('Ролл с сыром и лососем', ' ', './images/maki_rolls/cheese_and_salmon.jpg', 6, 270.00),
  ('Ролл с копчёным лососем', ' ', './images/maki_rolls/smoked_salmon.jpg', 6, 260.00),
  ('Ролл с сыром и угрём', ' ', './images/maki_rolls/cheese_and_eel.jpg', 6, 330.00),
  ('Ролл омлетом', ' ', './images/maki_rolls/omelette.jpg', 6, 190.00),
  ('Ролл с огурцом', ' ', './images/maki_rolls/cucumber.jpg', 6, 150.00),
  ('Ролл с креветкой', ' ', './images/maki_rolls/shrimp.jpg', 6, 260.00),
  ('Ролл с крабом', ' ', './images/maki_rolls/crab.jpg', 6, 200.00),
-- Hot dishes
  ('Феттуччине с лососем', 'Паста, Лосось, Сливки, Сыр пармезан.', './images/hot_dishes/fettuccine_with_salmon.jpg', 7, 570.00),
  ('Феттуччине с грибами', 'Паста, Куриное филе, Шампиньоны, Сливки, Сыр пармезан.', './images/hot_dishes/fettuccine_with_mushrooms.jpg', 7, 420.00),
-- Soups
  ('Суп дня', ' ', './images/soups/soup_of_the_day.jpg', 8, 240.00),
  ('Том-Ям', '*подается  с рисом. Бульон том-ям, Мидии, Креветки, Кальмар, Шампиньоны, Томаты черри, Кокосовое молоко, Соус чили.', './images/soups/tom_yam.jpg', 8, 590.00),
-- Fast food
  ('Нагетсы куриные', ' ', './images/fast_food/chicken_nuggets.jpg', 9, 260.00),
  ('Картофель фри', ' ', './images/fast_food/fench_fries.jpg', 9, 160.00),
  ('Чизбургер', 'Булочка с кужутом, Домашняя котлета, Сыр, Томат, Огурцы маринованные, Лист салата, Лук красный, Кетчуп, Соус чесночный, Сырный соус.', './images/fast_food/cheeseburger.jpg', 9, 450.00),
  ('Тёмная сторона', 'Булочка с кунжутом, Говяжья котлета, Сыр, бекон, Лист салата, Огурцы маринованные, Лук красный, Сырный соус, Чесночный соус, Кетчуп.', './images/fast_food/dark_side.jpg', 9, 450.00),
-- Sauce
  ('Сырный', ' ', './images/sauce/cheese_sauce.jpg', 10, 90.00),
  ('Чесночный', ' ', './images/sauce/garlic_sauce.jpg', 10, 90.00),
  ('Томатный', ' ', './images/sauce/tomato_sauce.jpg', 10, 90.00),
  ('Кетчуп', ' ', './images/sauce/ketchup.jpg', 10, 90.00),
  ('Барбекю', ' ', './images/sauce/bbq.jpg', 10, 90.00),
-- Drinkables
  ('Морс', ' ', './images/drinkables/mors.jpg', 11, 80.00),
  ('Молочный коктейль', 'Клубничный, Ванильный или Шоколадный', './images/drinkables/milk_shake.jpg', 11, 240.00),
  ('Чай в чайнике', ' ', './images/drinkables/tea_in_a_teapot.jpg', 11, 250.00);
  
