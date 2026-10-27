-- =============================================================================
-- ChelanCounty.gov / CMSAdmin 2.0 - County Calendar of Events Schema & Seeds
-- Dialect: Microsoft SQL Server (2016+ / 2019 / 2022 / Azure SQL)
-- Tables: dbo.calendar_event_categories, dbo.calendar_events
-- Safe to rerun (idempotent): creates tables, columns, indexes, and seeds data.
-- =============================================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- -----------------------------------------------------------------------------
-- 1. Table: dbo.calendar_event_categories
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calendar_event_categories]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[calendar_event_categories] (
        [id]          INT IDENTITY(1,1) NOT NULL,
        [name]        NVARCHAR(120) NOT NULL,
        [slug]        NVARCHAR(120) NOT NULL,
        [color]       NVARCHAR(30)  NOT NULL CONSTRAINT [DF_cal_event_cat_color] DEFAULT (N'#0284c7'),
        [badge_class] NVARCHAR(50)  NOT NULL CONSTRAINT [DF_cal_event_cat_badge] DEFAULT (N'badge-info'),
        [icon]        NVARCHAR(50)  NOT NULL CONSTRAINT [DF_cal_event_cat_icon]  DEFAULT (N'calendar'),
        [description] NVARCHAR(255) NULL,
        [sort_order]  INT NOT NULL CONSTRAINT [DF_cal_event_cat_sort]   DEFAULT (0),
        [is_active]   BIT NOT NULL CONSTRAINT [DF_cal_event_cat_active] DEFAULT (1),
        [is_system]   BIT NOT NULL CONSTRAINT [DF_cal_event_cat_system] DEFAULT (0),
        [createdat]   DATETIME2(7) NOT NULL CONSTRAINT [DF_cal_event_cat_createdat] DEFAULT (SYSUTCDATETIME()),
        [updatedat]   DATETIME2(7) NOT NULL CONSTRAINT [DF_cal_event_cat_updatedat] DEFAULT (SYSUTCDATETIME()),
        [deletedat]   DATETIME2(7) NULL,
        CONSTRAINT [PK_calendar_event_categories] PRIMARY KEY CLUSTERED ([id] ASC)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_calendar_event_categories_slug' AND object_id = OBJECT_ID(N'[dbo].[calendar_event_categories]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UQ_calendar_event_categories_slug]
        ON [dbo].[calendar_event_categories] ([slug] ASC)
        WHERE [deletedat] IS NULL;
END;
GO

-- Seed the 6 Standard Chelan County Event Categories
MERGE INTO [dbo].[calendar_event_categories] AS Target
USING (VALUES
    (N'Commissioners Meeting',       N'commissioners-meeting', N'#0284c7', N'badge-info',    N'building',     N'Board of County Commissioners regular sessions, workshops, and legislative briefings.', 10, 1, 1),
    (N'Public Hearing',              N'public-hearing',        N'#b45309', N'badge-warning', N'megaphone',    N'Official public hearings, land use dockets, budget hearings, and ordinance reviews.', 20, 1, 1),
    (N'Advisory Board & Committee',  N'advisory-board',        N'#7e22ce', N'badge-purple',  N'users',        N'Planning Commission, Noxious Weed Board, Lodging Tax, and citizen advisory committees.', 30, 1, 1),
    (N'Community Event & Outreach',  N'community-event',       N'#15803d', N'badge-success', N'calendar',     N'County Expo Center events, town halls, parks activities, and public workshops.', 40, 1, 1),
    (N'Holiday & Office Closure',    N'holiday-closure',       N'#b91c1c', N'badge-danger',  N'clock',        N'Official county holidays, courthouse closures, and modified department hours.', 50, 1, 1),
    (N'Elections & Civic Deadlines', N'elections-deadlines',   N'#0f172a', N'badge-neutral', N'check-square', N'Voter registration deadlines, ballot drop dates, tax due dates, and public trainings.', 60, 1, 1)
) AS Source ([name], [slug], [color], [badge_class], [icon], [description], [sort_order], [is_active], [is_system])
ON Target.[slug] = Source.[slug] AND Target.[deletedat] IS NULL
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([name], [slug], [color], [badge_class], [icon], [description], [sort_order], [is_active], [is_system], [createdat], [updatedat])
    VALUES (Source.[name], Source.[slug], Source.[color], Source.[badge_class], Source.[icon], Source.[description], Source.[sort_order], Source.[is_active], Source.[is_system], SYSUTCDATETIME(), SYSUTCDATETIME());
