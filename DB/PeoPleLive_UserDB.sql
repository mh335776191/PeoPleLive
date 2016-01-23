--PeoPleLive_UserDB
USE master
DROP DATABASE PeoPleLive_UserDB
CREATE DATABASE PeoPleLive_UserDB ON
(
 NAME='PeoPlelive_UserDB',--�����ļ����߼�����
 FILENAME='D:\PeoPleLive\DB\PeoPlelive_UserDB.mdf',--�ļ�����������
 SIZE=5MB,--��ʼ��С
 MAXSIZE=100MB--�ļ����������ֵ
) LOG ON
(
NAME='PeoPlelive_UserDB_log',
filename='D:\PeoPleLive\DB\PeoPlelive_UserDB.log',
SIZE=2MB
)
--begin�ʺ����
CREATE TABLE User_Normal--��ͨ�û�
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
CREATE TABLE User_Normal_Extend--��ͨ�û���չ��Ϣ
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY ,
      UserRealName NVARCHAR(20) NOT NULL ,
      IDCard VARCHAR(18) ,
      BrithDay DATETIME ,
      Sex BIT ,
      UpDateDate DATETIME DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )
CREATE TABLE User_Reporter--���߻�����Ϣ
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
                  DEFAULT ( 0 ) ,--�Ƿ�ͨ����֤
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Reporter_Extend--������չ��Ϣ
    (
      UserKey UNIQUEIDENTIFIER PRIMARY KEY ,
      UserRealName NVARCHAR(20) NOT NULL ,
      IDCard VARCHAR(18) ,--���֤
      ReporterCard VARCHAR(30) ,--����֤
      BrithDay DATETIME ,
      Sex BIT ,
      OrganId INT ,--����
      UpDateDate DATETIME DEFAULT ( GETDATE() ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )

CREATE TABLE User_Reporter_Organ--��λ
    (
      Id INT IDENTITY(1, 1)
             PRIMARY KEY ,
      Name NVARCHAR(50) NOT NULL ,
      Phone VARCHAR(20) NOT NULL ,
      IsReal BIT NOT NULL
                 DEFAULT ( 0 ) ,--�Ƿ�ͨ�������֤
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )
--end �ʺ����

--begin �˻�������
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

CREATE TABLE User_Message--�û��յ���֪ͨ
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