<p align="center">
  <img src="public/favicon-new.svg" alt="LaunchPad Logo" width="80" height="80">
</p>

<h1 align="center">LaunchPad</h1>

<p align="center">
  <strong>🚀 Discover Hackathons, Internships & Coding Contests</strong>
</p>

<p align="center">
  <a href="https://launch-pad-navy.vercel.app">Live Demo</a> •
  <a href="#features">Features</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#tech-stack">Tech Stack</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/React-18.3-61DAFB?logo=react" alt="React">
  <img src="https://img.shields.io/badge/TypeScript-5.6-3178C6?logo=typescript" alt="TypeScript">
  <img src="https://img.shields.io/badge/Vite-5.4-646CFF?logo=vite" alt="Vite">
  <img src="https://img.shields.io/badge/TailwindCSS-3.4-06B6D4?logo=tailwindcss" alt="TailwindCSS">
  <img src="https://img.shields.io/badge/Supabase-Backend-3FCF8E?logo=supabase" alt="Supabase">
</p>

---

## ✨ What is LaunchPad?

**LaunchPad** is a one-stop platform that aggregates **hackathons**, **coding contests**, and **internships** from multiple live sources worldwide. Built for students and developers who want to discover opportunities without checking multiple websites.

### 🎯 Key Highlights

- **140-155 Opportunities** - Mix of live and curated opportunities
- **65-75% Live Data** - Real-time updates from 6 different APIs
- **5+ Live Sources** - Codeforces, Kontests, GitHub, HackerEarth, Edge Function, Database
- **Smart Filtering** - Filter by type, deadline, location, and search
- **Compare Tool** - Side-by-side comparison of up to 3 opportunities
- **Favorites** - Save opportunities to your personal list
- **Instant Load** - Curated fallback ensures no blank pages

---

## 🚀 Features

### For Students & Developers

| Feature | Description |
|---------|-------------|
| 🔍 **Smart Search** | Search by title, company, or tags |
| 🏷️ **Filter by Type** | Hackathons, Internships, or Contests |
| 📅 **Deadline Sorting** | Never miss a deadline |
| ⚡ **Compare Tool** | Compare up to 3 opportunities side-by-side |
| ❤️ **Favorites** | Save opportunities to your profile |
| 💡 **Get Ideas** | AI-powered project ideas & prep guides |
| 📱 **Mobile Ready** | Responsive design for all devices |
| 🌙 **Dark Mode** | Easy on the eyes |

### For Admins

- **Admin Panel** - Add/edit/delete opportunities
- **User Management** - Manage admin roles
- **Database Control** - Full CRUD operations

---

## 🖼️ Screenshots

<details>
<summary>Click to view screenshots</summary>

### Home Page
The main dashboard showing all opportunities with filters and search.

### Opportunity Card
Each card shows title, deadline, prize, location, and quick actions.

### Compare Modal
Side-by-side comparison of selected opportunities.

### Admin Panel
Manage opportunities with full CRUD functionality.

</details>

---

## ⚡ Quick Start

### Prerequisites

- Node.js 18+ 
- npm or bun

### Installation

```bash
# Clone the repository
git clone https://github.com/yadavnikhil17102004/LaunchPad.git
cd LaunchPad

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will be running at `http://localhost:8080`

### Environment Variables

Create a `.env` file in the root:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_PUBLISHABLE_KEY=your_supabase_anon_key
```

---

## 🛠️ Tech Stack

### Frontend
- **React 18** - UI framework with hooks
- **TypeScript** - Type-safe development
- **Vite** - Lightning-fast build tool
- **TailwindCSS** - Utility-first styling
- **Radix UI** - Accessible component primitives
- **shadcn/ui** - Beautiful component library
- **React Router** - Client-side routing
- **TanStack Query** - Server state management

### Backend
- **Supabase** - PostgreSQL + Auth + Edge Functions
- **Supabase Edge Functions** - Serverless data aggregation

### Data Sources

LaunchPad uses a **3-layer data strategy** to ensure users always see fresh opportunities:

#### 🌐 Layer 1: Live APIs (65-75% of data)
| Source | Type | Status | Count |
|--------|------|--------|-------|
| Codeforces API | Contests | ✅ Live | 10-15 |
| Kontests API (Edge Function) | Multi-platform | ✅ Deployed | 15-20 |
| GitHub Issues API | Community Hackathons | ✅ Live | 5-10 |
| HackerEarth API | Challenges | ✅ Live | 5-10 |
| Supabase Database | Admin-added | ✅ Live | Varies |
| **Total Live** | **Mixed** | | **71-86** |

#### 📚 Layer 2: Curated Fallback (25-35% of data)
| Category | Count |
|----------|-------|
| Major Hackathons | 7 (SIH, GSoC, MLH, ETHGlobal, etc.) |
| Internships | 4 (GSoC, MLH Fellowship, Outreachy, LFX) |
| Indian Events | 40+ (IIT/NIT fests, TCS CodeVita, Flipkart GRiD) |
| Weekly Contests | 10+ (LeetCode, AtCoder, HackerRank) |

**Total Available**: ~140-155 opportunities at any time

#### How It Works
```mermaid
graph LR
    A[User Opens App] --> B{Data Loading}
    B -->|0ms| C[Show Curated Data Instantly]
    B -->|500ms| D[Fetch Live APIs]
    D --> E[Codeforces Contests]
    D --> F[Database Opportunities]
    C --> G[Merge All Sources]
    E --> G
    F --> G
    G --> H[Filter Future Events]
    H --> I[Remove Duplicates]
    I --> J[Sort by Deadline]
    J --> K[Display to User]
