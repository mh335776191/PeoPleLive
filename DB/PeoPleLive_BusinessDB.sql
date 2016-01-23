USE master
DROP DATABASE PeoPleLive_BusinessDB

CREATE DATABASE PeoPleLive_BusinessDB ON
(
 NAME='PeoPleLive_BusinessDB',--�����ļ����߼�����
 FILENAME='D:\PeoPleLive\DB\PeoPleLive_BusinessDB.mdf',--�ļ�����������
 SIZE=5MB,--��ʼ��С
 MAXSIZE=100MB--�ļ����������ֵ
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
      PublishUserMobile VARCHAR(20) NOT NULL ,--��������
      Content NVARCHAR(2000) NOT NULL ,
      Truth INT NOT NULL
                DEFAULT ( 0 ) ,
      Mislead INT NOT NULL
                  DEFAULT ( 0 ) ,
      IsTake BIT NOT NULL ,--�Ƿ�����
      IsTop BIT NOT NULL
                DEFAULT ( 0 ) ,--�Ƿ�Ӽ��ö�
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

CREATE TABLE New_Pool_Dissent--����ȷ�����ʱ��������������飬վ�����
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      Comment NVARCHAR(1000) NOT NULL ,--���鷴��֤��
      IsPass BIT NOT NULL ,--�����Ƿ���Ч
      OperAdminId INT ,--ƽ̨������
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )


CREATE TABLE New_Take_Log--��������־
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      TakeUserkey UNIQUEIDENTIFIER ,
      TakeUserName NVARCHAR(20) ,
      TakeMobile VARCHAR(20) ,
      TakeDate DATETIME ,
      IsConfirmTrue BIT NOT NULL
                        DEFAULT ( 0 ) ,--�Ƿ�ȷ����ʵ
      Comment NVARCHAR(1000) NOT NULL ,--ȷ����Ϣ
      IsSystem BIT NOT NULL
                   DEFAULT ( 0 ) ,--�Ƿ���ϵͳ��ʱ�Զ�����
      CreateDate DATETIME DEFAULT ( GETDATE() )
    )

CREATE TABLE New_Comment--����
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      ParentId INT FOREIGN KEY REFERENCES New_Comment ( Id ) ,
      CreateDate DATETIME NOT NULL
                          DEFAULT ( GETDATE() )
    )

CREATE TABLE New_VoteLog--ͶƱ��־
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      IsGood BIT NOT NULL
                 DEFAULT ( 0 ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
                          NOT NULL
    )

CREATE TABLE New_UpdateLog--�޸���־
    (
      Id INT PRIMARY KEY
             IDENTITY(1, 1) ,
      PoolId INT FOREIGN KEY REFERENCES News_Pool ( Id ) ,
      CreateDate DATETIME DEFAULT ( GETDATE() )
                          NOT NULL
    )
	 