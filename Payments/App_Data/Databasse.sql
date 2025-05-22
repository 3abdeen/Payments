CREATE DATABASE PaymentPortalDB;
GO

USE PaymentPortalDB;
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    Amount DECIMAL(18,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending'
);
GO

CREATE PROCEDURE sp_InsertTransaction
    @UserID INT,
    @Amount DECIMAL(18,2),
    @Description NVARCHAR(255),
    @Status NVARCHAR(50) = 'Pending'
AS
BEGIN
    INSERT INTO Transactions (UserID, Amount, Description, Status)
    VALUES (@UserID, @Amount, @Description, @Status)
END
GO

CREATE PROCEDURE sp_GetTransactions
    @UserID INT = NULL
AS
BEGIN
    SELECT 
        TransactionID,
        Amount,
        CONVERT(VARCHAR(20), TransactionDate, 120) AS TransactionDate,
        Description,
        Status
    FROM Transactions
    WHERE @UserID IS NULL OR UserID = @UserID
    ORDER BY TransactionDate DESC
END
GO
CREATE PROCEDURE sp_GetTransactionsByDate
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT * FROM Transactions
    WHERE TransactionDate BETWEEN @StartDate AND @EndDate
    ORDER BY TransactionDate DESC
END
GO