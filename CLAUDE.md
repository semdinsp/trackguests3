# Project Context for Claude

This is a Phoenix application, which uses Tailwind and daisyUI.
Prefer using LiveView instead of regular Controllers.

The code we generate should be high quality and responsive for mobile, ipad and laptop

## Project Overview
- Purpose and goals
- elixir with phoenix with a focus on live view
- database is postgres

## Development Setup
- Installation steps
    we use migrations to update database and drive test suites.
- Environment variables
- Local development commands
    mix test: to test
- This is a Phoenix application, which uses Tailwind and daisyUI.
Prefer using LiveView instead of regular Controllers.
Once you are done with changes, run `mix compile` and fix any issues.
Write tests for your changes and run `mix test` afterwards.
    

## Code Structure
- Directory organization
- Key files and their purposes
- Naming conventions

## Current Focus Areas
- I am working on getting all tests to run and support for integration with a mobile app
- Known issues or technical debt
- Upcoming features

## Coding Standards
- Style guidelines
- Testing approach
- Prefer running single tests, and not the whole test suite, for performance
- We need user guides for key features
- We need feature overview

## Internationalization (i18n)
- **Localization System**: Uses Phoenix's gettext for internationalization
- **Supported Languages**: 11 languages total
  - **Fully Translated**: English (en), Spanish (es), French (fr), German (de), Italian (it)
  - **Templates Available**: Portuguese (pt), Japanese (ja), Korean (ko), Chinese (zh), Russian (ru), Arabic (ar)
- **User Locale Selection**: Users can select preferred language in settings page
- **Locale Persistence**: User locale choice is stored in database and persists across sessions
- **Translation Files**: Located in `priv/gettext/[locale]/LC_MESSAGES/`
- **Adding Translations**:
  1. Use `gettext("String to translate")` in templates
  2. Run `mix gettext.extract --merge` to update POT/PO files
  3. Add translations to appropriate locale files
  4. Compile with `mix compile`
- **Template Coverage**: Settings page fully internationalized, other pages need expansion

## External Dependencies
- Key libraries and their purposes
- API integrations
- Database schema (if applicable)