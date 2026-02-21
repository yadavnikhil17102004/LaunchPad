# 🚀 LaunchPad

> _A hyper-optimized aggregation engine for discovering Hackathons, Internships, and Coding Contests._

## ⚡ What is this?

LaunchPad is a centralized intelligence dashboard designed to scrape, aggregate, and display high-value tech opportunities from over 50+ global sources. Built for developers who want to minimize tracking overhead and maximize execution.

## 🎯 Core Capabilities

- **Real-Time Aggregation**: Live datastreams from Codeforces, Devfolio, MLH, Unstop, and proprietary scraped lists.
- **Smart Filtering Engine**: Rapid sorting by opportunity type, deadline urgency, and location metrics.
- **Side-by-Side Comparison**: Evaluate up to 3 different events or internships simultaneously.
- **AI-Driven Edge**: Integrated AI project ideation and interview preparation workflows.
- **Favorites Architecture**: State-preserved tracking of shortlisted opportunities.

## 🛠 Tech Stack (Frontend + Edge)

- **Core**: React 18, TypeScript, Vite
- **Styling**: TailwindCSS, Radix UI, shadcn/ui
- **State & Routing**: React Router, TanStack Query
- **Backend Infrastructure**: Supabase (PostgreSQL + Auth + Serverless Edge Functions)

## 📦 Rapid Deployment

**1. Clone the environment**

```bash
git clone https://github.com/yadavnikhil17102004/LaunchPad.git
cd LaunchPad
```

**2. Initialize dependencies**

```bash
npm install
```

**3. Configure Supabase Environment**
Create a `.env` file in the root directory:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_PUBLISHABLE_KEY=your_supabase_anon_key
```

**4. Spin up the dev server**

```bash
npm run dev
```

_The dashboard will be active at `http://localhost:8080`._

## 🏗 Architecture Layout

```text
LaunchPad/
├── src/
│   ├── components/       # Core UI & shadcn primitives
│   ├── hooks/            # Custom logic (useAuth, useFavorites)
│   ├── pages/            # Application routes (Index, Admin)
│   ├── integrations/     # Supabase client singletons
│   └── types/            # Strict TypeScript definitions
├── supabase/
│   └── functions/        # Serverless data aggregation logic
└── public/               # Static assets
```

## 🔒 Administration

LaunchPad includes a full built-in RBAC (Role-Based Access Control) Admin panel out of the box, allowing operators to execute complete CRUD operations on the opportunity database dynamically.
