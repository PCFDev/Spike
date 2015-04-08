--https://open.med.harvard.edu/svn/shrine/releases/1.18.2/code/service/src/main/resources/create_broadcaster_audit_table.sql
CREATE TABLE [dbo].[AUDIT_ENTRY](
	[AUDIT_ENTRY_ID] [int] IDENTITY(1,1) NOT NULL,
	[PROJECT] [varchar](254) NOT NULL,
	[USERNAME] [varchar](254) NOT NULL,
	[DOMAIN_NAME] [varchar](254) NOT NULL,
	[TIME] [datetime] NOT NULL DEFAULT getdate(),
	[QUERY_TEXT] [text] NULL,
	[QUERY_TOPIC] [varchar](245) NULL,
 CONSTRAINT [PK_AUDIT_ENTRY] PRIMARY KEY CLUSTERED ([AUDIT_ENTRY_ID] ASC)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IDX_AUDIT_ENTRY_DOMAIN_USERNAME_QUERY_TOPIC] ON [dbo].[AUDIT_ENTRY]
(
	[DOMAIN_NAME] ASC,
	[USERNAME] ASC,
	[QUERY_TOPIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO