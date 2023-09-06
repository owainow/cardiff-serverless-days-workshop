CREATE TABLE [dbo].[todos]
(
	[id] [uniqueidentifier] NOT NULL,
	[title] [nvarchar](1000) NOT NULL,	
	[completed] [bit] NOT NULL,
	[owner_id] [varchar](128) NOT NULL,
	[position] INT NULL,
	[duedate] [DATE] NOT NULL
) 
GO
ALTER TABLE [dbo].[todos] ADD PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)
GO
ALTER TABLE [dbo].[todos] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[todos] ADD  DEFAULT ((0)) FOR [completed]
GO
ALTER TABLE [dbo].[todos] ADD  DEFAULT ('public') FOR [owner_id]
GO
ALTER TABLE [dbo].[todos] ADD  DEFAULT ('17082024') FOR [duedate]
GO
