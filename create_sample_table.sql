-- inventory.orders definition

CREATE TABLE `orders` (
  `order_number` int NOT NULL AUTO_INCREMENT,
  `order_date` date NOT NULL,
  `purchaser` int NOT NULL,
  `quantity` int NOT NULL,
  `product_id` int NOT NULL,
  `_updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_number`),
  KEY `order_customer` (`purchaser`),
  KEY `ordered_product` (`product_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`purchaser`) REFERENCES `customers` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;