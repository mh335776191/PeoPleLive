USE master
DROP DATABASE PeoPleLive_BusinessDB

CREATE DATABASE PeoPleLive_BusinessDB ON
(
 NAME='PeoPleLive_BusinessDB',--数据文件的逻辑名称
 FILENAME='D:\PeoPleLive\DB\PeoPleLive_BusinessDB.mdf',--文件的物理名称
 SIZE=5MB,--初始大小
 MAXSIZE=100MB--文件增长的最大值
) LOG ON
(
NAME='PeoPleLive_BusinessDB_log',
FILENAME='D:\PeoPleLive\DB\PeoPleLive_BusinessDB.log',
SIZE=2MB
)

CREATE TABLE News_Pool
    (
      Id INT PRIMARY KEY NONCLUSTERED
             IDENTITY(1, 1) ,
      PublishUserKey UNIQUEIDENTIFIER DEFAULT ( NEWID() ) ,
      PublishUserName NVARCHAR(20) NOT NULL ,
      PublishUserMobile VARCHAR(20) NOT NULL ,--冗余数据
      Content NVARCHAR(2000) NOT NULL ,
      Truth INT NOT NULL
                DEFAULT ( 0 ) ,
      Mislead INT NOT NULL
                  DEFAULT ( 0 ) ,
      IsTake BIT NOT NULL ,--是否被认领
      IsTop BIT NOT NULL
                DEFAULT ( 0 ) ,--是否加急置顶
      TakeUserkey UNIQUEIDENTIFIER ,
      TakeUserName NVARCHAR(20) ,
      TakeMobile VARCHAR(20) ,
      TakeDate DATETIME ,
      LastUpdateDate DATETIME NOT NULL
                              DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE CLUSTERED INDEX CX_PublishDate ON News_Pool(CreateDate)

CREATE TABLE New_Pool_Dissent--当被确认虚假时，发布人提出异议，站点介入
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      Comment NVARCHAR(1000) NOT NULL ,--异议反对证据
      IsPass BIT NOT NULL ,--异议是否有效
      OperAdminId INT ,--平台操作人
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )


CREATE TABLE New_Take_Log--被认领日志
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      TakeUserkey UNIQUEIDENTIFIER ,
      TakeUserName NVARCHAR(20) ,
      TakeMobile VARCHAR(20) ,
      TakeDate DATETIME ,
      IsConfirmTrue BIT NOT NULL
                        DEFAULT ( 0 ) ,--是否确认真实
      Comment NVARCHAR(1000) NOT NULL ,--确认信息
      IsSystem BIT NOT NULL
                   DEFAULT ( 0 ) ,--是否是系统超时自动处理
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )

CREATE TABLE New_Comment--评论
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      ParentId INT FOREIGN KEY REFERENCES New_Comment ( Id ) ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE New_VoteLog--投票日志
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      IsGood BIT NOT NULL
                 DEFAULT ( 0 ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
                          NOT NULL
    )

CREATE TABLE New_UpdateLog--修改日志
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
                          NOT NULL
    )
	 