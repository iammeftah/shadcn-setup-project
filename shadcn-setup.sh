#!/bin/bash

# Shadcn Setup Script
# This script sets up a new shadcn project

# Load nvm and switch to Node 20
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 20 || { echo "Node 20 not found. Run: nvm install 20"; exit 1; }

# Get the project name from user first
read -p "Enter your project name: " project_name

echo "Creating new Vite project..."
npm create vite@latest "$project_name" -- --template react-ts --no-install

echo "Navigating to project directory..."
cd "$project_name" || exit 1

echo "Installing dependencies..."
npm install

echo "Installing Tailwind CSS..."
npm install tailwindcss @tailwindcss/vite

echo "Configuring Tailwind CSS in src/index.css..."
echo '@import "tailwindcss";' > src/index.css

echo "Configuring tsconfig.json with path aliases..."
cat > tsconfig.json << 'EOF'
{
  "files": [],
  "references": [
    {
      "path": "./tsconfig.app.json"
    },
    {
      "path": "./tsconfig.node.json"
    }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
EOF

echo "Updating tsconfig.app.json with path aliases..."
cat > tsconfig.app.json << 'EOF'
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "ES2022",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "types": ["vite/client"],
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "erasableSyntaxOnly": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true,

    "baseUrl": ".",
    "paths": {
      "@/*": [
        "./src/*"
      ]
    }
  },
  "include": ["src"]
}
EOF

echo "Installing @types/node..."
npm install -D @types/node

echo "Configuring vite.config.ts..."
rm -f vite.config.js
cat > vite.config.ts << 'EOF'
import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
EOF

echo "Initializing shadcn..."
npx -y shadcn@latest init

echo "Adding shadcn components..."
npx -y shadcn@latest add button card input accordion sonner dropdown-menu dialog select checkbox label textarea badge avatar tabs table alert popover tooltip separator switch radio-group slider sheet form

echo "Setting up project structure..."
mkdir -p src/components/common
mkdir -p src/components/layouts
mkdir -p src/pages/home
mkdir -p src/pages/about
mkdir -p src/services
mkdir -p src/contexts
mkdir -p src/hooks

echo "Creating routes.tsx..."
cat > src/routes.tsx << 'EOF'
import { createBrowserRouter } from "react-router-dom";
import HomePage from "./pages/home/HomePage";
import AboutPage from "./pages/about/AboutPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <HomePage />,
  },
  {
    path: "/about",
    element: <AboutPage />,
  },
]);
EOF

echo "Creating Header component..."
cat > src/components/layouts/Header.tsx << 'EOF'
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useTheme } from "@/contexts/ThemeContext";
import { Moon, Sun } from "lucide-react";

export default function Header() {
  const { theme, toggleTheme } = useTheme();

  return (
    <header className="border-b">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between">
        <Link to="/" className="text-2xl font-bold">
          Shadcn
        </Link>
        <nav className="flex gap-4 items-center">
          <Link to="/">
            <Button variant="ghost">Home</Button>
          </Link>
          <Link to="/about">
            <Button variant="ghost">About</Button>
          </Link>
          <Button variant="ghost" size="icon" onClick={toggleTheme}>
            {theme === "dark" ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
          </Button>
        </nav>
      </div>
    </header>
  );
}
EOF

echo "Creating HomePage component..."
cat > src/pages/home/HomePage.tsx << 'EOF'
import Header from "@/components/layouts/Header";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function HomePage() {
  return (
    <div className="min-h-screen flex flex-col bg-background">
      <Header />
      <main className="container mx-auto px-4 py-8 grow flex items-center justify-center">
        <div className="max-w-4xl mx-auto space-y-8 flex flex-col items-center justify-center">
          <div className="text-center space-y-4">
            <h1 className="text-4xl font-bold">Welcome to My App</h1>
            <p className="text-xl text-muted-foreground">
              Built with Vite, React, TypeScript, and shadcn/ui
            </p>
            <Button size="lg">Get Started</Button>
          </div>

          <div className="grid md:grid-cols-3 gap-6 mt-12">
            <Card>
              <CardHeader>
                <CardTitle>Fast</CardTitle>
                <CardDescription>Lightning-fast development with Vite</CardDescription>
              </CardHeader>
              <CardContent>
                Experience instant HMR and optimized builds for production.
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Modern</CardTitle>
                <CardDescription>Built with the latest technologies</CardDescription>
              </CardHeader>
              <CardContent>
                React 18, TypeScript, and Tailwind CSS v4 for modern development.
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Beautiful</CardTitle>
                <CardDescription>Stunning UI components</CardDescription>
              </CardHeader>
              <CardContent>
                Pre-built components from shadcn/ui ready to customize.
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

echo "Creating AboutPage component..."
cat > src/pages/about/AboutPage.tsx << 'EOF'
import Header from "@/components/layouts/Header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-2xl mx-auto">
          <Card>
            <CardHeader>
              <CardTitle className="text-3xl">About This Project</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <p>
                This is a modern React application bootstrapped with Vite and enhanced
                with shadcn/ui components.
              </p>
              <p>
                It features a clean project structure, TypeScript support, and a
                beautiful UI built with Tailwind CSS v4.
              </p>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  );
}
EOF

echo "Installing react-router-dom..."
npm install react-router-dom

echo "Creating ThemeContext..."
cat > src/contexts/ThemeContext.tsx << 'EOF'
import { createContext, useContext, useEffect, useState } from "react";

type Theme = "light" | "dark";

interface ThemeContextType {
  theme: Theme;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>(() => {
    return (localStorage.getItem("theme") as Theme) || "light";
  });

  useEffect(() => {
    const root = document.documentElement;
    root.classList.remove("light", "dark");
    root.classList.add(theme);
    localStorage.setItem("theme", theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme((prev) => (prev === "light" ? "dark" : "light"));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) throw new Error("useTheme must be used within a ThemeProvider");
  return context;
}
EOF

echo "Updating App.tsx..."
cat > src/App.tsx << 'EOF'
import { RouterProvider } from "react-router-dom";
import { TooltipProvider } from "@/components/ui/tooltip";
import { ThemeProvider } from "@/contexts/ThemeContext";
import { router } from "./routes";

function App() {
  return (
    <ThemeProvider>
      <TooltipProvider>
        <RouterProvider router={router} />
      </TooltipProvider>
    </ThemeProvider>
  );
}

export default App;
EOF

echo "Setup complete! Run 'npm run dev' to start the development server."