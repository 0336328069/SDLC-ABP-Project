#!/bin/bash

# ABP Enterprise App - Automated Setup Script
# For Linux/macOS

set -e

echo "🚀 ABP Enterprise App - Automated Setup"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing_deps=()
    
    if ! command_exists "dotnet"; then
        missing_deps+=(".NET 8 SDK")
    fi
    
    if ! command_exists "node"; then
        missing_deps+=("Node.js 20+")
    fi
    
    if ! command_exists "docker"; then
        missing_deps+=("Docker")
    fi
    
    if ! command_exists "docker-compose"; then
        missing_deps+=("Docker Compose")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "Please install the missing dependencies and run this script again."
        exit 1
    fi
    
    log_success "All prerequisites are installed"
}

# Setup environment variables
setup_env() {
    log_info "Setting up environment variables..."
    
    if [ ! -f ".env" ]; then
        cp .env.example .env
        log_success "Created .env file from template"
    else
        log_warning ".env file already exists, skipping..."
    fi
    
    # Frontend env
    if [ ! -f "src/frontend/.env.local" ]; then
        cat > src/frontend/.env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:44300
NEXT_PUBLIC_SIGNALR_URL=http://localhost:44300
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=ABP Enterprise App
NEXT_PUBLIC_SUPPORT_EMAIL=support@abpapp.com
EOF
        log_success "Created frontend .env.local file"
    else
        log_warning "Frontend .env.local file already exists, skipping..."
    fi
}

# Install backend dependencies
install_backend() {
    log_info "Installing backend dependencies..."
    
    cd src/backend
    dotnet restore
    cd ../..
    
    log_success "Backend dependencies installed"
}

# Install frontend dependencies
install_frontend() {
    log_info "Installing frontend dependencies..."
    
    cd src/frontend
    npm install
    cd ../..
    
    log_success "Frontend dependencies installed"
}

# Start infrastructure services
start_infrastructure() {
    log_info "Starting infrastructure services (PostgreSQL, Redis, RabbitMQ)..."
    
    docker-compose up -d postgres redis rabbitmq seq
    
    # Wait for services to be ready
    log_info "Waiting for services to be ready..."
    sleep 30
    
    log_success "Infrastructure services started"
}

# Setup database
setup_database() {
    log_info "Setting up database..."
    
    cd src/backend
    
    # Run migrations
    log_info "Running database migrations..."
    dotnet ef database update --project src/AbpApp.EntityFrameworkCore
    
    # Seed data
    log_info "Seeding initial data..."
    dotnet run --project tools/AbpApp.DbMigrator
    
    cd ../..
    
    log_success "Database setup completed"
}

# Build projects
build_projects() {
    log_info "Building projects..."
    
    # Build backend
    log_info "Building backend..."
    cd src/backend
    dotnet build
    cd ../..
    
    # Build frontend
    log_info "Building frontend..."
    cd src/frontend
    npm run build
    cd ../..
    
    log_success "Projects built successfully"
}

# Start development servers
start_dev_servers() {
    log_info "Starting development servers..."
    
    # Create tmux session if available
    if command_exists "tmux"; then
        tmux new-session -d -s abp-dev
        
        # Backend window
        tmux new-window -t abp-dev -n backend
        tmux send-keys -t abp-dev:backend "cd src/backend && dotnet watch run --project src/AbpApp.HttpApi.Host" C-m
        
        # Frontend window
        tmux new-window -t abp-dev -n frontend
        tmux send-keys -t abp-dev:frontend "cd src/frontend && npm run dev" C-m
        
        log_success "Development servers started in tmux session 'abp-dev'"
        log_info "Use 'tmux attach -t abp-dev' to attach to the session"
        log_info "Use Ctrl+B then d to detach from tmux session"
    else
        log_warning "tmux not found. Starting servers in background..."
        
        # Start backend in background
        cd src/backend
        nohup dotnet watch run --project src/AbpApp.HttpApi.Host > ../../logs/backend.log 2>&1 &
        BACKEND_PID=$!
        cd ../..
        
        # Start frontend in background
        cd src/frontend
        nohup npm run dev > ../../logs/frontend.log 2>&1 &
        FRONTEND_PID=$!
        cd ../..
        
        # Save PIDs
        mkdir -p .tmp
        echo $BACKEND_PID > .tmp/backend.pid
        echo $FRONTEND_PID > .tmp/frontend.pid
        
        log_success "Development servers started in background"
        log_info "Backend PID: $BACKEND_PID (log: logs/backend.log)"
        log_info "Frontend PID: $FRONTEND_PID (log: logs/frontend.log)"
    fi
}

# Print completion message
print_completion() {
    echo ""
    echo "🎉 Setup completed successfully!"
    echo "================================"
    echo ""
    echo "📍 Services:"
    echo "  - Frontend:      http://localhost:3000"
    echo "  - Backend API:   http://localhost:44300"
    echo "  - Swagger UI:    http://localhost:44300/swagger"
    echo "  - Seq Logs:      http://localhost:5341"
    echo "  - RabbitMQ:      http://localhost:15672 (admin/admin123)"
    echo ""
    echo "👤 Default Admin User:"
    echo "  - Username: admin"
    echo "  - Password: 1q2w3E*"
    echo ""
    echo "🔧 Useful Commands:"
    echo "  - Stop all:      docker-compose down"
    echo "  - View logs:     docker-compose logs -f"
    echo "  - Reset DB:      npm run db:reset"
    echo ""
}

# Cleanup function
cleanup() {
    log_info "Cleaning up..."
    # Kill background processes if they exist
    if [ -f ".tmp/backend.pid" ]; then
        kill -9 $(cat .tmp/backend.pid) 2>/dev/null || true
        rm .tmp/backend.pid
    fi
    if [ -f ".tmp/frontend.pid" ]; then
        kill -9 $(cat .tmp/frontend.pid) 2>/dev/null || true
        rm .tmp/frontend.pid
    fi
}

# Trap to cleanup on exit
trap cleanup EXIT

# Main execution
main() {
    # Create logs directory
    mkdir -p logs
    
    # Parse command line arguments
    SKIP_BUILD=false
    SKIP_DEV=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-build)
                SKIP_BUILD=true
                shift
                ;;
            --skip-dev)
                SKIP_DEV=true
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --skip-build    Skip building projects"
                echo "  --skip-dev      Skip starting development servers"
                echo "  --help          Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Execute setup steps
    check_prerequisites
    setup_env
    install_backend
    install_frontend
    start_infrastructure
    setup_database
    
    if [ "$SKIP_BUILD" = false ]; then
        build_projects
    fi
    
    if [ "$SKIP_DEV" = false ]; then
        start_dev_servers
    fi
    
    print_completion
}

# Run main function
main "$@"