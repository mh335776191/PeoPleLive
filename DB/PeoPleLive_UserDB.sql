--PeoPleLive_UserDB
USE master
DROP DATABASE PeoPleLive_UserDB
CREATE DATABASE PeoPleLive_UserDB ON
(
 NAME='PeoPlelive_UserDB',--数据文件的逻辑名称
 FILENAME='D:\PeoPleLive\DB\PeoPlelive_UserDB.mdf',--文件的物理名称
 SIZE=5MB,--初始大小
 MAXSIZE=100MB--文件增长的最大值
) LOG ON
(
NAME='PeoPlelive_UserDB_log',
filename='D:\PeoPleLive\DB\PeoPlelive_UserDB.log',
SIZE=2MB
)
--begin帐号相关
CREATE TABLE User_Normal--普通用户
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY
                               DEFAULT ( NEWID() ) ,
      UserLoginName NVARCHAR(20) NOT NULL ,
      UserMobile VARCHAR(20) NOT NULL ,
      PSW1 VARCHAR(32) NOT NULL ,
      PSW2 VARCHAR(32) NOT NULL ,
      LastUpdateDate DATETIME NOT NULL
                              DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )
CREATE TABLE User_Normal_Extend--普通用户扩展信息
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY ,
      UserRealName NVARCHAR(20) NOT NULL ,
      IDCard VARCHAR(18) ,
      BrithDay DATETIME ,
      Sex BIT ,
      UpDateDate DATETIME DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )
CREATE TABLE User_Reporter--记者基本信息
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY
                               DEFAULT ( NEWID() ) ,
      UserLoginName NVARCHAR(20) NOT NULL ,
      UserMobile VARCHAR(20) NOT NULL ,
      PSW1 VARCHAR(16) NOT NULL ,
      PSW2 VARCHAR(32) NOT NULL ,
      LastUpdateDate DATETIME NOT NULL
                              DEFAULT ( GETDATE() ) ,
      IsRealy BIT NOT NULL
                  DEFAULT ( 0 ) ,--是否通过认证
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Reporter_Extend--记者扩展信息
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY ,
      UserRealName NVARCHAR(20) NOT NULL ,
      IDCard VARCHAR(18) ,--身份证
      ReporterCard VARCHAR(30) ,--记者证
      BrithDay DATETIME ,
      Sex BIT ,
      OrganId INT ,--机构
      UpDateDate DATETIME DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Reporter_Organ--单位
    (
      Id INT IDENTITY(1, 1)
             PRIMARY KEY ,
      Name NVARCHAR(50) NOT NULL ,
      Phone VARCHAR(20) NOT NULL ,
      IsReal BIT NOT NULL
                 DEFAULT ( 0 ) ,--是否通过审核认证
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )
--end 帐号相关

--begin 账户金额相关
CREATE TABLE User_Account
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY ,
      Amount MONEY ,
      LastUpdateDate DATETIME NOT NULL
                              DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )
CREATE TABLE User_Account_Log
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      UserKey UNIQUEIDENTIFIER
        NOT NULL
        FOREIGN KEY REFERENCES User_Reporter ( UserKey )
        FOREIGN KEY REFERENCES User_Normal ( UserKey ) ,
      LogType TINYINT ,
      LogTypeDes NVARCHAR(10) ,
      Amount MONEY ,
      AccountBalance MONEY ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Message--用户收到的通知
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      UserKey UNIQUEIDENTIFIER
        NOT NULL
        FOREIGN KEY REFERENCES User_Reporter ( UserKey )
        FOREIGN KEY REFERENCES User_Normal ( UserKey ) ,
      Commnet NVARCHAR(300) NOT NULL ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Order
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      UserKey UNIQUEIDENTIFIER NOT NULL ,
      Amount MONEY NOT NULL ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )
--end