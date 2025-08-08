# Project Context for Claude

This is a Phoenix application, which uses Tailwind and daisyUI.
Prefer using LiveView instead of regular Controllers.

The code we generate should be high quality and responsive for mobile, ipad and laptop

## Phoenix Programming Guidelines
Please refer to AGENTS.md for detailed Phoenix, Elixir, and web development guidelines that must be followed when working on this project.

## Project Overview
- **Purpose**: Guest management system for properties/residences
- **Technology Stack**: Elixir/Phoenix with LiveView focus
- **Database**: PostgreSQL
- **UI Framework**: Tailwind CSS with daisyUI components
- **Authentication**: Custom user authentication with property-based access control

## Development Setup
- **Migrations**: Use `mix ecto.migrate` to update database and drive test suites
- **Testing**: `mix test` to run tests (prefer single test files for performance)
- **Compilation**: Always run `mix compile` after changes and fix any issues
- **Translations**: Run `mix gettext.extract --merge` after adding new translatable strings
- **Development Flow**: 
  1. Make changes
  2. Run `mix compile`
  3. Write/update tests
  4. Run `mix test [specific_test_file]`
  5. Update translations if needed

## Code Structure
- **LiveViews**: Primary UI components in `lib/trackguests3_web/live/`
- **Contexts**: Business logic in `lib/trackguests3/` (Persons, Accounts, Accomodation)
- **Templates**: `.heex` files for LiveView templates
- **CSS**: Custom styles in `assets/css/app.css` with luxury theme classes
- **Tests**: Mirror source structure in `test/` directory

## Current Focus Areas
- **Authentication & Authorization**: Property-based access control implemented
- **Mobile Integration**: Working on mobile app support
- **Test Coverage**: Ensuring comprehensive test coverage for all features
- **UI/UX**: Luxury theme with consistent styling across all pages

## Coding Standards
- **LiveView Preferred**: Use LiveView over Controllers for interactive pages
- **Property Isolation**: Users should only see/access data from their assigned property
- **Testing**: Write comprehensive tests for all changes
- **Performance**: Prefer targeted tests over full test suite runs
- **Security**: Never expose data across property boundaries

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
- **Template Coverage**: Settings page fully internationalized, visitor pages partially translated
- **Best Practice**: Always wrap user-facing strings with `gettext("String")`

## Authentication & Authorization
- **Authentication System**: Custom user authentication with session management
- **Property-Based Access**: Users are assigned to properties and can only access their property's data
- **Route Protection**: 
  - Public routes: `/visitor/check-in`, `/privacy`, `/tos`, `/guides`
  - Authenticated routes: `/visitor/check-out`, `/users/settings`, `/history`
  - Admin routes: `/admin/*` (requires admin flag)
- **Mount Hooks**: 
  - `:mount_current_scope` - Provides current user context
  - `:require_authenticated` - Requires user login
  - `:require_admin` - Requires admin privileges
- **Data Filtering**: All queries must filter by user's property to prevent data leakage

## CSS & Styling Guidelines
- **Theme System**: Luxury theme with light/dark mode support
- **CSS Classes**: 
  - `.input-luxury` - Custom input styling with proper contrast
  - `.btn-luxury` - Primary button styling
  - `.card-luxury` - Card component styling
  - `.gradient-bg-luxury` - Background gradients
- **Form Styling**: 
  - Labels positioned above inputs using flexbox
  - Select elements need custom styling for visibility
  - Use `prompt` parameter for select dropdowns
- **Responsive Design**: Mobile-first approach with lg: breakpoints

## Testing Patterns
- **Test Structure**: Mirror source directory structure in `test/`
- **Fixtures**: Use `*_fixture()` functions for test data creation
- **Authentication Tests**: Use `log_in_user(conn, user)` helper
- **LiveView Tests**: Use `live(conn, path)` and `render_click()` for interactions
- **Property Isolation Tests**: Always test that users only see their property's data
- **Common Patterns**:
  ```elixir
  test "shows only user's property data", %{conn: conn} do
    user = user_fixture()
    property = residence_fixture()
    {:ok, _user} = Accounts.update_user_property(user, %{property_id: property.id})
    # Create test data and verify filtering
  end
  ```

## Database Patterns
- **Property Relationships**: Most entities link to properties through residence_id
- **User Property Assignment**: Users have optional property_id field
- **Status Fields**: Use string enums like "checked_in", "checked_out"
- **Audit Fields**: Include created_at, updated_at timestamps
- **UUIDs**: Primary keys use UUID format

## Common Issues & Solutions
- **Ecto Query Issues**: 
  - `list_current_visitors_for_residence()` already executes query, don't call `Repo.all()`
  - Always preload associations when needed
- **Translation Issues**: 
  - Run `mix gettext.extract --merge` after adding gettext calls
  - Update translation files for supported languages (en, es, fr, de, it)
- **CSS Visibility**: 
  - Select elements need custom styling for proper contrast
  - Test in both light and dark themes
- **Authentication**: 
  - Visitor routes need to be moved to appropriate live_session based on auth requirements
  - Use `:with_current_scope` for optional auth, `:require_authenticated_user` for required auth

## External Dependencies
- **Core**: Phoenix, LiveView, Ecto, PostgreSQL
- **UI**: Tailwind CSS, daisyUI, HeroIcons
- **Auth**: Custom implementation with session tokens
- **Email**: Phoenix Mailer with custom templates
- **Testing**: ExUnit, Phoenix.LiveViewTest
- **Internationalization**: Gettext