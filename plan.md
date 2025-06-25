# TrackGuests3 Exploration Plan

## Understanding the Application
- [x] Clone the repository successfully
- [x] Set up dependencies and database (switched to SQLite)
- [x] Explore the existing schema and data models
- [x] Review the LiveView implementations
- [x] Start the server to see current state
- [ ] Analyze what's working and what needs improvement

## Current Understanding
This is a multi-tenant guest tracking system with:

### Data Models (Working)
- **Residences**: Buildings with title, address, floor_count, logo (binary_id primary keys)
- **Rooms**: Individual rooms within residences (title, floor, needs_fob, memo, accepts_guests)
- **Persons**: People associated with rooms (planned but not yet implemented)

### Current State
- ✅ Database migrations working (residences, rooms tables created)
- ✅ LiveView interfaces for residences and rooms (basic CRUD)
- ✅ Phoenix server running on http://localhost:4000
- ✅ Basic table views showing empty lists
- ❌ Still using default Phoenix layout/styling
- ❌ Missing persons/guests functionality
- ❌ No authentication system yet
- ❌ No real guest tracking features

### What's Working
- `/residences` - Lists residences with "New Residence" button
- `/rooms` - Lists rooms with "New Rooms" button  
- Both have empty tables ready for data

### What Needs Work
- [ ] Complete the persons/guests data model and LiveViews
- [ ] Implement actual guest check-in/check-out workflow
- [ ] Add user authentication (mentioned in README but not implemented)
- [ ] Custom styling and layout design
- [ ] Navigation between residences -> rooms -> guests
- [ ] Real-world guest tracking features

## Next Steps
- [ ] Explore the existing LiveView code to understand the architecture
- [ ] Test creating residences and rooms to see full workflow
- [ ] Identify missing pieces for a complete guest tracking system
- [ ] Plan enhancements based on what you need

