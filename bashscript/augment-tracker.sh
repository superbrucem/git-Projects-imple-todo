#!/bin/bash

# =============================================================================
# Augment Code Progress Tracker
# =============================================================================
# Description: Simple script to track progress and update instruction files
# Usage: ./augment-tracker.sh [command] [options]
# =============================================================================

INSTRUCTIONS_FILE="augment-instructions.md"
LOG_FILE="augment-progress.log"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Functions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

show_help() {
    echo -e "${BLUE}Augment Code Progress Tracker${NC}"
    echo "================================"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  init                    Create new instruction file"
    echo "  status                  Show current progress"
    echo "  complete <task>         Mark task as completed"
    echo "  start <task>            Mark task as in progress"
    echo "  block <task> <reason>   Mark task as blocked"
    echo "  add <task>              Add new task"
    echo "  log <message>           Add log entry"
    echo "  summary                 Show project summary"
    echo ""
    echo "Examples:"
    echo "  $0 complete 'Set up project structure'"
    echo "  $0 start 'User authentication system'"
    echo "  $0 block 'API integration' 'Waiting for API docs'"
    echo "  $0 add 'Add unit tests for auth component'"
}

init_instructions() {
    if [ -f "$INSTRUCTIONS_FILE" ]; then
        echo -e "${YELLOW}⚠️  Instructions file already exists${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
    
    cp augment-instructions.md "$INSTRUCTIONS_FILE" 2>/dev/null || {
        echo -e "${RED}❌ Template file not found. Please ensure augment-instructions.md exists${NC}"
        exit 1
    }
    
    echo -e "${GREEN}✅ Instructions file created: $INSTRUCTIONS_FILE${NC}"
    echo -e "${BLUE}📝 Please edit the file with your project details${NC}"
    log_action "Initialized instructions file"
}

show_status() {
    if [ ! -f "$INSTRUCTIONS_FILE" ]; then
        echo -e "${RED}❌ Instructions file not found. Run '$0 init' first${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📊 Current Project Status${NC}"
    echo "=========================="
    
    # Extract project name
    project_name=$(grep "^**Project Name**:" "$INSTRUCTIONS_FILE" | sed 's/.*: \[\(.*\)\]/\1/')
    echo -e "${GREEN}Project:${NC} $project_name"
    
    # Show completed tasks
    echo -e "\n${GREEN}✅ Completed Tasks:${NC}"
    grep "^- \[x\]" "$INSTRUCTIONS_FILE" | sed 's/^- \[x\] ~~\(.*\)~~/  • \1/' || echo "  None yet"
    
    # Show in-progress tasks
    echo -e "\n${YELLOW}🔄 In Progress:${NC}"
    grep -A 10 "### Current Focus" "$INSTRUCTIONS_FILE" | grep "^- \[ \] \*\*IN PROGRESS\*\*" | sed 's/^- \[ \] \*\*IN PROGRESS\*\*: \(.*\)/  • \1/' || echo "  None"
    
    # Show blocked tasks
    echo -e "\n${RED}🚫 Blocked:${NC}"
    grep "^- \[ \] \*\*BLOCKED\*\*" "$INSTRUCTIONS_FILE" | sed 's/^- \[ \] \*\*BLOCKED\*\*: \(.*\)/  • \1/' || echo "  None"
    
    # Show next tasks
    echo -e "\n${BLUE}📋 Next Up:${NC}"
    grep -A 5 "### Next Up" "$INSTRUCTIONS_FILE" | grep "^- \[ \]" | head -3 | sed 's/^- \[ \] \(.*\)/  • \1/'
}

complete_task() {
    local task="$1"
    if [ -z "$task" ]; then
        echo -e "${RED}❌ Task description required${NC}"
        exit 1
    fi
    
    # Update the instructions file
    local date=$(date '+%Y-%m-%d')
    sed -i.bak "s/^- \[ \] \*\*IN PROGRESS\*\*: $task/- [x] ~~$task~~ ($date)/" "$INSTRUCTIONS_FILE"
    sed -i.bak "s/^- \[ \] $task/- [x] ~~$task~~ ($date)/" "$INSTRUCTIONS_FILE"
    
    echo -e "${GREEN}✅ Marked as completed: $task${NC}"
    log_action "COMPLETED: $task"
}

start_task() {
    local task="$1"
    if [ -z "$task" ]; then
        echo -e "${RED}❌ Task description required${NC}"
        exit 1
    fi
    
    # Update the instructions file
    sed -i.bak "s/^- \[ \] $task/- [ ] **IN PROGRESS**: $task/" "$INSTRUCTIONS_FILE"
    
    echo -e "${YELLOW}🔄 Started: $task${NC}"
    log_action "STARTED: $task"
}

block_task() {
    local task="$1"
    local reason="$2"
    if [ -z "$task" ] || [ -z "$reason" ]; then
        echo -e "${RED}❌ Task description and reason required${NC}"
        exit 1
    fi
    
    # Update the instructions file
    sed -i.bak "s/^- \[ \] $task/- [ ] **BLOCKED**: $task - $reason/" "$INSTRUCTIONS_FILE"
    
    echo -e "${RED}🚫 Blocked: $task${NC}"
    echo -e "   Reason: $reason"
    log_action "BLOCKED: $task - $reason"
}

add_task() {
    local task="$1"
    if [ -z "$task" ]; then
        echo -e "${RED}❌ Task description required${NC}"
        exit 1
    fi
    
    # Add to Next Up section
    sed -i.bak "/### Next Up/a\\
- [ ] $task" "$INSTRUCTIONS_FILE"
    
    echo -e "${BLUE}📝 Added task: $task${NC}"
    log_action "ADDED: $task"
}

add_log() {
    local message="$1"
    if [ -z "$message" ]; then
        echo -e "${RED}❌ Log message required${NC}"
        exit 1
    fi
    
    log_action "NOTE: $message"
    echo -e "${BLUE}📝 Logged: $message${NC}"
}

show_summary() {
    if [ ! -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}⚠️  No log file found${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📈 Project Summary${NC}"
    echo "=================="
    
    local total_completed=$(grep "COMPLETED:" "$LOG_FILE" | wc -l)
    local total_started=$(grep "STARTED:" "$LOG_FILE" | wc -l)
    local total_blocked=$(grep "BLOCKED:" "$LOG_FILE" | wc -l)
    
    echo -e "${GREEN}Completed Tasks: $total_completed${NC}"
    echo -e "${YELLOW}Started Tasks: $total_started${NC}"
    echo -e "${RED}Blocked Tasks: $total_blocked${NC}"
    
    echo -e "\n${BLUE}Recent Activity:${NC}"
    tail -10 "$LOG_FILE" | while read line; do
        echo "  $line"
    done
}

# Main script logic
case "$1" in
    "init")
        init_instructions
        ;;
    "status")
        show_status
        ;;
    "complete")
        complete_task "$2"
        ;;
    "start")
        start_task "$2"
        ;;
    "block")
        block_task "$2" "$3"
        ;;
    "add")
        add_task "$2"
        ;;
    "log")
        add_log "$2"
        ;;
    "summary")
        show_summary
        ;;
    "help"|"-h"|"--help"|"")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
