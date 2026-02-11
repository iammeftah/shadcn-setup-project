# shadcn-setup.sh

A shell script to bootstrap a new React + TypeScript + Vite project with Tailwind CSS v4 and shadcn/ui — fully automated with minimal user interaction.

## What it does

- Creates a new Vite project with the `react-ts` template
- Installs and configures Tailwind CSS v4
- Sets up path aliases (`@/`) in `tsconfig.json`, `tsconfig.app.json`, and `vite.config.ts`
- Initializes shadcn/ui and installs the most commonly used components
- Scaffolds a clean project structure with pages, layouts, contexts, hooks, and services
- Sets up React Router with a home and about page
- Creates a `ThemeContext` with light/dark mode support persisted in `localStorage`
- Adds a `Header` component with navigation and a theme toggle button
- Wraps the app with `ThemeProvider` and `TooltipProvider`

## Requirements

- [nvm](https://github.com/nvm-sh/nvm) with Node.js 20+ installed
- npm

If you don't have Node 20, install it via nvm:

```bash
nvm install 20
nvm alias default 20
```

## Usage

```bash
# Make the script executable
chmod +x shadcn-setup.sh

# Run it
./shadcn-setup.sh
```

You will be prompted once to enter your project name. The rest is fully automated.

## Project structure generated

```
src/
├── components/
│   ├── common/
│   ├── layouts/
│   │   └── Header.tsx
│   └── ui/              # shadcn components
├── contexts/
│   └── ThemeContext.tsx
├── hooks/
├── pages/
│   ├── home/
│   │   └── HomePage.tsx
│   └── about/
│       └── AboutPage.tsx
├── services/
├── App.tsx
├── main.tsx
└── routes.tsx
```

## shadcn components installed

`button` `card` `input` `accordion` `sonner` `dropdown-menu` `dialog` `select` `checkbox` `label` `textarea` `badge` `avatar` `tabs` `table` `alert` `popover` `tooltip` `separator` `switch` `radio-group` `slider` `sheet` `form`

## After setup

```bash
cd <your-project-name>
nvm use 20
npm run dev
```
