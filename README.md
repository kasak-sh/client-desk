# ClientDesk

A fully multi-tenant SaaS application built with Ruby on Rails 7, featuring account-based isolation, branded login pages, and complete separation between system administration and tenant operations.

## Key Features

- **True Multi-Tenancy** - Complete data isolation per account with slug-based routing
- **Branded Login Pages** - Each account has its own login URL with custom logo
- **Separated Admin System** - Admin interface completely separate from account operations
- **Role-based Access Control** - System admins vs account users
- **Account Slug URLs** - Each tenant gets branded URLs (e.g., `/acme-corp/login`)
- **Logo Upload** - Accounts can upload custom logos for their login pages
- **Client & Booking Management** - Full CRUD operations scoped by account
- **Dashboard Analytics** - Per-account statistics and insights
- **Bootstrap 5 UI** - Professional soft indigo theme with Inter font
- **PostgreSQL Database** with ActiveStorage
- **Zero Public Signup** - All users provisioned by system admins

## Requirements

- Ruby 3.4.7
- Rails 7.2.3
- PostgreSQL 14.20

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Create and setup the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Creates demo accounts, admin, and users
   ```

3. Start the server:
   ```bash
   rails server
   ```

4. Visit http://localhost:3000

## Demo Accounts

After running `rails db:seed`, you can log in with:

### System Administrator
- **URL:** `http://localhost:3000/admin/login`
- **Email:** `admin@clientdesk.com`
- **Password:** `admin123`
- **Access:** Complete system management - create accounts, manage users, no access to client/booking data

### Account Users

#### Acme Corporation
- **Login URL:** `http://localhost:3000/acme-corporation/login`
- **Email:** `john@acme.com`
- **Password:** `password123`
- **Access:** Manage clients and bookings for Acme Corporation only

#### Tech Startup Inc
- **Login URL:** `http://localhost:3000/tech-startup-inc/login`
- **Email:** `mike@techstartup.com`
- **Password:** `password123`
- **Access:** Manage clients and bookings for Tech Startup Inc only

## Architecture Overview

### Multi-Tenancy with URL Scoping
- Each **Account** (business/organization) is completely isolated
- Every account has a unique **slug** used in URLs
- Account-specific routes: `/:account_slug/login`, `/:account_slug/dashboard`, etc.
- Data automatically scoped by account - users can only access their account's data
- Accounts can be activated/deactivated by system admins

### Separated Route Structure
```
Admin Routes (System Management)
├── /admin/login
├── /admin/accounts
└── /admin/users

Account Routes (Tenant Operations)
├── /:account_slug/login
├── /:account_slug/dashboard
├── /:account_slug/clients
└── /:account_slug/bookings
```

### User Roles & Access Control
- **System Admin**:
  - No account association (account_id is null)
  - Can only access `/admin/*` routes
  - Manages accounts and users system-wide
  - Cannot access client/booking data

- **Account User**:
  - Belongs to one account
  - Can only access `/:account_slug/*` routes for their account
  - Manages clients and bookings within their account
  - Cannot access admin interface or other accounts

### Branded Login Experience
- Each account has a custom login URL: `/acme-corporation/login`
- Accounts can upload custom logos displayed on their login page
- Login validates user belongs to that specific account
- Provides white-label experience for each tenant

### Authentication & Security
- No public signup - all users provisioned by admins
- Session-based authentication with `has_secure_password`
- Password validation (minimum 6 characters)
- Account access verification on every request
- Inactive accounts blocked from login
- CSRF protection enabled

## How It Works

### The Account Workflow

1. **System Admin Creates Account**
   - Admin logs in at `/admin/login`
   - Creates new account: "Acme Corporation"
   - System generates slug: `acme-corporation`
   - Optionally uploads company logo
   - Account gets login URL: `/acme-corporation/login`

2. **System Admin Creates Users**
   - Admin creates users and assigns them to "Acme Corporation"
   - Users receive login credentials
   - Users can only log in at their account's URL

3. **Users Access Their Account**
   - Users visit `/acme-corporation/login`
   - See Acme Corporation branding and logo
   - Log in with credentials
   - Can only access Acme Corporation's data
   - All URLs scoped: `/acme-corporation/dashboard`, etc.

4. **Complete Isolation**
   - Users from "Tech Startup Inc" cannot access Acme Corporation data
   - Even if they know the URL, authentication verifies account membership
   - Each account operates as a completely separate system

## Features Overview

### System Admin Interface (`/admin/*`)
**Available to system administrators only** - completely separate from account operations

#### Account Management (`/admin/accounts`)
- Create new business accounts with custom slugs
- Upload account logos for branded login pages
- Edit account details (name, slug, logo, status)
- Activate/deactivate accounts (prevents all user access)
- View account statistics (users, clients, bookings)
- Delete accounts (cascades to all associated data)
- Each account gets: `/:slug/login` URL

#### User Management (`/admin/users`)
- Create users and assign them to specific accounts
- Assign roles (system admin or account user)
- Reset user passwords (generates secure temporary password)
- Edit user details and reassign accounts
- Delete users
- System admins have no account association

