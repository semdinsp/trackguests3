# TrackGuests Admin Guide: Property and Room Management

This comprehensive guide will help administrators manage properties (residences) and rooms within the TrackGuests system, including bulk room uploads via CSV.

## Table of Contents
- [Getting Started](#getting-started)
- [Property Management](#property-management)
- [Room Management](#room-management)
- [CSV Room Upload](#csv-room-upload)
- [User Management](#user-management)
- [Data Export and Reports](#data-export-and-reports)
- [System Maintenance](#system-maintenance)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Accessing Admin Panel
1. Log in to TrackGuests with your admin account
2. Navigate to `/admin` or click the **"Admin Panel"** link
3. You'll see the admin dashboard with management options

### Admin Dashboard Overview
The dashboard provides quick access to:
- **Users**: Manage user accounts and permissions
- **Residences**: Manage properties/buildings
- **Rooms**: View and manage individual rooms
- **Persons**: View visitor and staff records

### Required Permissions
- **Admin Status**: You must have admin privileges enabled
- **System Access**: Proper authentication and session management
- **Browser Requirements**: Modern browser with JavaScript enabled

## Property Management

### Understanding Properties (Residences)
Properties in TrackGuests represent:
- **Buildings**: Office buildings, residential complexes
- **Facilities**: Hotels, conference centers, campuses
- **Locations**: Any place with multiple rooms or units

### Creating a New Property

#### Step 1: Access Property Management
1. From the admin dashboard, click **"Residences"**
2. Click the **"New Residence"** button
3. The property creation form will open

#### Step 2: Enter Property Information
Fill out the required fields:

- **Title**: Property name (e.g., "Main Office Building", "Residence Hall A")
- **Address**: Full street address including:
  - Street number and name
  - City, state/province
  - Postal/ZIP code
  - Country (if international)
- **Floor Count**: Total number of floors in the building

#### Step 3: Bulk Room Import (Optional)
If you have multiple rooms to add, you can upload them via CSV:

1. **Prepare CSV Data**: See [CSV Room Upload](#csv-room-upload) section
2. **Paste CSV Content**: In the "Bulk Room Import" section
3. **Preview**: The system will show a preview of rooms to be created
4. **Validation**: Any errors will be displayed for correction

#### Step 4: Save Property
1. Review all information for accuracy
2. Click **"Save Residence"**
3. The property will be created and you'll return to the properties list
4. If CSV data was included, rooms will be automatically created

### Editing Existing Properties

#### Accessing Property for Editing
1. From the **Residences** list, click on any property row
2. Or click the **"Edit"** button for the specific property
3. The edit form will open with current information pre-filled

#### Making Changes
- **Update Information**: Modify title, address, or floor count as needed
- **Add More Rooms**: Use the CSV import feature to add additional rooms
- **Save Changes**: Click **"Save Residence"** to apply updates

### Deleting Properties

#### Important Considerations
⚠️ **Warning**: Deleting a property will also delete all associated rooms and their visit history

#### Deletion Process
1. From the **Residences** list, locate the property to delete
2. Click the **"Delete"** button for that property
3. Confirm the deletion when prompted
4. The property and all associated data will be permanently removed

## Room Management

### Understanding Rooms
Rooms represent individual units within properties:
- **Office Rooms**: Individual offices, meeting rooms
- **Residential Units**: Apartments, hotel rooms, dorm rooms
- **Common Areas**: Lobbies, conference rooms, shared spaces

### Room Properties
Each room has the following attributes:
- **Title**: Room identifier (e.g., "Room 101", "Conference Room A")
- **Floor**: Which floor the room is located on
- **Needs FOB**: Whether access requires a key card/fob
- **Memo**: Additional notes or descriptions
- **Accepts Guests**: Whether the room allows visitors

### Viewing Rooms
1. From the admin dashboard, click **"Rooms"**
2. You'll see a list of all rooms across all properties
3. The list shows:
   - Room title and floor
   - FOB requirements
   - Guest acceptance status
   - Associated residence/property

### Managing Individual Rooms

#### Room Details
Each room displays:
- **Basic Info**: Title, floor number
- **Access Control**: FOB requirements (Yes/No badge)
- **Guest Policy**: Accepts guests (Yes/No badge)
- **Property**: Which residence it belongs to

#### Deleting Rooms
1. Locate the room in the rooms list
2. Click the **"Delete"** button for that room
3. Confirm deletion when prompted
4. ⚠️ **Note**: This will also delete visit history for that room

## CSV Room Upload

### Overview
The CSV upload feature allows you to create multiple rooms at once, saving time when setting up new properties or adding rooms in bulk.

### CSV Format Requirements

#### Required Headers
Your CSV file must have exactly these headers in this order:
```csv
title,floor,needs_fob,memo,accepts_guests
```

#### Example CSV Content
```csv
title,floor,needs_fob,memo,accepts_guests
Room 101,1,true,Corner office with window,true
Room 102,1,false,Standard office,true
Room 103,1,true,Manager office,false
Conference Room A,1,true,Main meeting room seats 12,true
Break Room,1,false,Kitchen and dining area,false
Room 201,2,true,Executive office,true
Room 202,2,false,Open workspace,true
Storage Room,2,false,Supply storage only,false
```

### Field Descriptions

#### Title Field
- **Purpose**: Unique identifier for the room
- **Examples**: "Room 101", "Conference Room A", "CEO Office"
- **Best Practices**:
  - Use consistent naming conventions
  - Include room numbers when applicable
  - Be descriptive but concise

#### Floor Field
- **Purpose**: Numeric floor number
- **Format**: Integer (1, 2, 3, etc.)
- **Examples**: 1, 2, 10, -1 (for basement)
- **Notes**: Use consistent floor numbering throughout the building

#### Needs FOB Field
- **Purpose**: Whether room requires key card/fob access
- **Accepted Values**:
  - `true`, `yes`, `1`, `y` (requires FOB)
  - `false`, `no`, `0`, `n` (no FOB required)
- **Case Insensitive**: System accepts any capitalization

#### Memo Field
- **Purpose**: Additional room description or notes
- **Examples**: 
  - "Corner office with window view"
  - "Conference room seats 12 people"
  - "Kitchen area with refrigerator"
- **Optional**: Can be left empty if no description needed

#### Accepts Guests Field
- **Purpose**: Whether room allows visitors/guests
- **Accepted Values**: Same as needs_fob field
- **Use Cases**:
  - `true`: Meeting rooms, offices that host visitors
  - `false`: Private offices, storage areas, restricted spaces

### CSV Upload Process

#### Step 1: Prepare Your CSV Data
1. **Create File**: Use Excel, Google Sheets, or text editor
2. **Follow Format**: Ensure headers match exactly
3. **Validate Data**: Check for typos and consistency
4. **Save/Copy**: Save as CSV or copy the content

#### Step 2: Access Room Upload
1. **Edit Property**: Go to Residences and edit the property where you want to add rooms
2. **Find CSV Section**: Scroll to "Bulk Room Import" section
3. **Paste Content**: Paste your CSV data into the text area

#### Step 3: Preview and Validate
1. **Auto-Preview**: System automatically parses your CSV
2. **Check Preview**: Review the first 5 rooms in the preview table
3. **Verify Count**: Confirm total number of rooms to be imported
4. **Fix Errors**: If validation fails, correct the CSV format

#### Step 4: Submit and Create
1. **Save Property**: Click "Save Residence" to create the property and import rooms
2. **Confirmation**: System will show success message with count of imported rooms
3. **Error Handling**: Any errors will be displayed with specific details

### CSV Upload Tips

#### Best Practices
- ✅ **Test Small**: Start with a few rooms to test the format
- ✅ **Consistent Naming**: Use standardized room naming conventions
- ✅ **Backup Data**: Keep a copy of your CSV data
- ✅ **Review Preview**: Always check the preview before submitting

#### Common Mistakes to Avoid
- ❌ **Wrong Headers**: Headers must match exactly (case-sensitive)
- ❌ **Missing Commas**: Ensure proper CSV comma separation
- ❌ **Invalid Floors**: Floor must be a valid number
- ❌ **Empty Required Fields**: Title and floor are required

#### Handling Large Imports
- **Batch Processing**: For 100+ rooms, consider splitting into smaller batches
- **Performance**: Large imports may take a few seconds to process
- **Error Recovery**: If errors occur, fix and re-import only the failed rows

### CSV Templates

#### Basic Office Building
```csv
title,floor,needs_fob,memo,accepts_guests
Office 101,1,true,Standard office,true
Office 102,1,true,Standard office,true
Conference Room A,1,true,Seats 8 people,true
Break Room,1,false,Kitchen area,false
Office 201,2,true,Manager office,true
Office 202,2,true,Senior staff office,true
Conference Room B,2,true,Large meeting room seats 16,true
```

#### Residential Building
```csv
title,floor,needs_fob,memo,accepts_guests
Apt 101,1,true,One bedroom apartment,true
Apt 102,1,true,Two bedroom apartment,true
Apt 103,1,true,Studio apartment,false
Laundry Room,1,false,Washer and dryer,false
Apt 201,2,true,One bedroom apartment,true
Apt 202,2,true,Two bedroom apartment,true
Community Room,2,false,Shared space for residents,true
```

#### Hotel/Hospitality
```csv
title,floor,needs_fob,memo,accepts_guests
Room 101,1,true,Standard king room,true
Room 102,1,true,Double queen room,true
Room 103,1,true,Accessible room,true
Ice Machine,1,false,Ice and vending,false
Room 201,2,true,Executive suite,true
Room 202,2,true,Junior suite,true
Conference Center,2,true,Business meeting space,true
```

## User Management

### User Types and Permissions

#### Regular Users
- **Access**: Can check in/out, view their own history
- **Restrictions**: Cannot access admin functions
- **Property Assignment**: Can be assigned to specific properties

#### Admin Users
- **Full Access**: All admin panel functions
- **User Management**: Can promote/demote other users
- **System Management**: Property, room, and data management

### Managing User Permissions

#### Promoting Users to Admin
1. Go to **Admin** → **Users**
2. Find the user in the list
3. Click **"Make Admin"** button
4. Confirm the change

#### Removing Admin Privileges
1. Locate the admin user
2. Click **"Remove Admin"** button
3. Confirm the change

#### Assigning Users to Properties
1. Edit user account
2. Select appropriate property from dropdown
3. Save changes
4. User will only see data for their assigned property

## Data Export and Reports

### Exporting Visit History

#### CSV Export Features
- **Date Range Filtering**: Export specific time periods
- **Property-Based Access**: Regular users see only their property data
- **Admin Access**: Admins can export all data across properties

#### Export Process
1. Go to **History** page
2. Set desired date range
3. Click **"Export CSV"** button
4. File will download with visit data

#### Export Data Includes
- Visitor name and contact information
- Visit dates and times
- Room and property information
- Purpose of visit and notes
- Check-in/check-out status

### Data Analysis

#### Using Exported Data
- **Occupancy Reports**: Track room usage patterns
- **Visitor Analytics**: Understand visitor frequency and types
- **Security Audits**: Review access logs for compliance
- **Billing/Invoicing**: Track usage for billing purposes

## System Maintenance

### Regular Maintenance Tasks

#### Weekly Tasks
- **Review User Accounts**: Check for inactive or duplicate accounts
- **Data Cleanup**: Archive old visit records if needed
- **System Performance**: Monitor response times and usage

#### Monthly Tasks
- **User Permissions Audit**: Review admin assignments
- **Property Data Review**: Ensure property information is current
- **Backup Verification**: Confirm data backups are working

#### Quarterly Tasks
- **System Updates**: Apply software updates as available
- **Security Review**: Check access logs for unusual activity
- **User Training**: Refresh training for new users

### Performance Optimization

#### Database Maintenance
- **Regular Cleanup**: Archive old records periodically
- **Index Optimization**: Ensure database queries remain fast
- **Storage Management**: Monitor disk space usage

#### User Experience
- **Response Time Monitoring**: Track page load speeds
- **Error Rate Tracking**: Monitor for system errors
- **User Feedback**: Collect and address user concerns

## Troubleshooting

### Common Admin Issues

#### CSV Upload Problems

**Problem**: "Invalid CSV headers" error
- **Cause**: Headers don't match required format exactly
- **Solution**: Ensure headers are: `title,floor,needs_fob,memo,accepts_guests`
- **Check**: Verify no extra spaces or different capitalization

**Problem**: "Invalid data on line X" error
- **Cause**: Data format issues on specific row
- **Solution**: Check that row for:
  - Missing commas
  - Invalid floor number (must be integer)
  - Extra/missing columns

**Problem**: Rooms not appearing after CSV import
- **Cause**: CSV validation failed silently
- **Solution**: Check browser console for error messages
- **Alternative**: Try importing smaller batches

#### Property Management Issues

**Problem**: Cannot delete property
- **Cause**: Property may have associated rooms or visit history
- **Solution**: Delete associated rooms first, or check for active visits

**Problem**: Property not showing in room assignment
- **Cause**: Property may not be properly saved
- **Solution**: Edit and re-save the property

#### User Access Issues

**Problem**: Admin user cannot access admin panel
- **Cause**: Admin privileges may not be properly set
- **Solution**: Check user admin status in database

**Problem**: User cannot see their property's data
- **Cause**: User may not be assigned to correct property
- **Solution**: Edit user and assign proper property

### Getting Technical Support

#### Before Contacting Support
1. **Check Error Messages**: Note exact error text
2. **Browser Console**: Check for JavaScript errors (F12)
3. **Reproduce Issue**: Try to replicate the problem
4. **Document Steps**: Write down what you were doing when error occurred

#### Information to Provide
- **User Account**: Your admin username
- **Browser Information**: Browser type and version
- **Error Messages**: Exact error text or screenshots
- **Steps to Reproduce**: Detailed steps that caused the issue
- **Expected vs Actual**: What you expected vs what happened

### Emergency Procedures

#### System Downtime
1. **Check Network**: Verify internet connectivity
2. **Contact IT**: Report system availability issues
3. **Manual Tracking**: Use backup tracking methods if needed
4. **Communication**: Inform users of expected resolution time

#### Data Recovery
1. **Stop Activity**: Prevent further data changes
2. **Contact Administrator**: Report data loss immediately
3. **Backup Restoration**: Restore from most recent backup
4. **Verification**: Confirm data integrity after restoration

---

## Quick Reference Guides

### Property Creation Checklist
- [ ] Navigate to Admin → Residences
- [ ] Click "New Residence"
- [ ] Enter title (building name)
- [ ] Enter complete address
- [ ] Specify floor count
- [ ] Prepare CSV data (optional)
- [ ] Paste CSV in bulk import section
- [ ] Review CSV preview
- [ ] Save residence
- [ ] Verify rooms were created correctly

### CSV Format Quick Reference
```csv
title,floor,needs_fob,memo,accepts_guests
Room 101,1,true,Corner office,true
Room 102,1,false,Standard office,true
Conference Room,1,true,Meeting room,true
```

### User Management Quick Actions
- **Make Admin**: Users → Find user → "Make Admin" button
- **Remove Admin**: Users → Find admin → "Remove Admin" button
- **Assign Property**: Users → Edit user → Select property → Save

### Data Export Quick Steps
- **Export History**: History → Set date range → "Export CSV"
- **Admin Export**: Full access to all property data
- **User Export**: Limited to assigned property data

---

## Best Practices Summary

### Property Management
- ✅ Use clear, descriptive property names
- ✅ Keep address information complete and accurate
- ✅ Use consistent floor numbering schemes
- ✅ Test CSV imports with small batches first

### Room Management
- ✅ Establish room naming conventions
- ✅ Regularly audit room information for accuracy
- ✅ Use CSV imports for bulk operations
- ✅ Document special room requirements in memo fields

### User Management
- ✅ Regularly review admin permissions
- ✅ Assign users to appropriate properties
- ✅ Train new admins on system procedures
- ✅ Maintain documentation of user roles

### System Administration
- ✅ Perform regular data backups
- ✅ Monitor system performance
- ✅ Keep software updated
- ✅ Document configuration changes

---

*Last Updated: [Current Date]*
*Version: 1.0*
*For Technical Support: Contact your system administrator*