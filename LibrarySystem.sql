USE LibrarySystem
GO

CREATE TABLE Category(
	CategoryID INT IDENTITY(1, 1) PRIMARY KEY,
	CategoryName VARCHAR(15) UNIQUE NOT NULL
)
GO

CREATE TABLE Book(
	BookID INT IDENTITY(1, 1) PRIMARY KEY,
	ISBN VARCHAR(13) UNIQUE NOT NULL CHECK(LEN(ISBN) = 13),
	Title VARCHAR(30) NOT NULL CHECK(Title IS NOT NULL),
	Publisher VARCHAR(30) NULL,
	PublicationYear INT NULL CHECK(PublicationYear BETWEEN 2000 AND YEAR(GETDATE())),
	CategoryID INT NOT NULL,
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
)
GO

CREATE TABLE Author(
	AuthorID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(15) NULL,
	LastName VARCHAR(15) NOT NULL 
)
GO

CREATE TABLE BookAuthor(
	BookID INT NOT NULL,
	AuthorID INT NOT NULL,
	PRIMARY KEY(BookID, AuthorID),
	FOREIGN KEY (BookID) REFERENCES Book(BookID),
	FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
)
GO

CREATE TABLE BookCopy(
	CopyID INT IDENTITY(1, 1)PRIMARY KEY,
	BookID INT NOT NULL,
	Barcode VARCHAR(30) UNIQUE NOT NULL,
	BookCondition VARCHAR(10) NOT NULL CHECK(BookCondition = 'New' OR BookCondition = 'Good' OR BookCondition = 'Worn' OR BookCondition = 'Damaged'),
	CopyStatus VARCHAR(10) NOT NULL DEFAULT 'Available' CHECK(CopyStatus = 'Available' OR CopyStatus = 'OnLoan' OR CopyStatus = 'Withdrawn'),
	ShelfLocation VARCHAR(10) NULL,
	FOREIGN KEY (BookID) REFERENCES Book(BookID)
)
GO

CREATE TABLE Membership(
	MemberID INT IDENTITY(1, 1) PRIMARY KEY,
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15) NOT NULL,
	Email VARCHAR(30) NOT NULL UNIQUE,
	PhoneNumber VARCHAR(13) NULL,
	JoinDate DATE NOT NULL DEFAULT GETDATE(),
	M_Status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK(M_Status = 'Active' OR M_Status = 'Suspended')
)
GO

CREATE TABLE Librarian(
	LibrarianID INT IDENTITY(1, 1) PRIMARY KEY,
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15) NOT NULL,
	Email VARCHAR(30) NOT NULL UNIQUE,
	LibrarianRole VARCHAR(30) NOT NULL CHECK(LibrarianRole = 'Librarian' OR LibrarianRole = 'Head Librarian')
)
GO

CREATE TABLE Loan(
	LoanID INT IDENTITY(1, 1) PRIMARY KEY,
	CopyID INT NOT NULL,
	MemberID INT NOT NULL,
	LibrarianID INT NOT NULL,
	LoanDate DATE NOT NULL DEFAULT GETDATE(),
	DueDate DATE NOT NULL,
	ReturnDate DATE NULL,
	CONSTRAINT CK_Loan_DueDate    CHECK (DueDate >= LoanDate),
	CONSTRAINT CK_Loan_ReturnDate CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate),
	FOREIGN KEY (CopyID) REFERENCES BookCopy(CopyID),
	FOREIGN KEY (MemberID) REFERENCES Membership(MemberID),
	FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID)
)
GO

CREATE TABLE Reservation(
	ReservationID INT IDENTITY(1, 1) PRIMARY KEY,
	BookID INT NOT NULL,
	MemberID INT NOT NULL,
	ReservedDate DATE NOT NULL DEFAULT GETDATE(),
	ExpiryDate DATE NOT NULL,
	R_Status VARCHAR(15) NOT NULL DEFAULT 'Pending' CHECK(R_Status = 'Pending' OR R_Status = 'Fulfilled' OR R_Status = 'Expired' OR R_Status = 'Cancelled'),
	CONSTRAINT CK_Reservation_Expiry CHECK (ExpiryDate >= ReservedDate),
	FOREIGN KEY (BookID) REFERENCES Book(BookID),
	FOREIGN KEY (MemberID) REFERENCES Membership(MemberID)
)
GO

CREATE TABLE Fine(
	FineID INT IDENTITY(1, 1) PRIMARY KEY,
	LoanID INT NOT NULL,
	Amount NUMERIC(10, 2) NOT NULL CHECK(Amount >= 0),
	IssuedDate DATE NOT NULL DEFAULT GETDATE(),
	PaidDate DATE NULL,
	F_Status VARCHAR(15) NOT NULL DEFAULT 'Unpaid' CHECK(F_Status = 'Unpaid' OR F_Status = 'Paid' OR F_Status = 'Waived'),
	FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
)
GO