### Client Management
- Create, read, update, and delete clients
- Fields: name, email, phone, company, notes
- Scoped to current user's account
- All users in an account can see all clients

### Booking Management
- Create, read, update, and delete bookings
- Associate bookings with clients
- Fields: title, description, scheduled date/time, duration, status
- Status options: pending, confirmed, completed, cancelled
- Scoped to current user's account

### Dashboard
- Overview of total clients and bookings for the account
- List of upcoming bookings (next 7 days)
- List of recently added clients
- Quick navigation to clients and bookings

## Database Schema

### Accounts
- **name** (string, required) - Business/organization name
- **slug** (string, unique, required) - URL-safe identifier (e.g., "acme-corporation")
- **status** (enum: active, inactive) - Controls account access
- **logo** (ActiveStorage attachment) - Custom logo for login page
- **Associations:**
  - has_many :users
  - has_many :clients
  - has_many :bookings
  - has_one_attached :logo

### Users
- **email** (string, unique, required)
- **password_digest** (string, required) - bcrypt hash
- **name** (string, required)
- **role** (enum: user, admin) - System admin or account user
- **account_id** (integer, nullable) - null for admins, required for users
- **Associations:**
  - belongs_to :account (optional: true for admins)
  - has_many :clients
  - has_many :bookings
- **Validation:** Regular users must have an account, admins must not

### Clients
- **name** (string, required)
- **email** (string, optional)
- **phone** (string, optional)
- **company** (string, optional)
- **notes** (text, optional)
- **account_id** (integer, required)
- **user_id** (integer, required) - Creator
- **Associations:**
  - belongs_to :account
  - belongs_to :user (creator)
  - has_many :bookings

### Bookings
- **title** (string, required)
- **description** (text, optional)
- **scheduled_at** (datetime, required)
- **duration_minutes** (integer, optional)
- **status** (enum: pending, confirmed, completed, cancelled)
- **account_id** (integer, required)
- **client_id** (integer, required)
- **user_id** (integer, required) - Creator
- **Associations:**
  - belongs_to :account
  - belongs_to :client
  - belongs_to :user (creator)

## Routes

### Public Routes
- `GET /` - Welcome/landing page

### System Admin Routes (`/admin/*`)
**Requires system admin authentication**
- `GET /admin/login` - Admin login page
- `POST /admin/login` - Admin authentication
- `DELETE /admin/logout` - Admin logout
- `GET /admin/accounts` - List all accounts
- `POST /admin/accounts` - Create new account
- `GET /admin/accounts/:id` - View account details
- `PATCH /admin/accounts/:id` - Update account (name, slug, logo, status)
- `DELETE /admin/accounts/:id` - Delete account
- `GET /admin/users` - List all users (across all accounts)
- `POST /admin/users` - Create new user
- `PATCH /admin/users/:id/reset_password` - Reset user password

### Account Routes (`/:account_slug/*`)
**Requires account user authentication** - automatically scoped to account

#### Authentication
- `GET /:account_slug/login` - Account-branded login page
- `POST /:account_slug/login` - Account user authentication
- `DELETE /:account_slug/logout` - User logout

#### Dashboard & Resources
- `GET /:account_slug/dashboard` - Account dashboard
- `GET /:account_slug/clients` - List clients
- `POST /:account_slug/clients` - Create client
- `GET /:account_slug/clients/:id` - View client
- `PATCH /:account_slug/clients/:id` - Update client
- `DELETE /:account_slug/clients/:id` - Delete client
- `GET /:account_slug/bookings` - List bookings
- `POST /:account_slug/bookings` - Create booking
- `GET /:account_slug/bookings/:id` - View booking
- `PATCH /:account_slug/bookings/:id` - Update booking
- `DELETE /:account_slug/bookings/:id` - Delete booking

### Route Examples
```
Admin logs in:           /admin/login
Admin manages accounts:  /admin/accounts

Acme Corp login:         /acme-corporation/login
Acme Corp dashboard:     /acme-corporation/dashboard
Acme Corp clients:       /acme-corporation/clients

Tech Startup login:      /tech-startup-inc/login
Tech Startup dashboard:  /tech-startup-inc/dashboard
```

## Technologies

- **Rails 7.2.3** - Full-stack web framework
- **PostgreSQL 14.20** - Primary database
- **ActiveStorage** - File uploads (account logos)
- **bcrypt** - Secure password hashing
- **Bootstrap 5** (via CDN) - Soft indigo theme with custom styling and Inter font
- **Turbo & Stimulus** (Hotwire) - Modern JavaScript framework
- **ActiveRecord** - Multi-tenant data scoping

## Security Features

- **Complete Data Isolation** - Per-account data scoping at every query
- **URL-based Tenant Isolation** - Account slug verified on every request
- **Role-based Authorization** - Separate admin and user access controls
- **Account Access Verification** - Users can only access their assigned account
- **Active Account Validation** - Inactive accounts cannot log in
- **Separated Admin Routes** - Admin interface isolated from account operations
- **Password Security** - bcrypt hashing with minimum complexity requirements
- **CSRF Protection** - Built-in Rails security tokens
- **Session-based Auth** - Secure server-side session management

## License

This project is available for use under the MIT License.
