# TrackGuests3 Exploration Plan

## Understanding the Application
- [x] Clone the repository successfully
- [ ] Set up dependencies and database
- [ ] Explore the existing schema and data models
- [ ] Review the LiveView implementations
- [ ] Start the server to see current state
- [ ] Analyze what's working and what needs improvement

## Current Understanding
From the README's installation notes, this appears to be a multi-tenant guest tracking system with:

### Data Models
- **Residences**: Buildings with title, address, floor_count, logo
- **Rooms**: Individual rooms within residences (title, floor, needs_fob, memo, accepts_guests)
- **Persons**: People associated with rooms (name, sex, memo, resident/visitor/staff flags, contact info)

### Generated Components
- Uses binary_id primary keys
- Has LiveView interfaces for CRUD operations
- Planned to have user authentication (phx.gen.auth mentioned)
- Uses PostgreSQL as database

## Next Steps
- [ ] Get the app running locally
- [ ] Explore the current UI and functionality
- [ ] Identify areas for improvement or completion
- [ ] Plan enhancements based on what you need