GO

-- -----------------------------------------------------------------------------
-- 2. Table: dbo.calendar_events
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calendar_events]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[calendar_events] (
        [id]                  INT IDENTITY(1,1) NOT NULL,
        [siteid]              NVARCHAR(100) NOT NULL CONSTRAINT [DF_calendar_events_siteid] DEFAULT (N'global'),
        [category_id]         INT NOT NULL,
        [title]               NVARCHAR(255) NOT NULL,
        [slug]                NVARCHAR(255) NOT NULL,
        [summary]             NVARCHAR(500) NULL,
        [description]         NVARCHAR(MAX) NULL,
        [start_date]          DATE NOT NULL,
        [end_date]            DATE NOT NULL,
        [start_time]          NVARCHAR(20) NULL,
        [end_time]            NVARCHAR(20) NULL,
        [is_all_day]          BIT NOT NULL CONSTRAINT [DF_calendar_events_allday] DEFAULT (0),
        [location_name]       NVARCHAR(255) NULL,
        [location_address]    NVARCHAR(255) NULL,
        [room_number]         NVARCHAR(120) NULL,
        [virtual_meeting_url] NVARCHAR(1000) NULL,
        [virtual_meeting_id]  NVARCHAR(120) NULL,
        [agenda_url]          NVARCHAR(1000) NULL,
        [minutes_url]         NVARCHAR(1000) NULL,
        [contact_name]        NVARCHAR(150) NULL,
        [contact_email]       NVARCHAR(150) NULL,
        [contact_phone]       NVARCHAR(60) NULL,
        [is_featured]         BIT NOT NULL CONSTRAINT [DF_calendar_events_featured] DEFAULT (0),
        [is_public_notice]    BIT NOT NULL CONSTRAINT [DF_calendar_events_notice] DEFAULT (0),
        [status]              NVARCHAR(30) NOT NULL CONSTRAINT [DF_calendar_events_status] DEFAULT (N'Published'),
        [publish_at]          DATETIME2 NULL,
        [unpublish_at]        DATETIME2 NULL,
        [created_by]          NVARCHAR(255) NULL,
        [modified_by]         NVARCHAR(255) NULL,
        [createdat]           DATETIME2(7) NOT NULL CONSTRAINT [DF_calendar_events_createdat] DEFAULT (SYSUTCDATETIME()),
        [updatedat]           DATETIME2(7) NOT NULL CONSTRAINT [DF_calendar_events_updatedat] DEFAULT (SYSUTCDATETIME()),
        [deletedat]           DATETIME2(7) NULL,
        CONSTRAINT [PK_calendar_events] PRIMARY KEY CLUSTERED ([id] ASC),
        CONSTRAINT [FK_calendar_events_categories] FOREIGN KEY ([category_id]) REFERENCES [dbo].[calendar_event_categories] ([id])
    );
END;
GO

IF COL_LENGTH(N'dbo.calendar_events', N'publish_at') IS NULL
BEGIN
    ALTER TABLE [dbo].[calendar_events] ADD [publish_at] DATETIME2 NULL;
END;
IF COL_LENGTH(N'dbo.calendar_events', N'unpublish_at') IS NULL
BEGIN
    ALTER TABLE [dbo].[calendar_events] ADD [unpublish_at] DATETIME2 NULL;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_calendar_events_dates_site' AND object_id = OBJECT_ID(N'[dbo].[calendar_events]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_calendar_events_dates_site]
        ON [dbo].[calendar_events] ([start_date] ASC, [end_date] ASC, [siteid] ASC, [category_id] ASC)
        WHERE [deletedat] IS NULL;
END;
GO

-- -----------------------------------------------------------------------------
-- 3. Seed County Calendar Events (Idempotent by slug)
-- -----------------------------------------------------------------------------
DECLARE @catComm INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'community-event' AND deletedat IS NULL);
DECLARE @catElec INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'elections-deadlines' AND deletedat IS NULL);
DECLARE @catAdv  INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'advisory-board' AND deletedat IS NULL);
DECLARE @catBocc INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'commissioners-meeting' AND deletedat IS NULL);
DECLARE @catHear INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'public-hearing' AND deletedat IS NULL);
DECLARE @catHol  INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'holiday-closure' AND deletedat IS NULL);
IF @catComm IS NULL SET @catComm = (SELECT TOP 1 id FROM dbo.calendar_event_categories ORDER BY id ASC);
IF @catElec IS NULL SET @catElec = @catComm;
IF @catAdv  IS NULL SET @catAdv  = @catComm;
IF @catBocc IS NULL SET @catBocc = @catComm;
IF @catHear IS NULL SET @catHear = @catComm;
IF @catHol  IS NULL SET @catHol  = @catComm;

