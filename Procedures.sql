USE [MySystem]
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 01/09/2026 11:56:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteUser]
@ID int
as
begin Try 
IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @ID)
    BEGIN
        RAISERROR('error accured aa', 16, 1);
        RETURN;
    END
delete from Users Where UserID = @ID
end Try
BEGIN CATCH
    PRINT 'Error';
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 01/09/2026 11:56:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetUsers]
@Username nvarchar(50) = null,
@Email nvarchar(50) = null,
@FirstName nvarchar(50) = null,
@LastName nvarchar(50) = null,
@Active BIT = null,
@FromDate DATE = NULL,
    @ToDate DATE = NULL,
	@SortColumn nvarchar(50) = 'UserID',
	@SortDirection nvarchar(4) = "ASC",
	@PageNumber INT = 1,
    @PageSize INT = 10
as
Begin Try
	
    SELECT 
        UserID,
        Username,
        FirstName,
        LastName,
        Email,
        IsActive,
        CreatedAt 
    FROM Users 

    WHERE (@Username IS NULL OR Username LIKE '%' + @Username + '%')
      AND (@FirstName IS NULL OR FirstName LIKE '%' + @FirstName + '%')
      AND (@LastName IS NULL OR LastName LIKE '%' + @LastName + '%')
      AND (@Email IS NULL OR Email LIKE '%' + @Email + '%')
      AND (@Active IS NULL OR IsActive = @Active)
      AND (@FromDate IS NULL OR CAST(CreatedAt AS DATE) >= @FromDate)
      AND (@ToDate IS NULL OR CAST(CreatedAt AS DATE) <= @ToDate)
	 
	 Order By 
		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'UserID' THEN UserID END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'UserID' THEN UserID END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'Username' THEN Username END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'Username' THEN Username END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'FirstName' THEN FirstName END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'FirstName' THEN FirstName END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'LastName' THEN LastName END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'LastName' THEN LastName END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'Email' THEN Email END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'Email' THEN Email END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'IsActive' THEN IsActive END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'IsActive' THEN IsActive END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn = 'CreatedAt' THEN CreatedAt END ASC,
        CASE WHEN @SortDirection = 'DESC' AND @SortColumn = 'CreatedAt' THEN CreatedAt END DESC,

		CASE WHEN @SortDirection = 'ASC' AND @SortColumn IS NULL THEN UserID END ASC,
		CASE WHEN @SortDirection = 'DESC' AND @SortColumn IS NULL THEN UserID END DESC

	  OFFSET (@PageNumber - 1) * @PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY;

	  SELECT COUNT(*) AS TotalItems
    FROM Users 
    WHERE (@Username IS NULL OR Username LIKE '%' + @Username + '%')
      AND (@FirstName IS NULL OR FirstName LIKE '%' + @FirstName + '%')
      AND (@LastName IS NULL OR LastName LIKE '%' + @LastName + '%')
      AND (@Email IS NULL OR Email LIKE '%' + @Email + '%')
      AND (@Active IS NULL OR IsActive = @Active)
      AND (@FromDate IS NULL OR CAST(CreatedAt AS DATE) >= @FromDate)
      AND (@ToDate IS NULL OR CAST(CreatedAt AS DATE) <= @ToDate);

End Try
BEGIN CATCH
        PRINT 'Error';
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[InsertUpdateUser]    Script Date: 01/09/2026 11:56:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[InsertUpdateUser]
@ID int = 0,
@Username nvarchar(50),
@FirstName VARCHAR(50),
    @LastName VARCHAR(50) = null,
	@Email VARCHAR(100),
    @PasswordHash VARCHAR(255),
	@IsActive Bit = 1
	as
	 BEGIN TRY 
	 If(@ID = 0)
	 begin
		insert into Users (Username,Email,PasswordHash,FirstName,LastName,IsActive,CreatedAt)
		Values (@Username,@Email,@PasswordHash,@FirstName,@LastName,@IsActive,GetDate());
		end
		else
		begin
		update Users
		SET Username = @Username,
            Email = @Email,
            PasswordHash = @PasswordHash,
            FirstName = @FirstName,
            LastName = @LastName,
            IsActive = @IsActive
			where UserID =  @ID
		end
	 END TRY
    BEGIN CATCH

        PRINT 'Error';
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH

GO
