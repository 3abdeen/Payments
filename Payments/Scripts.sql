USE [master]
GO
/****** Object:  Database [PaymentsDB]    Script Date: 22-May-25 2:12:32 PM ******/
CREATE DATABASE [PaymentsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PaymentPortalDB', FILENAME = N'C:\Users\Ahmed\PaymentPortalDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PaymentPortalDB_log', FILENAME = N'C:\Users\Ahmed\PaymentPortalDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PaymentsDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PaymentsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PaymentsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PaymentsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PaymentsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PaymentsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PaymentsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [PaymentsDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PaymentsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PaymentsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PaymentsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PaymentsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PaymentsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PaymentsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PaymentsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PaymentsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PaymentsDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PaymentsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PaymentsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PaymentsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PaymentsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PaymentsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PaymentsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PaymentsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PaymentsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PaymentsDB] SET  MULTI_USER 
GO
ALTER DATABASE [PaymentsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PaymentsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PaymentsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PaymentsDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PaymentsDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PaymentsDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PaymentsDB] SET QUERY_STORE = OFF
GO
USE [PaymentsDB]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Reference] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfiles](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[PasswordSalt] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[LastLogin] [datetime] NULL,
	[IsLocked] [bit] NULL,
 CONSTRAINT [PK__UserProf__1788CCAC9A49D81D] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__UserProf__536C85E4CAC37D2A] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__UserProf__A9D1053486900689] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserProfiles] ADD  CONSTRAINT [DF__UserProfi__Creat__6383C8BA]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserProfiles] ADD  CONSTRAINT [DF__UserProfi__IsLoc__6477ECF3]  DEFAULT ((0)) FOR [IsLocked]
GO
/****** Object:  StoredProcedure [dbo].[sp_AuthenticateUser]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuthenticateUser]
    @Username NVARCHAR(50)
AS
BEGIN
    SELECT UserID, PasswordHash, PasswordSalt, IsLocked 
    FROM UserProfiles 
    WHERE Username = @Username
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetTransactions]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Updated Get Procedure
CREATE   PROCEDURE [dbo].[sp_GetTransactions]
    @UserID INT = NULL
AS
BEGIN
    SELECT 
        TransactionID,
        UserID,
        Amount,
        CONVERT(VARCHAR(20), TransactionDate, 120) AS TransactionDate,
        Description,
        Status,
        Reference
    FROM Transactions
    WHERE @UserID IS NULL OR UserID = @UserID
    ORDER BY TransactionDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetTransactionsByDate]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetTransactionsByDate]
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT * FROM Transactions
    WHERE TransactionDate BETWEEN @StartDate AND @EndDate
    ORDER BY TransactionDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertTransaction]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertTransaction]
    @UserID INT,
        @Amount DECIMAL(18,2),
    @TransactionDate DATETIME,
    @Description NVARCHAR(255),
    @Status NVARCHAR(50),
    @Reference NVARCHAR(100)
AS
BEGIN
    INSERT INTO Transactions 
    (UserID, Amount, TransactionDate, Description, Status, Reference)
    VALUES 
    (@UserID, @Amount, @TransactionDate, @Description, @Status, @Reference)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RegisterUser]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RegisterUser]
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(128),
    @PasswordSalt NVARCHAR(128),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO UserProfiles 
    (Username, PasswordHash, PasswordSalt, Email)
    VALUES
    (@Username, @PasswordHash, @PasswordSalt, @Email)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateTransaction]    Script Date: 22-May-25 2:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateTransaction]
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATETIME,
    @Description NVARCHAR(255),
    @Status NVARCHAR(50)
AS
BEGIN
    UPDATE Transactions SET
        Amount = @Amount,
        TransactionDate = @TransactionDate,
        Description = @Description,
        Status = @Status
    WHERE TransactionID = @TransactionID
END
GO
USE [master]
GO
ALTER DATABASE [PaymentsDB] SET  READ_WRITE 
GO
