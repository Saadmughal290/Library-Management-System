-- Library Management System Database
-- CSC 337 - Web Programming Languages

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Table 1: Members
CREATE TABLE IF NOT EXISTS members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Books
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    category VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    published_year YEAR,
    cover_image VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 3: Borrow Records
CREATE TABLE IF NOT EXISTS borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    fine DECIMAL(6,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Table 4: Admin Users
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 5: Contact Messages
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200),
    message TEXT NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default admin: username=admin, password=admin123
INSERT INTO admins (username, password, full_name) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Library Administrator');
-- Note: password hash above is for 'password' (Laravel default). Replace with your own bcrypt hash.
-- To generate: password_hash('admin123', PASSWORD_BCRYPT)

-- Sample Books
INSERT INTO books (title, author, isbn, category, total_copies, available_copies, published_year, description) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565', 'Fiction', 3, 3, 1925, 'A story of the mysteriously wealthy Jay Gatsby and his love for Daisy Buchanan.'),
('To Kill a Mockingbird', 'Harper Lee', '978-0061935466', 'Fiction', 2, 2, 1960, 'The unforgettable novel of a childhood in a sleepy Southern town.'),
('1984', 'George Orwell', '978-0451524935', 'Dystopian', 4, 4, 1949, 'A dystopian social science fiction novel and cautionary tale.'),
('Clean Code', 'Robert C. Martin', '978-0132350884', 'Technology', 2, 2, 2008, 'A handbook of agile software craftsmanship.'),
('Introduction to Algorithms', 'Thomas H. Cormen', '978-0262033848', 'Technology', 3, 3, 2009, 'A comprehensive introduction to modern algorithms.'),
('Sapiens', 'Yuval Noah Harari', '978-0062316097', 'History', 2, 2, 2011, 'A brief history of humankind.'),
('The Alchemist', 'Paulo Coelho', '978-0062315007', 'Fiction', 3, 3, 1988, 'A journey of self-discovery and following ones dreams.'),
('Atomic Habits', 'James Clear', '978-0735211292', 'Self-Help', 2, 2, 2018, 'An easy and proven way to build good habits and break bad ones.');

-- Sample Members
INSERT INTO members (name, email, phone, address, membership_date, status) VALUES
('Alice Johnson', 'alice@example.com', '0300-1234567', '123 Main St, Lahore', '2024-01-15', 'active'),
('Bob Smith', 'bob@example.com', '0311-2345678', '456 Oak Ave, Karachi', '2024-02-20', 'active'),
('Carol White', 'carol@example.com', '0321-3456789', '789 Pine Rd, Islamabad', '2024-03-10', 'active'),
('David Brown', 'david@example.com', '0331-4567890', '321 Elm St, Lahore', '2024-01-05', 'inactive');

-- Sample Borrow Records
INSERT INTO borrow_records (member_id, book_id, borrow_date, due_date, return_date, status) VALUES
(1, 1, '2025-05-01', '2025-05-15', '2025-05-14', 'returned'),
(2, 3, '2025-05-20', '2025-06-03', NULL, 'borrowed'),
(3, 4, '2025-05-25', '2025-06-08', NULL, 'borrowed'),
(1, 5, '2025-04-01', '2025-04-15', NULL, 'overdue');

-- Update available copies for borrowed books
UPDATE books SET available_copies = available_copies - 1 WHERE id IN (3, 4, 5);
