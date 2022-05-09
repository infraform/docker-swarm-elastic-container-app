CREATE TABLE phonebook_db.phonebook(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    number VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
INSERT INTO phonebook_db.phonebook (name, number)
VALUES ("Enes", "1234567890"),
    ("Johnny Depp", "67854"),
    ("Bruce Wayne", "23524562"),
    ("Cillian Murphy", "987654321"),
    ("Christian Bale", "123456789");