MERGE INTO dbo.calendar_events AS Target
USING (VALUES
    (N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-oct-5', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners, including public comment, consent agenda, and administrative updates.', '2026-10-05', '2026-10-05', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
    (N'board-of-commissioners', @catComm, N'District 1 Fall Community Meeting', N'district-1-fall-community-meeting', N'Community town hall and county update for District 1 residents.', N'Join Chelan County leadership for the District 1 Fall Community Meeting in Wenatchee to discuss road projects, county services, and upcoming priorities.', '2026-10-07', '2026-10-07', N'18:00', N'19:30', 0, N'Wenatchee Community Center', N'400 Douglas St, Wenatchee, WA 98801', N'Main Hall', N'', N'', N'Published', 1, 0),
    (N'elections', @catElec, N'Local Voters'' Pamphlet Mailed', N'local-voters-pamphlet-mailed', N'Official Chelan County Local Voters'' Pamphlets mailed to all residential households.', N'The Chelan County Elections Office mails the Official Local Voters'' Pamphlet for the November General Election to registered households county-wide.', '2026-10-09', '2026-10-09', N'', N'', 1, N'Elections Office', N'350 Orondo Ave, Wenatchee, WA 98801', N'Level 3', N'', N'/elections', N'Published', 0, 0),
    (N'board-of-commissioners', @catHear, N'Public Hearing: 2027 Preliminary County Budget', N'public-hearing-2027-preliminary-budget', N'Official public hearing on departmental budget requests and revenue forecasts for 2027.', N'The Board of County Commissioners holds a public hearing to review the 2027 preliminary county budget and take public testimony.', '2026-10-13', '2026-10-13', N'10:30', N'12:00', 0, N'BOCC Chambers', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 1),
    (N'elections', @catAdv, N'Logic & Accuracy Test (Public Meeting)', N'logic-and-accuracy-test-public-meeting', N'Official pre-election Logic & Accuracy test of ballot tabulation equipment.', N'Public test of the Chelan County ballot tabulation system prior to the General Election. Open to public observation in accordance with Washington State election law.', '2026-10-15', '2026-10-15', N'10:00', N'11:30', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
    (N'elections', @catElec, N'Ballots Mailed — General Election', N'ballots-mailed-general-election', N'General Election ballots mailed to all active registered voters in Chelan County.', N'Ballots for the November General Election are mailed today. Official ballot drop boxes open across Chelan County.', '2026-10-16', '2026-10-16', N'', N'', 1, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'', N'', N'/elections', N'Published', 1, 0),
    (N'global', @catComm, N'Wenatchee Kennel Club Dog Show', N'wenatchee-kennel-club-dog-show', N'Annual Wenatchee Kennel Club all-breed dog show and agility trials.', N'Hosted at the Chelan County Expo Center in Cashmere. Open to spectators and exhibitors throughout the weekend.', '2026-10-16', '2026-10-18', N'08:00', N'17:00', 0, N'Chelan County Expo Center', N'5700 Wescott Dr, Cashmere, WA 98815', N'Pavilion', N'', N'', N'Published', 0, 0),
    (N'community-development', @catAdv, N'Chelan County Planning Commission Meeting', N'planning-commission-meeting-oct-21', N'Monthly public meeting of the Chelan County Planning Commission.', N'Review of comprehensive plan amendments, land use dockets, and community development updates.', '2026-10-21', '2026-10-21', N'17:30', N'19:30', 0, N'Community Development', N'316 Washington St, Wenatchee, WA 98801', N'Suite 301', N'https://zoom.us/j/chelancounty', N'', N'Published', 0, 1),
    (N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-oct-26', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners, including public comment, consent agenda, and administrative updates.', '2026-10-26', '2026-10-26', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
    (N'elections', @catElec, N'Online & Mail Voter Registration Deadline', N'voter-registration-deadline-oct-26', N'Last day for online and mail-in voter registrations and address updates for the General Election.', N'Voters may still register or update their registration in person at the Chelan County Elections Office through Election Day.', '2026-10-26', '2026-10-26', N'08:00', N'17:00', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
    (N'natural-resources', @catAdv, N'Noxious Weed Control Board Quarterly Meeting', N'noxious-weed-board-oct-28', N'Quarterly board meeting covering seasonal weed management and landowner outreach.', N'Public meeting of the Chelan County Noxious Weed Control Board.', '2026-10-28', '2026-10-28', N'13:30', N'15:00', 0, N'Natural Resources Department', N'411 Washington St, Wenatchee, WA 98801', N'Suite 201', N'', N'', N'Published', 0, 0),
    (N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-nov-2', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners.', '2026-11-02', '2026-11-02', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
    (N'elections', @catElec, N'General Election Day — Ballots Due by 8:00 PM', N'general-election-day-nov-3', N'Ballots must be deposited in an official drop box by 8:00 PM or postmarked by Election Day.', N'Chelan County Elections Office and official ballot drop boxes remain open until 8:00 PM sharp on Election Day.', '2026-11-03', '2026-11-03', N'08:00', N'20:00', 0, N'County-Wide Drop Boxes & Elections Office', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
    (N'public-works', @catComm, N'Monthly Drop-Off Saturday — Moderate Risk Waste', N'monthly-drop-off-saturday-nov-7', N'Drop-Off Saturday at the Chelan County Moderate Risk Waste Facility.', N'Hosted by Chelan County Solid Waste Management for household hazardous waste disposal.', '2026-11-07', '2026-11-07', N'09:00', N'15:00', 0, N'Moderate Risk Waste Facility', N'Wenatchee, WA', N'', N'', N'', N'Published', 0, 0),
    (N'community-development', @catHear, N'Planning Commission Public Hearing', N'planning-commission-hearing-nov-18', N'Public hearing on zoning code updates and short-term rental regulations.', N'Public hearing before the Chelan County Planning Commission.', '2026-11-18', '2026-11-18', N'17:30', N'19:30', 0, N'Community Development', N'316 Washington St, Wenatchee, WA 98801', N'Suite 301', N'https://zoom.us/j/chelancounty', N'', N'Published', 1, 1),
    (N'elections', @catElec, N'County Canvassing Board — Election Certification', N'canvassing-board-certification-nov-24', N'Official certification of the November General Election returns.', N'The Chelan County Canvassing Board convenes in public session to certify the official results of the General Election.', '2026-11-24', '2026-11-24', N'10:00', N'11:00', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
    (N'board-of-commissioners', @catHear, N'Public Hearing: Final 2027 County Budget Adoption', N'public-hearing-2027-final-budget-dec-1', N'Final public hearing and adoption of the 2027 Chelan County Operating and Capital Budget.', N'The Board of County Commissioners conducts the final public hearing on the 2027 budget.', '2026-12-01', '2026-12-01', N'10:00', N'12:00', 0, N'BOCC Chambers', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 1),
    (N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-dec-7', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners.', '2026-12-07', '2026-12-07', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
    (N'global', @catHol, N'Christmas Day — County Offices Closed', N'christmas-day-closure-2026', N'Chelan County Courthouse and administrative offices closed in observance of Christmas Day.', N'All non-emergency county offices are closed in observance of Christmas Day.', '2026-12-25', '2026-12-25', N'', N'', 1, N'Chelan County Courthouse', N'400 Douglas St, Wenatchee, WA 98801', N'', N'', N'', N'Published', 0, 0)
) AS Source (siteid, category_id, title, slug, summary, description, start_date, end_date, start_time, end_time, is_all_day, location_name, location_address, room_number, virtual_meeting_url, agenda_url, status, is_featured, is_public_notice)
ON Target.slug = Source.slug AND Target.deletedat IS NULL
WHEN NOT MATCHED BY TARGET THEN
    INSERT (siteid, category_id, title, slug, summary, description, start_date, end_date, start_time, end_time, is_all_day, location_name, location_address, room_number, virtual_meeting_url, agenda_url, status, is_featured, is_public_notice, created_by)
    VALUES (Source.siteid, Source.category_id, Source.title, Source.slug, Source.summary, Source.description, Source.start_date, Source.end_date, Source.start_time, Source.end_time, Source.is_all_day, Source.location_name, Source.location_address, Source.room_number, Source.virtual_meeting_url, Source.agenda_url, Source.status, Source.is_featured, Source.is_public_notice, N'System');
GO

