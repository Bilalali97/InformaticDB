USE [MySystem]
GO
/****** Object:  StoredProcedure [dbo].[InsertUpdateUser]    Script Date: 01/09/2026 11:34:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[InsertUpdateUser]
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