```

**Why This Works:**
- ✅ **Instant Display**: Curated data shows immediately (no blank page)
- ✅ **Always Fresh**: Live APIs provide real-time contest updates
- ✅ **Never Fails**: Curated fallback ensures content even if APIs are down
- ✅ **Comprehensive**: Mix of global events, Indian hackathons, and live contests

---

## 📁 Project Structure

```
LaunchPad/
├── src/
│   ├── components/       # React components
│   │   ├── ui/          # shadcn/ui components
│   │   ├── Header.tsx
│   │   ├── OpportunityCard.tsx
│   │   ├── OpportunityGrid.tsx
│   │   └── ...
│   ├── hooks/           # Custom React hooks
│   │   ├── useOpportunities.tsx
│   │   ├── useAuth.tsx
│   │   ├── useFavorites.tsx
│   │   └── useCompare.tsx
│   ├── pages/           # Route pages
│   │   ├── Index.tsx
│   │   ├── Auth.tsx
│   │   ├── Admin.tsx
│   │   └── Favorites.tsx
│   ├── integrations/    # Supabase client
│   └── types/           # TypeScript types
├── supabase/
│   └── functions/       # Edge Functions
├── public/              # Static assets
└── package.json
```

---

## 🏗️ Architecture

### System Overview

```mermaid
graph TB
    subgraph "User's Browser"
        A[React App]
        B[React Router]
        C[TanStack Query]
    end
    
    subgraph "Vercel CDN"
        D[Static Assets]
        E[index.html]
    end
    
    subgraph "Supabase Backend"
        F[(PostgreSQL Database)]
        G[Authentication Service]
        H[Edge Functions]
        I[Row Level Security]
    end
    
    subgraph "External APIs"
        J[Kontests API]
        K[Firecrawl API]
    end
    
    A --> D
    A --> E
    B --> A
    C --> A
    A --> G
    A --> F
    A --> H
    H --> J
    H --> K
    F --> I
    G --> I
```

### Deployment Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as GitHub
    participant Vercel as Vercel
    participant User as End User
    
    Dev->>Dev: Make code changes
    Dev->>Git: git push origin main
    Git->>Vercel: Webhook trigger
    Vercel->>Vercel: npm install
    Vercel->>Vercel: vite build
    Vercel->>Vercel: Deploy to CDN
    Vercel->>Dev: Deployment URL
    User->>Vercel: Visit app
    Vercel->>User: Serve React app
```

### Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant App as React App
    participant Auth as Supabase Auth
    participant DB as Supabase DB
    
    User->>App: Click "Sign Up"
    App->>Auth: supabase.auth.signUp()
    Auth->>Auth: Create user account
    Auth->>User: Send confirmation email
    User->>Auth: Click email link
    Auth->>DB: Insert into profiles table
    Auth->>App: Return session
    App->>User: Redirect to homepage
```

### Data Flow

```mermaid
graph LR
    A[User Action] --> B{What action?}
    B -->|View Opportunities| C[Fetch from DB]
    B -->|Add Favorite| D[Insert to favorites]
    B -->|Compare| E[Local state only]
    B -->|Admin Add| F[Insert to opportunities]
    
    C --> G[(Supabase)]
    D --> G
    F --> G
    
    G --> H[RLS Check]
    H --> I{Authorized?}
    I -->|Yes| J[Return data]
    I -->|No| K[Error 403]
```

---

## 🔧 Available Scripts

```bash
# Development
npm run dev          # Start dev server

# Production
npm run build        # Build for production
npm run preview      # Preview production build

# Code Quality
npm run lint         # Run ESLint
```

---

## 🌐 Deployment

### Vercel (Recommended)

1. Push to GitHub
2. Import project in Vercel
3. Add environment variables
4. Deploy!

### Netlify

```bash
npm run build
# Deploy dist/ folder
```

---

## 🤝 Contributing

Contributions are welcome! 

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👤 Author

**Nikhil Yadav**

- GitHub: [@yadavnikhil17102004](https://github.com/yadavnikhil17102004)
- Email: yadavnikhil17102004@gmail.com

---

<p align="center">
  Made with ❤️ for the developer community
</p>

<p align="center">
  ⭐ Star this repo if you find it helpful!
</p>
