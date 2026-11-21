<h1 align="center">Community Library & Book Lending System</h1>

<p align="center">
  <b>Library Database</b> · MS SQL Server
</p>

<p align="center">
  <img alt="MS SQL Server" src="https://img.shields.io/badge/MS_SQL_SERVER-000000?style=for-the-badge&logo=microsoftsqlserver&logoColor=white">
  <img alt="T-SQL" src="https://img.shields.io/badge/T--SQL-000000?style=for-the-badge">
  <img alt="Status" src="https://img.shields.io/badge/STATUS-SCHEMA_WRITTEN-000000?style=for-the-badge">
</p>

---

## The problem

A community library needs to know who has borrowed which copy of a book, when it is due, who is waiting for a title, and which fines are still unpaid.

This database models that: books and their physical copies, authors, members, librarians, loans, reservations and fines.

## Where this project is

| Done | Still to do |
|---|---|
| ERD designed | Sample data |
| T-SQL schema written: 10 tables with keys and constraints | Queries and views for reporting |
| | Business rules that need code, such as updating a copy's status when it is lent |

## Data model

```mermaid
erDiagram
    Category ||--o{ Book : classifies
    Book ||--o{ BookAuthor : "listed in"
    Author ||--o{ BookAuthor : "credited in"
    Book ||--o{ BookCopy : "has copies"
    Book ||--o{ Reservation : "reserved as"
    Membership ||--o{ Reservation : makes
    BookCopy ||--o{ Loan : "lent in"
    Membership ||--o{ Loan : borrows
    Librarian ||--o{ Loan : issues
    Loan ||--o{ Fine : "can incur"
```

## Design decisions

| Decision | Why |
|---|---|
| **`Book` separate from `BookCopy`** | A title can have many physical copies, and a loan needs to point at the exact copy that was lent |
| **`BookAuthor` junction table** | A book can have several authors and an author several books |
| **Reservations on `Book`, loans on `BookCopy`** | A member waits for a title, but borrows one specific copy |
| **`Librarian` recorded on every `Loan`** | Each loan shows who issued it |
| **`Fine` linked to `Loan`** | A fine is always tied to the loan that caused it |
| **CHECK constraints** | Business rules enforced in the database: 13-character ISBN, valid statuses and conditions, due date not before loan date, fines of 0 or more |
| **Defaults** | Dates default to today and statuses to `Available`, `Active`, `Pending` and `Unpaid` |

## What's inside

| File | Purpose |
|---|---|
| `LibrarySystem.sql` | The 10 tables, with keys, constraints and defaults |

## Run it yourself

1. Create a database called `LibrarySystem` in SQL Server Management Studio or Azure Data Studio.
2. Run `LibrarySystem.sql`.

---

<p align="center">
  Part of my portfolio · <a href="https://rabogale-matjokotja.github.io">rabogale-matjokotja.github.io</a>
</p>
